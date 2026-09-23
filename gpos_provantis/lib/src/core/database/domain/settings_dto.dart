// Location: src/core/database/domain/settings_dto.dart
import 'package:drift/drift.dart' show Value;
import 'package:gpos_provantis/src/core/database/app_database.dart';

class SettingsDto {
  const SettingsDto({
    required this.id,
    required this.mainPrinter,
    required this.subPrinter,
    required this.showVatOnReceipt,
    required this.showOfficialReceiptMessageAtTheBottom,
    required this.birAccredited,
    required this.showReceiptPreview,
    required this.addCustomerToTransaction,
    required this.addPurchaseOrderToTransaction,
    required this.counterDisplay,
    required this.companyName,
    required this.address,
    required this.accreditationNo,
    required this.validUntil,
    required this.vatReg,
    required this.permitToUse,
    required this.machineIdentificationNumber,
  });

  /// The id of the one and only settings row.
  static const String defaultId = 'settings_config';

  /// What a fresh install looks like before anything is saved.
  /// Matches the defaults in `SettingsTable`. `counterDisplay` starts as
  /// `[]` (nothing hidden) instead of `UNREGISTERED`.
  factory SettingsDto.defaults() => const SettingsDto(
    id: defaultId,
    mainPrinter: 'UNREGISTERED',
    subPrinter: 'UNREGISTERED',
    showVatOnReceipt: false,
    showOfficialReceiptMessageAtTheBottom: false,
    birAccredited: false,
    showReceiptPreview: false,
    addCustomerToTransaction: false,
    addPurchaseOrderToTransaction: false,
    counterDisplay: '[]',
    companyName: 'UNREGISTERED',
    address: 'UNREGISTERED',
    accreditationNo: 'UNREGISTERED',
    validUntil: 'UNREGISTERED',
    vatReg: 'UNREGISTERED',
    permitToUse: 'UNREGISTERED',
    machineIdentificationNumber: 'UNREGISTERED',
  );

  final String id;
  final String mainPrinter;
  final String subPrinter;
  final bool showVatOnReceipt;
  final bool showOfficialReceiptMessageAtTheBottom;
  final bool birAccredited;
  final bool showReceiptPreview;
  final bool addCustomerToTransaction;
  final bool addPurchaseOrderToTransaction;
  final String counterDisplay;
  final String companyName;
  final String address;
  final String accreditationNo;
  final String validUntil;
  final String vatReg;
  final String permitToUse;
  final String machineIdentificationNumber;

  factory SettingsDto.fromJson(Map<String, dynamic> json) {
    return SettingsDto(
      id: json['id'] as String,
      mainPrinter: json['mainPrinter'] as String,
      subPrinter: json['subPrinter'] as String,
      showVatOnReceipt: json['showVatOnReceipt'] as bool,
      showOfficialReceiptMessageAtTheBottom:
          json['showOfficialReceiptMessageAtTheBottom'] as bool,
      birAccredited: json['birAccredited'] as bool,
      showReceiptPreview: json['showReceiptPreview'] as bool,
      addCustomerToTransaction: json['addCustomerToTransaction'] as bool,
      addPurchaseOrderToTransaction:
          json['addPurchaseOrderToTransaction'] as bool,
      counterDisplay: json['counterDisplay'] as String,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
      accreditationNo: json['accreditationNo'] as String,
      validUntil: json['validUntil'] as String,
      vatReg: json['vatReg'] as String,
      permitToUse: json['permitToUse'] as String,
      machineIdentificationNumber:
          json['machineIdentificationNumber'] as String,
    );
  }

  /// Builds a DTO from a database row.
  factory SettingsDto.fromTableData(SettingsTableData row) {
    return SettingsDto(
      id: row.id,
      mainPrinter: row.mainPrinter,
      subPrinter: row.subPrinter,
      showVatOnReceipt: row.showVatOnReceipt,
      showOfficialReceiptMessageAtTheBottom:
          row.showOfficialReceiptMessageAtTheBottom,
      birAccredited: row.birAccredited,
      showReceiptPreview: row.showReceiptPreview,
      addCustomerToTransaction: row.addCustomerToTransaction,
      addPurchaseOrderToTransaction: row.addPurchaseOrderToTransaction,
      counterDisplay: row.counterDisplay,
      companyName: row.companyName,
      address: row.address,
      accreditationNo: row.accreditationNo,
      validUntil: row.validUntil,
      vatReg: row.vatReg,
      permitToUse: row.permitToUse,
      machineIdentificationNumber: row.machineIdentificationNumber,
    );
  }

  /// Turns this DTO into something the database can save.
  SettingsTableCompanion toCompanion() {
    return SettingsTableCompanion(
      id: Value(id),
      mainPrinter: Value(mainPrinter),
      subPrinter: Value(subPrinter),
      showVatOnReceipt: Value(showVatOnReceipt),
      showOfficialReceiptMessageAtTheBottom: Value(
        showOfficialReceiptMessageAtTheBottom,
      ),
      birAccredited: Value(birAccredited),
      showReceiptPreview: Value(showReceiptPreview),
      addCustomerToTransaction: Value(addCustomerToTransaction),
      addPurchaseOrderToTransaction: Value(addPurchaseOrderToTransaction),
      counterDisplay: Value(counterDisplay),
      companyName: Value(companyName),
      address: Value(address),
      accreditationNo: Value(accreditationNo),
      validUntil: Value(validUntil),
      vatReg: Value(vatReg),
      permitToUse: Value(permitToUse),
      machineIdentificationNumber: Value(machineIdentificationNumber),
    );
  }

  /// Copy with changes. Panels use this to change one field and keep the rest.
  SettingsDto copyWith({
    String? mainPrinter,
    String? subPrinter,
    bool? showVatOnReceipt,
    bool? showOfficialReceiptMessageAtTheBottom,
    bool? birAccredited,
    bool? showReceiptPreview,
    bool? addCustomerToTransaction,
    bool? addPurchaseOrderToTransaction,
    String? counterDisplay,
    String? companyName,
    String? address,
    String? accreditationNo,
    String? validUntil,
    String? vatReg,
    String? permitToUse,
    String? machineIdentificationNumber,
  }) {
    return SettingsDto(
      id: id,
      mainPrinter: mainPrinter ?? this.mainPrinter,
      subPrinter: subPrinter ?? this.subPrinter,
      showVatOnReceipt: showVatOnReceipt ?? this.showVatOnReceipt,
      showOfficialReceiptMessageAtTheBottom:
          showOfficialReceiptMessageAtTheBottom ??
          this.showOfficialReceiptMessageAtTheBottom,
      birAccredited: birAccredited ?? this.birAccredited,
      showReceiptPreview: showReceiptPreview ?? this.showReceiptPreview,
      addCustomerToTransaction:
          addCustomerToTransaction ?? this.addCustomerToTransaction,
      addPurchaseOrderToTransaction:
          addPurchaseOrderToTransaction ?? this.addPurchaseOrderToTransaction,
      counterDisplay: counterDisplay ?? this.counterDisplay,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      accreditationNo: accreditationNo ?? this.accreditationNo,
      validUntil: validUntil ?? this.validUntil,
      vatReg: vatReg ?? this.vatReg,
      permitToUse: permitToUse ?? this.permitToUse,
      machineIdentificationNumber:
          machineIdentificationNumber ?? this.machineIdentificationNumber,
    );
  }
}
