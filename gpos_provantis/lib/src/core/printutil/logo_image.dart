import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart' show SvgBytesLoader;
import 'package:vector_graphics/vector_graphics.dart' show vg;
import 'package:image/image.dart' as img;

Future<img.Image?> decodeBranchLogo(
  String rawLogo, {
  required int maxWidthPx,
  required int maxHeightPx,
}) async {
  final raw = rawLogo.trim();
  if (raw.isEmpty) return null;

  final bytes = _decodeBase64Payload(raw);
  if (bytes == null) return null;

  final format = _sniffLogoFormat(bytes);
  switch (format) {
    case _LogoFormat.svg:
      return _rasterizeSvg(
        bytes,
        maxWidthPx: maxWidthPx,
        maxHeightPx: maxHeightPx,
      );
    case _LogoFormat.raster:
      return _decodeRaster(
        bytes,
        maxWidthPx: maxWidthPx,
        maxHeightPx: maxHeightPx,
      );
  }
}

Future<img.Image?> decodeBranchLogoForTicket(
  String rawLogo, {
  required int maxWidthPx,
  required int maxHeightPx,
}) =>
    decodeBranchLogo(rawLogo, maxWidthPx: maxWidthPx, maxHeightPx: maxHeightPx);

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
  } on FormatException {}

  return _LogoFormat.raster;
}

img.Image? _decodeRaster(
  Uint8List bytes, {
  required int maxWidthPx,
  required int maxHeightPx,
}) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  final fitted = _fitWithinBox(
    srcWidth: decoded.width,
    srcHeight: decoded.height,
    maxWidth: maxWidthPx,
    maxHeight: maxHeightPx,
  );
  return img.copyResize(decoded, width: fitted.width, height: fitted.height);
}

({int width, int height}) _fitWithinBox({
  required int srcWidth,
  required int srcHeight,
  required int maxWidth,
  required int maxHeight,
}) {
  if (srcWidth <= 0 || srcHeight <= 0) {
    return (width: maxWidth, height: maxHeight);
  }

  final widthScale = maxWidth / srcWidth;
  final heightScale = maxHeight / srcHeight;
  final scale = math.min(1.0, math.min(widthScale, heightScale));

  final width = (srcWidth * scale).round().clamp(1, maxWidth);
  final height = (srcHeight * scale).round().clamp(1, maxHeight);
  return (width: width, height: height);
}

Future<img.Image?> _rasterizeSvg(
  Uint8List svgBytes, {
  required int maxWidthPx,
  required int maxHeightPx,
}) async {
  try {
    final pictureInfo = await vg.loadPicture(SvgBytesLoader(svgBytes), null);
    final srcSize = pictureInfo.size;
    if (srcSize.width <= 0 || srcSize.height <= 0) return null;

    final fitted = _fitWithinBox(
      srcWidth: srcSize.width.round(),
      srcHeight: srcSize.height.round(),
      maxWidth: maxWidthPx,
      maxHeight: maxHeightPx,
    );
    final targetWidthPx = fitted.width;
    final targetHeightPx = fitted.height;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

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
    return null;
  }
}
