// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_payment_dao.dart';

// ignore_for_file: type=lint
mixin _$SplitPaymentDaoMixin on DatabaseAccessor<AppDatabase> {
  $SplitPaymentTableTable get splitPaymentTable =>
      attachedDatabase.splitPaymentTable;
  SplitPaymentDaoManager get managers => SplitPaymentDaoManager(this);
}

class SplitPaymentDaoManager {
  final _$SplitPaymentDaoMixin _db;
  SplitPaymentDaoManager(this._db);
  $$SplitPaymentTableTableTableManager get splitPaymentTable =>
      $$SplitPaymentTableTableTableManager(
        _db.attachedDatabase,
        _db.splitPaymentTable,
      );
}
