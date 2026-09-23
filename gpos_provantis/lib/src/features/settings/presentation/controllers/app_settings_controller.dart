// Location: src/features/settings/controllers/app_settings_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/counter_display_codec.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';

/// Reads and saves the single app settings row (`SettingsTable`).
///
/// Every settings panel (Transactions, POS Config, Counter Display, ...)
/// goes through this one controller, so there is only one place that
/// writes to the database.
///
/// HOW A PANEL SAVES
///   final controller = ref.read(appSettingsProvider.notifier);
///   await controller.saveChanges((s) => s.copyWith(showVatOnReceipt: true));
///
/// The `saveChanges` call takes the current settings, lets the panel change
/// only what it cares about, and saves the result. Other fields are never
/// overwritten, so two panels cannot wipe each other's values.
///
/// Because it listens to the database stream, the screen refreshes on its
/// own after every save, and so does anything else watching it (like the
/// main screen).
/// Stored in `mainPrinter` / `subPrinter` when no printer is assigned.
/// This is the same word the settings table uses as its default.
const String unassignedPrinter = 'UNREGISTERED';

final appSettingsProvider =
    StreamNotifierProvider<AppSettingsController, SettingsDto>(
      AppSettingsController.new,
    );

class AppSettingsController extends StreamNotifier<SettingsDto> {
  @override
  Stream<SettingsDto> build() {
    final dao = ref.watch(settingsDaoProvider);

    return dao.watchSettings().map((rows) {
      // No row saved yet (fresh install) -> show defaults.
      if (rows.isEmpty) return SettingsDto.defaults();

      // There should only ever be one row. Prefer the official one.
      final row = rows.firstWhere(
        (r) => r.id == SettingsDto.defaultId,
        orElse: () => rows.first,
      );
      return SettingsDto.fromTableData(row);
    });
  }

  /// The current settings, or the defaults if nothing is loaded yet.
  SettingsDto get _current => state.value ?? SettingsDto.defaults();

  /// Reads the settings row straight from the database, not from `state`,
  /// so a quick second save never works from a stale copy.
  Future<SettingsDto> _readLatest() async {
    final dao = ref.read(settingsDaoProvider);
    final rows = await dao.getSettings();

    if (rows.isEmpty) return SettingsDto.defaults();

    return SettingsDto.fromTableData(
      rows.firstWhere(
        (r) => r.id == SettingsDto.defaultId,
        orElse: () => rows.first,
      ),
    );
  }

  /// Change some fields and save. See the note at the top of this file.
  Future<void> saveChanges(
    SettingsDto Function(SettingsDto current) change,
  ) async {
    final dao = ref.read(settingsDaoProvider);
    final latest = await _readLatest();
    final updated = change(latest);
    await dao.upsertSettings(updated.toCompanion());
  }

  // -----------------------------------------------------------------------
  // PRINTER ASSIGNMENT helpers
  //
  // Only the printer's uuid (`PrinterDto.id`) is stored. Pass `null` to
  // un-assign, which stores `unassignedPrinter`.
  // -----------------------------------------------------------------------

  /// Set which printer is the main printer.
  Future<void> setMainPrinter(String? printerId) {
    return saveChanges(
      (s) => s.copyWith(mainPrinter: printerId ?? unassignedPrinter),
    );
  }

  /// Set which printer is the sub printer.
  Future<void> setSubPrinter(String? printerId) {
    return saveChanges(
      (s) => s.copyWith(subPrinter: printerId ?? unassignedPrinter),
    );
  }

  /// Un-assign [printerId] from whichever role(s) it holds. Call this when
  /// a printer is deleted, so the settings never point at a printer that
  /// no longer exists. Does nothing (no write) if it wasn't assigned.
  Future<void> clearPrinterAssignment(String printerId) async {
    final latest = await _readLatest();
    final isMain = latest.mainPrinter == printerId;
    final isSub = latest.subPrinter == printerId;
    if (!isMain && !isSub) return;

    await saveChanges(
      (s) => s.copyWith(
        mainPrinter: isMain ? unassignedPrinter : null,
        subPrinter: isSub ? unassignedPrinter : null,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // COUNTER DISPLAY helpers
  // -----------------------------------------------------------------------

  /// Category codes currently hidden from the main screen.
  Set<int> get hiddenCategoryCodes =>
      CounterDisplayCodec.decode(_current.counterDisplay);

  /// Show or hide one category.
  Future<void> setCategoryVisible(int categoryCode, bool visible) {
    return saveChanges((s) {
      final hidden = CounterDisplayCodec.decode(s.counterDisplay);
      if (visible) {
        hidden.remove(categoryCode);
      } else {
        hidden.add(categoryCode);
      }
      return s.copyWith(counterDisplay: CounterDisplayCodec.encode(hidden));
    });
  }

  /// Show or hide many categories in one save (used by Show all / Hide all).
  Future<void> setManyCategoriesVisible(
    Iterable<int> categoryCodes,
    bool visible,
  ) {
    return saveChanges((s) {
      final hidden = CounterDisplayCodec.decode(s.counterDisplay);
      if (visible) {
        hidden.removeAll(categoryCodes);
      } else {
        hidden.addAll(categoryCodes);
      }
      return s.copyWith(counterDisplay: CounterDisplayCodec.encode(hidden));
    });
  }
}

/// The set of hidden category codes, ready for the main screen to read.
///
/// Usage on the main screen:
///   final hidden = ref.watch(hiddenCategoryCodesProvider);
///   final shown = categories.where((c) => !hidden.contains(c.categoryCode));
///
/// While settings are still loading it returns an empty set, meaning
/// nothing is hidden yet.
final hiddenCategoryCodesProvider = Provider<Set<int>>((ref) {
  final settings = ref.watch(appSettingsProvider).value;
  if (settings == null) return <int>{};
  return CounterDisplayCodec.decode(settings.counterDisplay);
});
