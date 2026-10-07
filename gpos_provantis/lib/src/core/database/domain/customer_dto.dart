import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';

enum CustomerType {
  individual('Individual'),
  company('Company');

  const CustomerType(this.label);

  /// The exact text the server expects in `type`.
  final String label;

  static CustomerType fromLabel(String label) =>
      label.toLowerCase() == 'company'
      ? CustomerType.company
      : CustomerType.individual;
}

/// What the cashier typed before payment. It only lives in memory: the sale's
/// receipt number doesn't exist yet, so it can't be saved or sent until the
/// sale completes.
class CustomerDraft {
  CustomerDraft({
    required this.type,
    String company = '',
    required String fullName,
    String email = '',
    String mobile = '',
    String address = '',
    String purchaseOrder = '',
  }) : company = _clean(company),
       fullName = _clean(fullName),
       email = email.trim(),
       mobile = _clean(mobile),
       address = _clean(address),
       purchaseOrder = _clean(purchaseOrder);

  final CustomerType type;

  /// Company name. Empty for an individual.
  final String company;

  /// The individual's full name, or the company's representative.
  final String fullName;

  final String email;
  final String mobile;
  final String address;
  final String purchaseOrder;

  /// Trims and collapses runs of whitespace.
  static String _clean(String v) => v.trim().replaceAll(RegExp(r'\s+'), ' ');
}

/// Values for [CustomerTableData.syncStatus].
abstract class CustomerSyncStatus {
  static const pending = 'PENDING';
  static const synced = 'SYNCED';
}

class CustomerDto {
  const CustomerDto({
    required this.id,
    required this.salesId,
    required this.posId,
    required this.type,
    required this.company,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.address,
    required this.purchaseOrder,
    required this.createdAt,
    this.syncStatus = CustomerSyncStatus.pending,
  });

  /// A new record for a finished sale, with a fresh id.
  factory CustomerDto.fromDraft(
    CustomerDraft draft, {
    required String salesId,
    required String posId,
  }) {
    return CustomerDto(
      id: const Uuid().v4(),
      salesId: salesId,
      posId: posId,
      type: draft.type,
      company: draft.type == CustomerType.company ? draft.company : '',
      fullName: draft.fullName,
      email: draft.email,
      phone: 'N/A',
      mobile: draft.mobile,
      address: draft.address,
      purchaseOrder: draft.purchaseOrder,
      createdAt: DateTime.now(),
    );
  }

  final String id;
  final String salesId;
  final String posId;
  final CustomerType type;
  final String company;
  final String fullName;
  final String email;
  final String phone;
  final String mobile;
  final String address;
  final String purchaseOrder;
  final DateTime createdAt;
  final String syncStatus;

  factory CustomerDto.fromTableData(CustomerTableData row) {
    return CustomerDto(
      id: row.id,
      salesId: row.salesId,
      posId: row.posId,
      type: CustomerType.fromLabel(row.type),
      company: row.company,
      fullName: row.fullName,
      email: row.email,
      phone: row.phone,
      mobile: row.mobile,
      address: row.address,
      purchaseOrder: row.purchaseOrder,
      createdAt: row.createdAt,
      syncStatus: row.syncStatus,
    );
  }

  CustomerTableCompanion toCompanion() {
    return CustomerTableCompanion.insert(
      id: Value(id),
      salesId: salesId,
      posId: posId,
      type: type.label,
      fullName: fullName,
      company: Value(company),
      email: Value(email),
      phone: Value(phone),
      mobile: Value(mobile),
      address: Value(address),
      purchaseOrder: Value(purchaseOrder),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  /// The customer as the server expects it inside the `customer` string. Blank
  /// optional fields are sent as "N/A", like `phone`.
  Map<String, dynamic> toCustomerJson() => {
    'sales_id': salesId,
    'type': type.label,
    'company': company,
    'fullname': fullName,
    'email': _orNotAvailable(email),
    'phone': phone,
    'mobile': _orNotAvailable(mobile),
    'address': _orNotAvailable(address),
  };

  /// The body `POST /mobile-api/customer-transaction` expects: `customer` is a
  /// JSON *string*, and `pos` is "POS " followed by the POS id.
  ///
  /// ```
  /// {customer: '{"sales_id":"100000067","type":"Individual","company":"",
  ///   "fullname":"JOHN DOES",...}', pos: 'POS 1'}
  /// ```
  Map<String, dynamic> toApiJson() => {
    'customer': jsonEncode(toCustomerJson()),
    'pos': 'POS $posId',
  };

  static String _orNotAvailable(String v) => v.isEmpty ? 'N/A' : v;
}
