import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../screens/settings_shared.dart';

/// One bundled PDF guide. To add another, put the PDF under `assets/guides/`
/// (declared in pubspec.yaml) and add an entry to [_guides].
class _Guide {
  const _Guide({
    required this.id,
    required this.tabLabel,
    required this.title,
    required this.icon,
    required this.assetPath,
  });

  final String id;

  /// Short label for the selector (kept short so it fits on a phone).
  final String tabLabel;
  final String title;
  final IconData icon;
  final String assetPath;
}

const _guides = [
  _Guide(
    id: 'quick-start',
    tabLabel: 'Quick Start',
    title: 'Quick Start Guide',
    icon: Icons.rocket_launch_rounded,
    assetPath: 'assets/guides/quick_start_guide.pdf',
  ),
  _Guide(
    id: 'setup',
    tabLabel: 'Setup',
    title: 'Setup Guide',
    icon: Icons.settings_suggest_rounded,
    assetPath: 'assets/guides/setup_guide.pdf',
  ),
  _Guide(
    id: 'user',
    tabLabel: 'User Guide',
    title: 'User Guide',
    icon: Icons.menu_book_rounded,
    assetPath: 'assets/guides/user_guide.pdf',
  ),
];

_Guide _guideById(String id) =>
    _guides.firstWhere((g) => g.id == id, orElse: () => _guides.first);

class GuidesPanel extends StatefulWidget {
  const GuidesPanel();

  @override
  State<GuidesPanel> createState() => _GuidesPanelState();
}

class _GuidesPanelState extends State<GuidesPanel> {
  String _selectedId = _guides.first.id;

  void _openFullScreen(_Guide guide) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _FullScreenGuide(guide: guide),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final compact = isCompactLayout(context);
    final guide = _guideById(_selectedId);

    return Padding(
      padding: settingsPanelPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // On a phone the top bar already says "Guides"; give the space to
          // the document instead.
          if (!compact) ...[
            const PanelHeader(
              title: 'Guides',
              subtitle: 'Quick start, setup, and user manuals',
            ),
            const SizedBox(height: Space.lg),
          ],
          SegmentedTouchControl(
            options: [for (final g in _guides) g.id],
            selected: _selectedId,
            iconFor: (id) => _guideById(id).icon,
            labelFor: (id) => _guideById(id).tabLabel,
            onSelected: (id) => setState(() => _selectedId = id),
          ),
          const SizedBox(height: Space.lg),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: _GuideViewer(
                key: ValueKey(guide.id),
                guide: guide,
                onFullScreen: () => _openFullScreen(guide),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The same viewer, filling the whole screen (handy on a phone).
class _FullScreenGuide extends StatelessWidget {
  const _FullScreenGuide({required this.guide});

  final _Guide guide;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          guide.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(top: false, child: _GuideViewer(guide: guide)),
    );
  }
}

class _GuideViewer extends StatefulWidget {
  const _GuideViewer({super.key, required this.guide, this.onFullScreen});

  final _Guide guide;

  /// Shows a full-screen button in the page bar when provided.
  final VoidCallback? onFullScreen;

  @override
  State<_GuideViewer> createState() => _GuideViewerState();
}

class _GuideViewerState extends State<_GuideViewer> {
  final _controller = PdfViewerController();

  late final Future<bool> _assetExists = _checkAssetExists(
    widget.guide.assetPath,
  );

  int _page = 1;
  int? _pageCount;

  /// Lets the panel say "not installed yet" instead of showing a viewer
  /// error when a PDF hasn't been added to the app's assets.
  static Future<bool> _checkAssetExists(String path) async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest.listAssets().contains(path);
    } catch (_) {
      // If the manifest can't be read, let the viewer try anyway.
      return true;
    }
  }

  void _goTo(int page) {
    final count = _pageCount;
    if (count == null) return;
    _controller.goToPage(pageNumber: page.clamp(1, count));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FutureBuilder<bool>(
      future: _assetExists,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == false) {
          return _MissingGuide(guide: widget.guide);
        }

        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PdfViewer.asset(
                    widget.guide.assetPath,
                    controller: _controller,
                    params: PdfViewerParams(
                      backgroundColor: colors.surfaceVariant,
                      onViewerReady: (document, controller) {
                        if (!mounted) return;
                        setState(() => _pageCount = document.pages.length);
                      },
                      onPageChanged: (page) {
                        if (page == null || !mounted) return;
                        setState(() => _page = page);
                      },
                    ),
                  ),
                  if (_pageCount == null)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            _PageBar(
              page: _page,
              pageCount: _pageCount,
              onPrevious: () => _goTo(_page - 1),
              onNext: () => _goTo(_page + 1),
              onFullScreen: widget.onFullScreen,
            ),
          ],
        );
      },
    );
  }
}

class _PageBar extends StatelessWidget {
  const _PageBar({
    required this.page,
    required this.pageCount,
    required this.onPrevious,
    required this.onNext,
    this.onFullScreen,
  });

  final int page;
  final int? pageCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onFullScreen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = pageCount;
    final canPrevious = count != null && page > 1;
    final canNext = count != null && page < count;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: Space.xs),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 28,
            tooltip: 'Previous page',
            onPressed: canPrevious ? onPrevious : null,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: canPrevious ? colors.textPrimary : colors.textDisabled,
            ),
          ),
          Expanded(
            child: Text(
              count == null ? 'Loading…' : 'Page $page of $count',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.ui(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
          IconButton(
            iconSize: 28,
            tooltip: 'Next page',
            onPressed: canNext ? onNext : null,
            icon: Icon(
              Icons.chevron_right_rounded,
              color: canNext ? colors.textPrimary : colors.textDisabled,
            ),
          ),
          if (onFullScreen != null)
            IconButton(
              iconSize: 24,
              tooltip: 'Full screen',
              onPressed: onFullScreen,
              icon: Icon(Icons.fullscreen_rounded, color: colors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _MissingGuide extends StatelessWidget {
  const _MissingGuide({required this.guide});

  final _Guide guide;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.find_in_page_outlined,
              size: 48,
              color: colors.textDisabled,
            ),
            const SizedBox(height: Space.lg),
            Text(
              "${guide.title} isn't installed yet",
              textAlign: TextAlign.center,
              style: AppTypography.display(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: Space.sm),
            Text(
              "Add ${guide.assetPath} to the app's assets and rebuild.",
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
