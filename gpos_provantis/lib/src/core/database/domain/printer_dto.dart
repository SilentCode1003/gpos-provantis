import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:drift/drift.dart' show Value;

class PrinterDto {
  final String id;
  final String name;
  final String connectionType;
  final String address;
  final String paperSize;

  PrinterDto({
    required this.id,
    required this.name,
    required this.connectionType,
    required this.address,
    required this.paperSize,
  });

  factory PrinterDto.fromTableData(PrintersTableData data) {
    return PrinterDto(
      id: data.id,
      name: data.name,
      connectionType: data.connectionType,
      address: data.address,
      paperSize: data.paperSize,
    );
  }

  PrintersTableCompanion toCompanion({bool forInsert = false}) {
    return PrintersTableCompanion(
      id: forInsert || id.isEmpty ? const Value.absent() : Value(id),
      name: Value(name),
      connectionType: Value(connectionType),
      address: Value(address),
      paperSize: Value(paperSize),
    );
  }

  PrinterDto copyWith({
    String? id,
    String? name,
    String? connectionType,
    String? address,
    String? paperSize,
  }) {
    return PrinterDto(
      id: id ?? this.id,
      name: name ?? this.name,
      connectionType: connectionType ?? this.connectionType,
      address: address ?? this.address,
      paperSize: paperSize ?? this.paperSize,
    );
  }
}
