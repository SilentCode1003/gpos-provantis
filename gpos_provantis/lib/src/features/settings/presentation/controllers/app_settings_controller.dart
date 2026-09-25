import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/counter_display_codec.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';

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
      if (rows.isEmpty) return SettingsDto.defaults();

      final row = rows.firstWhere(
        (r) => r.id == SettingsDto.defaultId,
        orElse: () => rows.first,
      );
      return SettingsDto.fromTableData(row);
    });
  }

  SettingsDto get _current => state.value ?? SettingsDto.defaults();

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

  Future<void> saveChanges(
    SettingsDto Function(SettingsDto current) change,
  ) async {
    final dao = ref.read(settingsDaoProvider);
    final latest = await _readLatest();
    final updated = change(latest);
    await dao.upsertSettings(updated.toCompanion());
  }

  Future<void> setMainPrinter(String? printerId) {
    return saveChanges(
      (s) => s.copyWith(mainPrinter: printerId ?? unassignedPrinter),
    );
  }

  Future<void> setSubPrinter(String? printerId) {
    return saveChanges(
      (s) => s.copyWith(subPrinter: printerId ?? unassignedPrinter),
    );
  }

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

  Set<int> get hiddenCategoryCodes =>
      CounterDisplayCodec.decode(_current.counterDisplay);

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

final hiddenCategoryCodesProvider = Provider<Set<int>>((ref) {
  final settings = ref.watch(appSettingsProvider).value;
  if (settings == null) return <int>{};
  return CounterDisplayCodec.decode(settings.counterDisplay);
});
