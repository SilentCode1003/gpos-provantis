import 'package:drift/drift.dart';

class IsoDateTimeConverter extends TypeConverter<DateTime, String> {
  const IsoDateTimeConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb).toLocal();

  @override
  String toSql(DateTime value) => value.toUtc().toIso8601String();
}
