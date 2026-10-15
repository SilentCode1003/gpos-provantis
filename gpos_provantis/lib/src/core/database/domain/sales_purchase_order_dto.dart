import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';

/// Values for [SalesPurchaseOrderTableData.syncStatus].
abstract class SalesPurchaseOrderSyncStatus {
  static const pending = 'PENDING';
  static const synced = 'SYNCED';
}

class SalesPurchaseOrderDto {
  const SalesPurchaseOrderDto({
    required this.id,
    required this.salesId,
    required this.purchaseOrderId,
    required this.createdAt,
    this.syncStatus = SalesPurchaseOrderSyncStatus.pending,
  });

  /// A new purchase order for a finished sale, with a fresh id.
  factory SalesPurchaseOrderDto.create({
    required String salesId,
    required String purchaseOrderId,
  }) {
    return SalesPurchaseOrderDto(
      id: const Uuid().v4(),
      salesId: salesId,
      purchaseOrderId: purchaseOrderId.trim(),
      createdAt: DateTime.now(),
    );
  }

  final String id;

  /// The sale's receipt (OR) number.
  final String salesId;
  final String purchaseOrderId;
  final DateTime createdAt;
  final String syncStatus;

  factory SalesPurchaseOrderDto.fromTableData(SalesPurchaseOrderTableData row) {
    return SalesPurchaseOrderDto(
      id: row.id,
      salesId: row.salesId,
      purchaseOrderId: row.purchaseOrderId,
      createdAt: row.createdAt,
      syncStatus: row.syncStatus,
    );
  }

  SalesPurchaseOrderTableCompanion toCompanion() {
    return SalesPurchaseOrderTableCompanion.insert(
      id: Value(id),
      salesId: salesId,
      purchaseOrderId: purchaseOrderId,
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  /// The body `POST /mobile-api/add-sales-purchase-order` expects.
  Map<String, dynamic> toApiJson() => {
    'sales_id': salesId,
    'purchase_order_id': purchaseOrderId,
  };
}
