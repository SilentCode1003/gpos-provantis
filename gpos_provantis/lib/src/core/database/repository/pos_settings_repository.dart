import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/printer_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/printer_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';

import '../domain/pos_settings_dto.dart';
import '../domain/printer_dto.dart';
import '../domain/settings_dto.dart';

part 'pos_settings_repository.g.dart';

@Riverpod(keepAlive: true)
PosSettingsRepository posSettingsRepository(Ref ref) {
  return PosSettingsRepository(
    ref,
    ref.watch(posConfigDaoProvider),
    ref.watch(printerDaoProvider),
    ref.watch(settingsDaoProvider),
  );
}

/// The printer ids that ended up assigned in settings. Null means that role
/// was not touched (the server sent no address for it).
class PosSettingsSyncResult {
  const PosSettingsSyncResult({
    required this.mainPrinterId,
    required this.subPrinterId,
  });

  final String? mainPrinterId;
  final String? subPrinterId;
}

class PosSettingsRepository {
  final Ref _ref;
  final PosConfigDao _posConfigDao;
  final PrinterDao _printerDao;
  final SettingsDao _settingsDao;

  PosSettingsRepository(
    this._ref,
    this._posConfigDao,
    this._printerDao,
    this._settingsDao,
  );

  static final _macAddress = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}$');
  static const _supportedPaperSizes = {'58', '72', '80'};

  /// Fetches the POS config and turns it into local printers + settings:
  ///
  /// * `printerip` becomes the main printer, `productionprinterip` the sub
  ///   printer. If both are the same address, ONE printer is created and
  ///   assigned to both roles.
  /// * A printer that already exists with that address is updated in place
  ///   (its id is kept, so existing references stay valid); otherwise a new
  ///   one is created with a fresh UUID.
  /// * The ids are written to `settings.mainPrinter` / `settings.subPrinter`.
  ///   Every other setting is left alone.
  ///
  /// Printers and settings are written in one transaction. Throws if the
  /// server returns nothing, leaving local data untouched. Network failures
  /// ([DioException]) also propagate.
  ///
  /// The POS id sent to the server comes from the locally saved POS config,
  /// so that must already be stored (the catalog sync runs this last for that
  /// reason). Throws a [StateError] if it isn't.
  Future<PosSettingsSyncResult> syncPosSettings() async {
    final pos = await _posConfigDao.getPos();
    if (pos == null) {
      throw StateError(
        'POS settings can\'t be synced: no POS config saved on this device.',
      );
    }

    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/mobile-api/getposconfig',
      data: {'posid': pos.posId},
    );

    final apiResponse = ApiResponseModel<List<PosSettingsDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PosSettingsDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No POS settings returned from server: ${apiResponse.responseMessage}',
      );
    }

    // One POS = one config row.
    return _applyToLocal(records.first);
  }

  Future<PosSettingsSyncResult> _applyToLocal(PosSettingsDto server) {
    final db = _ref.read(appDatabaseProvider);

    return db.transaction(() async {
      final existing = await _printerDao.getAllPrinters();

      final mainAddress = server.printerIp.trim();
      final subAddress = server.productionPrinterIp.trim();
      final sameDevice =
          mainAddress.isNotEmpty && _sameAddress(mainAddress, subAddress);

      final mainName = server.printerName.trim();

      String? mainId;
      String? subId;

      if (mainAddress.isNotEmpty) {
        mainId = await _upsertPrinter(
          existing,
          server: server,
          address: mainAddress,
          name: mainName.isEmpty ? 'Main Printer' : mainName,
          // The cash drawer is wired to the receipt (main) printer.
          hasCashDrawer: server.isCashDrawer,
        );
      }

      if (subAddress.isNotEmpty) {
        if (sameDevice) {
          subId = mainId;
        } else {
          subId = await _upsertPrinter(
            existing,
            server: server,
            address: subAddress,
            name: mainName.isEmpty
                ? 'Production Printer'
                : '$mainName (Production)',
            hasCashDrawer: false,
          );
        }
      }

      await _assignToSettings(mainId, subId);

      return PosSettingsSyncResult(mainPrinterId: mainId, subPrinterId: subId);
    });
  }

  /// Updates the printer already stored at [address], or creates one.
  /// Returns its id.
  Future<String> _upsertPrinter(
    List<PrintersTableData> existing, {
    required PosSettingsDto server,
    required String address,
    required String name,
    required bool hasCashDrawer,
  }) async {
    final match = existing
        .where((p) => _sameAddress(p.address, address))
        .firstOrNull;
    final id = match?.id ?? const Uuid().v4();

    final printer = PrinterDto(
      id: id,
      name: name,
      connectionType: _connectionTypeFor(
        address,
        isBluetooth: server.isBluetooth,
      ),
      address: address,
      paperSize: _normalizePaperSize(server.paperSize),
      isEnabled: server.isEnable,
      hasCashDrawer: hasCashDrawer,
    );

    await _printerDao.upsertPrinter(printer.toCompanion());
    return id;
  }

  /// Writes the printer ids into the settings row without disturbing any other
  /// setting. Creates the row (with the app's normal defaults) if it doesn't
  /// exist yet.
  Future<void> _assignToSettings(String? mainId, String? subId) async {
    final rows = await _settingsDao.getSettings();

    if (rows.isEmpty) {
      await _settingsDao.upsertSettings(
        SettingsDto.defaults()
            .copyWith(mainPrinter: mainId, subPrinter: subId)
            .toCompanion(),
      );
      return;
    }

    if (mainId == null && subId == null) return;

    await _settingsDao.upsertSettings(
      SettingsTableCompanion(
        id: Value(rows.first.id),
        mainPrinter: mainId == null ? const Value.absent() : Value(mainId),
        subPrinter: subId == null ? const Value.absent() : Value(subId),
      ),
    );
  }

  // ---- mapping helpers -----------------------------------------------------

  /// IPv4 address -> WIFI. Otherwise a MAC address (or the server's bluetooth
  /// flag) -> BLUETOOTH. Anything else (device path/port) -> USB.
  static String _connectionTypeFor(
    String address, {
    required bool isBluetooth,
  }) {
    if (_isIpv4(address)) return 'WIFI';
    if (isBluetooth || _macAddress.hasMatch(address)) return 'BLUETOOTH';
    return 'USB';
  }

  static bool _isIpv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }

  /// The server sends "mm80"; the app stores just "80" (the UI adds "mm").
  /// Anything unrecognised falls back to 80.
  static String _normalizePaperSize(String raw) {
    final digits = RegExp(r'\d+').firstMatch(raw)?.group(0);
    return digits != null && _supportedPaperSizes.contains(digits)
        ? digits
        : '80';
  }

  static bool _sameAddress(String a, String b) =>
      a.trim().toLowerCase() == b.trim().toLowerCase();
}
