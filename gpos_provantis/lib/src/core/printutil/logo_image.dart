import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart' show SvgBytesLoader;
import 'package:vector_graphics/vector_graphics.dart' show vg;
import 'package:image/image.dart' as img;

/// Turns `BranchConfigDto.logo` (a base64-encoded image string — see
/// `BranchConfigDto`) into an `img.Image` a thermal-printer `Generator`
/// can print via `generator.image(...)` / `generator.imageRaster(...)`.
///
/// Mirrors `top_bar.dart`'s `_decodeLogoBytes`/`_sniffLogoFormat` exactly
/// for the decode-and-sniff step (same base64/data-URI handling, same
/// SVG-vs-raster sniff by leading `<?xml`/`<svg`), since that logic has
/// nothing to do with Flutter's widget tree and is already proven against
/// real branch logo data. What differs is what happens *after* sniffing:
/// `top_bar.dart` hands the bytes to a widget (`SvgPicture.memory` /
/// `Image.memory`) that Flutter renders on-screen; a receipt has no
/// widget tree to render into, so this file rasterizes both cases down
/// to a plain `img.Image` (a decoded pixel grid) instead:
///   - Raster (PNG/JPEG/WebP/GIF/BMP/...) — decoded directly via
///     `package:image`'s `img.decodeImage`.
///   - SVG — rasterized via `dart:ui` (`PictureRecorder` + `Canvas` +
///     `Picture.toImage`), which needs no mounted widget or `BuildContext`
///     but does need to run on an isolate with `dart:ui` available (the
///     main/UI isolate — confirmed `printForSale` runs there, not inside
///     `compute()`). There is no pure-Dart, non-Flutter SVG rasterizer
///     available here, so `dart:ui` is the only option; if logo
///     rendering is ever moved to a background isolate, this SVG branch
///     will need to move with it (or be pre-rasterized before handoff).
///
/// Every failure path returns `null` — exactly like `top_bar.dart` — so a
/// bad/missing logo silently skips the logo on the ticket rather than
/// throwing and blocking the sale from printing at all.
Future<img.Image?> decodeBranchLogo(
  String rawLogo, {
  required int targetWidthPx,
}) async {
  final raw = rawLogo.trim();
  if (raw.isEmpty) return null;

  final bytes = _decodeBase64Payload(raw);
  if (bytes == null) return null;

  final format = _sniffLogoFormat(bytes);
  switch (format) {
    case _LogoFormat.svg:
      return _rasterizeSvg(bytes, targetWidthPx: targetWidthPx);
    case _LogoFormat.raster:
      return _decodeRaster(bytes, targetWidthPx: targetWidthPx);
  }
}

/// Convenience alias kept for call-site clarity: `esc_pos_utils_plus`'s
/// `Generator.image(img.Image image, ...)` / `.imageRaster(...)` both take
/// a `package:image` `Image` object directly — there is no separate
/// wrapper type to convert to, so this is the same value `decodeBranchLogo`
/// returns. Callers can use either name; this one just reads slightly
/// clearer at a `generator.image(...)` call site.
Future<img.Image?> decodeBranchLogoForTicket(
  String rawLogo, {
  required int targetWidthPx,
}) => decodeBranchLogo(rawLogo, targetWidthPx: targetWidthPx);

/// Strips a `data:image/...;base64,` prefix if present (some upload
/// flows store the whole data URI rather than stripping it server-side),
/// then base64-decodes the remaining payload. `base64.normalize` fixes up
/// missing `=` padding, same as `top_bar.dart`. Returns `null` for empty
/// input or anything that isn't valid base64 — never throws.
Uint8List? _decodeBase64Payload(String raw) {
  final commaIndex = raw.indexOf(',');
  final looksLikeDataUri = raw.startsWith('data:') && commaIndex != -1;
  final payload = looksLikeDataUri ? raw.substring(commaIndex + 1) : raw;

  if (payload.isEmpty) return null;

  try {
    return base64.decode(base64.normalize(payload));
  } on FormatException {
    return null;
  }
}

enum _LogoFormat { svg, raster }

