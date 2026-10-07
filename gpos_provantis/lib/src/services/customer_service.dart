import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/customer_dto.dart';
import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/customer_repository.dart';

part 'customer_service.g.dart';

/// Which parts of the customer flow the store has switched on in Settings.
class CustomerSettings {
  const CustomerSettings({
    required this.promptEnabled,
    required this.purchaseOrderEnabled,
  });

  /// Ask for a customer when Charge is tapped.
  final bool promptEnabled;

  /// Show the Purchase Order field in that prompt.
  final bool purchaseOrderEnabled;
}

/// Outcome of attaching a customer to a finished sale. The customer is ALWAYS
/// saved on the device first; [sent] says whether the server has it yet.
class CustomerSendResult {
  const CustomerSendResult({
    required this.record,
    required this.sent,
    this.error,
  });

  final CustomerTableData record;

  /// True once the server has accepted it. False means it is safely stored and
  /// will be sent later.
  final bool sent;

  /// Why the last send failed, when [sent] is false and a send was tried.
  final String? error;
}

@Riverpod(keepAlive: true)
CustomerService customerService(Ref ref) {
  return CustomerService(
    repository: ref.watch(customerRepositoryProvider),
    settingsDao: ref.watch(settingsDaoProvider),
  );
}

/// Owns the customer-on-a-sale flow:
///
///  1. Before payment the cashier fills in (or skips) the customer. That is held
///     here as a [draft], in memory only, because the sale's receipt number
///     doesn't exist yet.
///  2. When the sale is complete, [recordForSale] saves the customer on the
///     device against that receipt number and then uploads it.
///  3. Every customer carries a sync status, so one that is already on the
///     server is never sent again and one that failed is retried by
///     [syncPending].
class CustomerService {
  CustomerService({
    required CustomerRepository repository,
    required SettingsDao settingsDao,
  }) : _repository = repository,
       _settingsDao = settingsDao;

  final CustomerRepository _repository;
  final SettingsDao _settingsDao;

  CustomerDraft? _draft;

  /// What the cashier entered for the sale in progress, if anything.
  CustomerDraft? get draft => _draft;

  void setDraft(CustomerDraft draft) => _draft = draft;

  void clearDraft() => _draft = null;

  /// Reads the store's switches. Both are off if Settings hasn't been saved.
  Future<CustomerSettings> loadSettings() async {
    final rows = await _settingsDao.getSettings();
    final settings = rows.isNotEmpty
        ? SettingsDto.fromTableData(rows.first)
        : SettingsDto.defaults();

    return CustomerSettings(
      promptEnabled: settings.addCustomerToTransaction,
      purchaseOrderEnabled: settings.addPurchaseOrderToTransaction,
    );
  }

  /// Attaches the pending [draft] to the finished sale [salesId].
  ///
  /// Call it once the sale has been saved. Does nothing (returns null) if no
  /// customer was entered.
  ///
  /// 1. The customer is saved on this device against [salesId]. From here it
  ///    can't be lost, whatever the network does.
  /// 2. The draft is cleared, so it can never attach to a later sale.
  /// 3. Then it is uploaded. This never throws: if the server is unreachable
  ///    the customer stays PENDING and goes out on a later [syncPending].
  ///
  /// Throws only if the local save itself fails.
  Future<CustomerSendResult?> recordForSale({
    required String salesId,
    required String posId,
  }) async {
    final draft = _draft;
    if (draft == null) return null;

    final saved = await _repository.saveCustomer(
      CustomerDto.fromDraft(draft, salesId: salesId, posId: posId),
    );
    _draft = null;

    try {
      await _repository.syncPending();
    } catch (e) {
      debugPrint('CustomerService: upload failed: $e');
    }

    final latest = await _repository.getCustomer(saved.id) ?? saved;
    final sent = latest.syncStatus == CustomerSyncStatus.synced;

    return CustomerSendResult(
      record: latest,
      sent: sent,
      error: sent ? null : latest.lastError,
    );
  }

  /// Whether the customer for [salesId] is already on the server. False if
  /// there is no customer for that sale, or it hasn't been accepted yet.
  Future<bool> isUploaded(String salesId) async {
    final row = await _repository.getCustomerForSale(salesId);
    return row?.syncStatus == CustomerSyncStatus.synced;
  }

  /// Uploads any customers still waiting (e.g. the device was offline when the
  /// sale was made). Safe to call any time; returns how many were sent.
  Future<int> syncPending() => _repository.syncPending();
}
