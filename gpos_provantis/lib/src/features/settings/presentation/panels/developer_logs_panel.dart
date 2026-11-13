import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/services/app_logger.dart';

import '../screens/settings_shared.dart';

// ---------------------------------------------------------------------------
// Developer access
//
// This keeps cashiers out of the log screen. It is NOT strong security: the
// hash below ships inside the app. To change the password, compute
//   sha256("gpos-dev-v1:" + yourPassword)
// (e.g. `printf 'gpos-dev-v1:yourPassword' | sha256sum`) and paste the result
// into [_passwordHash]. Log entries never contain tokens or passwords.
// ---------------------------------------------------------------------------
const _salt = 'gpos-dev-v1';
const _passwordHash =
    '93409490f01992e3167d70559dde1e68e4dbb15a3eeadaee19592fde3839b4ee';
const _sessionLength = Duration(minutes: 10);
const _maxAttempts = 5;
const _lockoutLength = Duration(seconds: 60);

class DevAccessState {
  const DevAccessState({
    this.unlockedUntil,
    this.failedAttempts = 0,
    this.lockedOutUntil,
  });

  final DateTime? unlockedUntil;
  final int failedAttempts;
  final DateTime? lockedOutUntil;

  bool get isUnlocked =>
      unlockedUntil != null && DateTime.now().isBefore(unlockedUntil!);
}

class DevAccessController extends Notifier<DevAccessState> {
  @override
  DevAccessState build() => const DevAccessState();

  /// Returns null when unlocked, otherwise a message for the cashier/dev.
  String? tryUnlock(String input) {
    final now = DateTime.now();
    final lockout = state.lockedOutUntil;
    if (lockout != null && now.isBefore(lockout)) {
      final seconds = lockout.difference(now).inSeconds + 1;
      return 'Too many attempts. Try again in ${seconds}s.';
    }

    if (_matches(input)) {
      state = DevAccessState(unlockedUntil: now.add(_sessionLength));
      return null;
    }

    final failed = state.failedAttempts + 1;
    if (failed >= _maxAttempts) {
      state = DevAccessState(lockedOutUntil: now.add(_lockoutLength));
      return 'Too many attempts. Locked for ${_lockoutLength.inSeconds} '
          'seconds.';
    }
    state = DevAccessState(failedAttempts: failed);
    return 'Wrong password (${_maxAttempts - failed} tries left).';
  }

  void lock() => state = const DevAccessState();

  bool _matches(String input) {
    final digest = sha256
        .convert(utf8.encode('$_salt:${input.trim()}'))
        .toString();
    var diff = digest.length ^ _passwordHash.length;
    for (var i = 0; i < digest.length && i < _passwordHash.length; i++) {
      diff |= digest.codeUnitAt(i) ^ _passwordHash.codeUnitAt(i);
    }
    return diff == 0;
  }
}

final devAccessProvider = NotifierProvider<DevAccessController, DevAccessState>(
  DevAccessController.new,
);

// ---------------------------------------------------------------------------
// Panel
// ---------------------------------------------------------------------------

/// Settings > Developer: a console-style list of the important things the app
/// logged (failed or refused uploads, crashes, data clean-ups), behind a
/// developer password.
class DeveloperLogsPanel extends ConsumerStatefulWidget {
  const DeveloperLogsPanel({super.key});

  @override
  ConsumerState<DeveloperLogsPanel> createState() => _DeveloperLogsPanelState();
}

class _DeveloperLogsPanelState extends ConsumerState<DeveloperLogsPanel> {
  Timer? _expiryTimer;

  @override
  void initState() {
    super.initState();
    // Re-check the session so it locks itself when the time is up.
    _expiryTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final access = ref.watch(devAccessProvider);
    return access.isUnlocked ? const _LogsView() : const _LockedView();
  }
}

class _LockedView extends ConsumerStatefulWidget {
  const _LockedView();

  @override
  ConsumerState<_LockedView> createState() => _LockedViewState();
}