/// Identical logic to `top_bar.dart`'s `_sniffLogoFormat`: decodes up to
/// the first ~200 bytes as UTF-8, strips a possible BOM, and checks for a
/// leading `<?xml` or `<svg` (case-insensitive). Anything that isn't
/// valid UTF-8 text at all — true of real raster bytes — is itself
/// evidence this isn't SVG and falls through to `_LogoFormat.raster`.
_LogoFormat _sniffLogoFormat(Uint8List bytes) {
  if (bytes.isEmpty) return _LogoFormat.raster;

  final sampleLength = bytes.length < 200 ? bytes.length : 200;
  final sample = bytes.sublist(0, sampleLength);

  try {
    final text = utf8.decode(sample, allowMalformed: false);
    final withoutBom = text.startsWith('\uFEFF') ? text.substring(1) : text;
    final lower = withoutBom.trimLeft().toLowerCase();
    if (lower.startsWith('<?xml') || lower.startsWith('<svg')) {
      return _LogoFormat.svg;
    }
  } on FormatException {
    // Not valid UTF-8 — treat as raster, same as top_bar.dart.
  }

  return _LogoFormat.raster;
}

/// Decodes raster bytes (PNG/JPEG/WebP/GIF/BMP/...) via `package:image`
/// and resizes to [targetWidthPx] wide, preserving aspect ratio, so the
/// logo fits the printable width of whatever paper size is in use.
/// Returns `null` if `package:image` can't recognize the bytes as a real,
/// complete image (corrupt/truncated data) — same "degrade to no logo"
/// behavior as every other failure path here.
img.Image? _decodeRaster(Uint8List bytes, {required int targetWidthPx}) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  return img.copyResize(decoded, width: targetWidthPx);
}

/// Rasterizes SVG markup to a `img.Image` of [targetWidthPx] wide via
/// `dart:ui`, with no widget tree or `BuildContext` involved.
///
/// This still needs `flutter_svg`'s parser to turn the markup into a
/// `ui.Picture` (there's no pure-`dart:ui` SVG parser — `dart:ui` only
/// draws already-parsed vector commands, it doesn't understand SVG/XML
/// itself), then draws that picture onto an explicit-size canvas and
/// reads back PNG bytes via `ui.Image.toByteData`, which `package:image`
/// re-decodes into its own `img.Image` type so the rest of this file
/// only ever deals with one image representation. Returns `null` if the
/// markup isn't valid/parseable XML or otherwise fails — matching
/// `top_bar.dart`'s `SvgPicture.memory` `errorBuilder` fallback.
Future<img.Image?> _rasterizeSvg(
  Uint8List svgBytes, {
  required int targetWidthPx,
}) async {
  try {
    // `vg.loadPicture` (from `package:vector_graphics`, re-exported by
    // `flutter_svg` v2+) parses the SVG/vector-graphics bytes into a
    // `PictureInfo` — no widget tree or `BuildContext` involved, only
    // `dart:ui` underneath. `SvgBytesLoader` is `flutter_svg`'s loader
    // for raw SVG bytes already in memory (mirrors `SvgPicture.memory`'s
    // own loader internally). The `null` second argument is the
    // `BuildContext?` `loadPicture` accepts for theme/text-direction
    // inheritance — not needed for a plain logo with no such context.
    final pictureInfo = await vg.loadPicture(SvgBytesLoader(svgBytes), null);
    final srcSize = pictureInfo.size;
    if (srcSize.width <= 0 || srcSize.height <= 0) return null;

    final targetHeightPx = (targetWidthPx * srcSize.height / srcSize.width)
        .round()
        .clamp(1, 1 << 16);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    // White background — thermal printers render on white paper with
    // black ink only; an SVG with transparent background would otherwise
    // print whatever's "underneath" as black once dithered.
    canvas.drawRect(
      ui.Rect.fromLTWH(
        0,
        0,
        targetWidthPx.toDouble(),
        targetHeightPx.toDouble(),
      ),
      ui.Paint()..color = const ui.Color(0xFFFFFFFF),
    );
    final scale = targetWidthPx / srcSize.width;
    canvas.scale(scale, scale);
    canvas.drawPicture(pictureInfo.picture);
    final picture = recorder.endRecording();

    final uiImage = await picture.toImage(targetWidthPx, targetHeightPx);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    return img.decodePng(byteData.buffer.asUint8List());
  } catch (_) {
    // Any failure in the SVG pipeline (malformed markup, an element
    // flutter_svg can't parse, etc.) degrades to "no logo," never a
    // crash — same contract as every other branch in this file.
    return null;
  }
}
