// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_history_dao.dart';

// ignore_for_file: type=lint
mixin _$ReceiptHistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReceiptHistoryTableTable get receiptHistoryTable =>
      attachedDatabase.receiptHistoryTable;
  ReceiptHistoryDaoManager get managers => ReceiptHistoryDaoManager(this);
}

class ReceiptHistoryDaoManager {
  final _$ReceiptHistoryDaoMixin _db;
  ReceiptHistoryDaoManager(this._db);
  $$ReceiptHistoryTableTableTableManager get receiptHistoryTable =>
      $$ReceiptHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.receiptHistoryTable,
      );
}
