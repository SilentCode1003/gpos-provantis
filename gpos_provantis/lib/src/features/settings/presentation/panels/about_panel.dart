import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../screens/settings_shared.dart';
import 'font_licenses.dart';

const _providerName = '5L Solutions Supply & Allied Services Corp.';

typedef _Row = (String label, String value);

class _AboutData {
  const _AboutData({
    required this.appName,
    required this.version,
    required this.build,
    required this.device,
  });

  final String appName;
  final String version;
  final String build;
  final List<_Row> device;
}

Future<_AboutData> _loadAboutData() async {
  final info = await PackageInfo.fromPlatform();
  final device = await _readDevice();
  return _AboutData(
    appName: info.appName.isEmpty ? 'GPOS Provantis' : info.appName,
    version: info.version,
    build: info.buildNumber,
    device: device,
  );
}

Future<List<_Row>> _readDevice() async {
  final plugin = DeviceInfoPlugin();
  try {
    if (Platform.isWindows) {
      final i = await plugin.windowsInfo;
      return [
        ('Device name', i.computerName),
        ('Operating system', i.productName),
        ('Processor cores', '${i.numberOfCores}'),
        (
          'Memory',
          '${(i.systemMemoryInMegabytes / 1024).toStringAsFixed(1)} GB',
        ),
      ];
    }
    if (Platform.isAndroid) {
      final i = await plugin.androidInfo;
      return [
        ('Device', '${i.manufacturer} ${i.model}'),
        ('Operating system', 'Android ${i.version.release}'),
      ];
    }
    if (Platform.isMacOS) {
      final i = await plugin.macOsInfo;
      return [
        ('Device name', i.computerName),
        ('Model', i.model),
        ('Operating system', 'macOS ${i.osRelease}'),
      ];
    }
    if (Platform.isLinux) {
      final i = await plugin.linuxInfo;
      return [('Operating system', i.prettyName)];
    }
    if (Platform.isIOS) {
      final i = await plugin.iosInfo;
      return [
        ('Device name', i.name),
        ('Model', i.model),
        ('Operating system', '${i.systemName} ${i.systemVersion}'),
      ];
    }
  } catch (_) {
    // Fall through to the generic answer below.
  }
  return [('Operating system', Platform.operatingSystem)];
}

class AboutPanel extends StatefulWidget {
  const AboutPanel();

  @override
  State<AboutPanel> createState() => _AboutPanelState();
}

class _AboutPanelState extends State<AboutPanel> {
  late final Future<_AboutData> _future = _loadAboutData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AboutData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _AboutContent(data: data);
      },
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.data});

  final _AboutData data;

  void _openLicenses(BuildContext context) {
    registerFontLicenses();
    showLicensePage(
      context: context,
      applicationName: data.appName,
      applicationVersion: '${data.version} (build ${data.build})',
      applicationLegalese: 'Provided by $_providerName',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Space.xxl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelHeader(
                title: 'About',
                subtitle: 'App version, device details, and licenses.',
              ),
              const SizedBox(height: Space.xxl),
              _InfoCard(
                title: 'Application',
                rows: [
                  ('Name', data.appName),
                  ('Version', data.version),
                  ('Build number', data.build),
                ],
              ),
              const SizedBox(height: Space.lg),
              _InfoCard(title: 'This device', rows: data.device),
              const SizedBox(height: Space.lg),
              const _ProviderCard(),
              const SizedBox(height: Space.lg),
              _LinkTile(
                icon: Icons.article_outlined,
                title: 'Licenses',
                subtitle: 'Fonts and open-source libraries used in this app',
                onTap: () => _openLicenses(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.lg,
              Space.lg,
              Space.xs,
            ),
            child: Text(
              title.toUpperCase(),
              style: AppTypography.ui(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colors.borderSubtle),
            Container(
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.symmetric(
                horizontal: Space.lg,
                vertical: Space.md,
              ),
              child: Row(
                children: [
                  Text(
                    rows[i].$1,
                    style: AppTypography.ui(
                      fontSize: 15,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: Space.lg),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.right,
                      style: AppTypography.ui(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: Space.xs),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _CardShell(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_rounded,
                size: 22,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: Space.lg),
            Expanded(
              child: Text(
                'Provided by: $_providerName',
                style: AppTypography.ui(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceRaised,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: colors.primary),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.ui(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.ui(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: colors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}