class _LockedViewState extends ConsumerState<_LockedView> {
  final _controller = TextEditingController();
  bool _hidden = true;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final error = ref
        .read(devAccessProvider.notifier)
        .tryUnlock(_controller.text);
    _controller.clear();
    setState(() => _error = error);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Space.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.lock_rounded, size: 40, color: colors.textSecondary),
              SizedBox(height: Space.md),
              Text(
                'Developer logs',
                textAlign: TextAlign.center,
                style: AppTypography.display(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: Space.sm),
              Text(
                'Enter the developer password to view the error log.',
                textAlign: TextAlign.center,
                style: AppTypography.ui(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: Space.lg),
              TextField(
                controller: _controller,
                obscureText: _hidden,
                autocorrect: false,
                enableSuggestions: false,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _error,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: _hidden ? 'Show' : 'Hide',
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  ),
                ),
              ),
              SizedBox(height: Space.md),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Unlock'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogsView extends ConsumerStatefulWidget {
  const _LogsView();

  @override
  ConsumerState<_LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends ConsumerState<_LogsView> {
  final _search = TextEditingController();
  String? _level; // null = all

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _copy(String text, String done) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) _toast(done);
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all logs?'),
        content: const Text('This only removes the developer log entries.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(appLogDaoProvider).clear();
      if (mounted) _toast('Logs cleared');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final logsAsync = ref.watch(appLogsProvider);
    final query = _search.text.trim().toLowerCase();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Space.md, Space.md, Space.md, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search OR number, message or source',
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: const OutlineInputBorder(),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(_search.clear),
                          ),
                  ),
                ),
              ),
              SizedBox(width: Space.sm),
              IconButton(
                tooltip: 'Add a test entry',
                icon: const Icon(Icons.bug_report_rounded),
                onPressed: () => ref
                    .read(appLoggerProvider)
                    .info('developer', 'Test entry from Settings > Developer'),
              ),
              IconButton(
                tooltip: 'Clear logs',
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: _confirmClear,
              ),
              IconButton(
                tooltip: 'Lock',
                icon: const Icon(Icons.lock_outline_rounded),
                onPressed: () => ref.read(devAccessProvider.notifier).lock(),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: Space.sm,
                  children: [
                    for (final option in const [
                      (null, 'All'),
                      ('ERROR', 'Errors'),
                      ('WARN', 'Warnings'),
                      ('INFO', 'Info'),
                    ])
                      ChoiceChip(
                        label: Text(option.$2),
                        selected: _level == option.$1,
                        onSelected: (_) => setState(() => _level = option.$1),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.borderSubtle),
        Expanded(
          child: logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Padding(
                padding: EdgeInsets.all(Space.lg),
                child: Text('Could not read the log: $error'),
              ),
            ),
            data: (logs) {
              final shown = logs.where((log) {
                if (_level != null && log.level != _level) return false;
                if (query.isEmpty) return true;
                final haystack =
                    '${log.message} ${log.source} ${log.detailId ?? ''} '
                            '${log.context ?? ''}'
                        .toLowerCase();
                return haystack.contains(query);
              }).toList();

              if (shown.isEmpty) {
                return Center(
                  child: Text(
                    logs.isEmpty
                        ? 'Nothing logged yet.'
                        : 'No matching entries.',
                    style: AppTypography.ui(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Space.md,
                      Space.sm,
                      Space.sm,
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${shown.length} entr${shown.length == 1 ? 'y' : 'ies'}'
                            '${logs.length >= 1000 ? ' (latest 1000 stored)' : ''}',
                            style: AppTypography.ui(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          label: const Text('Copy shown'),
                          onPressed: () => _copy(
                            shown.take(300).map(_entryToText).join('\n---\n'),
                            'Copied ${shown.length > 300 ? 300 : shown.length} '
                            'entries',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(Space.md),
                      itemCount: shown.length,
                      itemBuilder: (context, index) => _LogTile(
                        log: shown[index],
                        onCopy: () =>
                            _copy(_entryToText(shown[index]), 'Entry copied'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

String _formatTime(DateTime t) =>
    '${t.year}-${_two(t.month)}-${_two(t.day)} '
    '${_two(t.hour)}:${_two(t.minute)}:${_two(t.second)}';

String _prettyJson(String raw) {
  try {
    return const JsonEncoder.withIndent('  ').convert(jsonDecode(raw));
  } catch (_) {
    return raw;
  }
}

String _entryToText(AppLogTableData log) {
  final buffer = StringBuffer()
    ..writeln(
      '[${_formatTime(log.createdAt)}] ${log.level} ${log.source}'
      '${log.detailId == null ? '' : '  OR ${log.detailId}'}',
    )
    ..writeln(log.message);
  if (log.context != null) buffer.writeln(_prettyJson(log.context!));
  if (log.stackTrace != null) buffer.writeln(log.stackTrace);
  return buffer.toString().trimRight();
}

Color _levelColor(BuildContext context, String level) {
  switch (level) {
    case 'ERROR':
      return Colors.red.shade400;
    case 'WARN':
      return Colors.orange.shade600;
    default:
      return context.colors.textSecondary;
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log, required this.onCopy});

  final AppLogTableData log;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final levelColor = _levelColor(context, log.level);
    final mono = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      height: 1.35,
      color: colors.textPrimary,
    );

    return Container(
      margin: EdgeInsets.only(bottom: Space.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: Space.md),
          childrenPadding: EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              log.level,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: levelColor,
              ),
            ),
          ),
          title: Text(
            log.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.ui(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          subtitle: Text(
            '${_formatTime(log.createdAt)}  ·  ${log.source}'
            '${log.detailId == null ? '' : '  ·  OR ${log.detailId}'}',
            style: AppTypography.ui(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          children: [
            SelectableText(log.message, style: mono),
            if (log.context != null) ...[
              SizedBox(height: Space.sm),
              _CodeBlock(text: _prettyJson(log.context!), style: mono),
            ],
            if (log.stackTrace != null) ...[
              SizedBox(height: Space.sm),
              _CodeBlock(text: log.stackTrace!, style: mono),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy'),
                onPressed: onCopy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Space.sm),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(text, style: style),
    );
  }
}
