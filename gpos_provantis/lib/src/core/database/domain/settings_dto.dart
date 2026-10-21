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
    this.showProductImages = true,
    this.autoFetchProductImages = true,
    this.productImageRefetchDays = 0,
    this.productImagesLastRefetchedAt,
  });

  static const String defaultId = 'settings_config';

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
  final bool showProductImages;
  final bool autoFetchProductImages;
  final int productImageRefetchDays;
  final DateTime? productImagesLastRefetchedAt;

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
      showProductImages: row.showProductImages,
      autoFetchProductImages: row.autoFetchProductImages,
      productImageRefetchDays: row.productImageRefetchDays,
      productImagesLastRefetchedAt: row.productImagesLastRefetchedAt,
    );
  }

  /// NOTE: the product-image settings are deliberately NOT included here.
  /// This is what the server-settings sync upserts, and leaving those columns
  /// out means that sync never resets what the cashier chose on the Product
  /// Images screen. They are changed through the dedicated methods on
  /// SettingsDao instead.
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
    bool? showProductImages,
    bool? autoFetchProductImages,
    int? productImageRefetchDays,
    DateTime? productImagesLastRefetchedAt,
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
      showProductImages: showProductImages ?? this.showProductImages,
      autoFetchProductImages:
          autoFetchProductImages ?? this.autoFetchProductImages,
      productImageRefetchDays:
          productImageRefetchDays ?? this.productImageRefetchDays,
      productImagesLastRefetchedAt:
          productImagesLastRefetchedAt ?? this.productImagesLastRefetchedAt,
    );
  }
}

/// Just the product-image settings, as the rest of the app reads them.
class ProductImageSettings {
  const ProductImageSettings({
    this.show = true,
    this.autoFetch = true,
    this.refetchDays = 0,
    this.lastRefetchedAt,
  });

  factory ProductImageSettings.fromTableData(SettingsTableData row) {
    return ProductImageSettings(
      show: row.showProductImages,
      autoFetch: row.autoFetchProductImages,
      refetchDays: row.productImageRefetchDays,
      lastRefetchedAt: row.productImagesLastRefetchedAt,
    );
  }

  /// Show pictures on the product grid.
  final bool show;

  /// Download missing pictures automatically after a catalog sync.
  final bool autoFetch;

  /// Re-download every picture every this many days. 0 = never.
  final int refetchDays;

  /// When every picture was last downloaded fresh. Null = never.
  final DateTime? lastRefetchedAt;

  /// When the next full refresh falls due, or null if there is no schedule
  /// (or no starting point yet).
  DateTime? get nextRefetchAt {
    final last = lastRefetchedAt;
    if (refetchDays <= 0 || last == null) return null;
    return last.add(Duration(days: refetchDays));
  }

  bool isRefetchDue(DateTime now) {
    final next = nextRefetchAt;
    return next != null && !now.isBefore(next);
  }

  @override
  bool operator ==(Object other) =>
      other is ProductImageSettings &&
      other.show == show &&
      other.autoFetch == autoFetch &&
      other.refetchDays == refetchDays &&
      other.lastRefetchedAt == lastRefetchedAt;

  @override
  int get hashCode =>
      Object.hash(show, autoFetch, refetchDays, lastRefetchedAt);
}

/// Just the sync settings, as the rest of the app reads them.
class SyncSettings {
  const SyncSettings({
    this.autoSyncAfterTransaction = true,
    this.autoDeleteSyncedDataOnLogout = false,
    this.autoSyncIntervalMinutes = 0,
    this.lastCatalogSyncAt,
  });

  factory SyncSettings.fromTableData(SettingsTableData row) {
    return SyncSettings(
      autoSyncAfterTransaction: row.autoSyncAfterTransaction,
      autoDeleteSyncedDataOnLogout: row.autoDeleteSyncedDataOnLogout,
      autoSyncIntervalMinutes: row.autoSyncIntervalMinutes,
      lastCatalogSyncAt: row.lastCatalogSyncAt,
    );
  }

  final bool autoSyncAfterTransaction;
  final bool autoDeleteSyncedDataOnLogout;

  /// 0 = no scheduled sync.
  final int autoSyncIntervalMinutes;

  final DateTime? lastCatalogSyncAt;

  bool get hasSchedule => autoSyncIntervalMinutes > 0;

  @override
  bool operator ==(Object other) =>
      other is SyncSettings &&
      other.autoSyncAfterTransaction == autoSyncAfterTransaction &&
      other.autoDeleteSyncedDataOnLogout == autoDeleteSyncedDataOnLogout &&
      other.autoSyncIntervalMinutes == autoSyncIntervalMinutes &&
      other.lastCatalogSyncAt == lastCatalogSyncAt;

  @override
  int get hashCode => Object.hash(
    autoSyncAfterTransaction,
    autoDeleteSyncedDataOnLogout,
    autoSyncIntervalMinutes,
    lastCatalogSyncAt,
  );
}
