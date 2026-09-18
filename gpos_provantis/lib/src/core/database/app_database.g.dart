// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $POSConfigTableTable extends POSConfigTable
    with TableInfo<$POSConfigTableTable, POSConfigTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $POSConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pos_config'),
  );
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<int> posId = GeneratedColumn<int>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _posNameMeta = const VerificationMeta(
    'posName',
  );
  @override
  late final GeneratedColumn<String> posName = GeneratedColumn<String>(
    'pos_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MAIN_POS'),
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<String> serial = GeneratedColumn<String>(
    'serial',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _minMeta = const VerificationMeta('min');
  @override
  late final GeneratedColumn<String> min = GeneratedColumn<String>(
    'min',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _ptuMeta = const VerificationMeta('ptu');
  @override
  late final GeneratedColumn<String> ptu = GeneratedColumn<String>(
    'ptu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING_SETUP'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SYSTEM_INITIALIZER'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    posId,
    posName,
    serial,
    min,
    ptu,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'p_o_s_config_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<POSConfigTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    }
    if (data.containsKey('pos_name')) {
      context.handle(
        _posNameMeta,
        posName.isAcceptableOrUnknown(data['pos_name']!, _posNameMeta),
      );
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    }
    if (data.containsKey('min')) {
      context.handle(
        _minMeta,
        min.isAcceptableOrUnknown(data['min']!, _minMeta),
      );
    }
    if (data.containsKey('ptu')) {
      context.handle(
        _ptuMeta,
        ptu.isAcceptableOrUnknown(data['ptu']!, _ptuMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  POSConfigTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return POSConfigTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pos_id'],
      )!,
      posName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_name'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial'],
      )!,
      min: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}min'],
      )!,
      ptu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ptu'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_date'],
      )!,
    );
  }

  @override
  $POSConfigTableTable createAlias(String alias) {
    return $POSConfigTableTable(attachedDatabase, alias);
  }
}

class POSConfigTableData extends DataClass
    implements Insertable<POSConfigTableData> {
  final String id;
  final int posId;
  final String posName;
  final String serial;
  final String min;
  final String ptu;
  final String status;
  final String createdBy;
  final DateTime createdDate;
  const POSConfigTableData({
    required this.id,
    required this.posId,
    required this.posName,
    required this.serial,
    required this.min,
    required this.ptu,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pos_id'] = Variable<int>(posId);
    map['pos_name'] = Variable<String>(posName);
    map['serial'] = Variable<String>(serial);
    map['min'] = Variable<String>(min);
    map['ptu'] = Variable<String>(ptu);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  POSConfigTableCompanion toCompanion(bool nullToAbsent) {
    return POSConfigTableCompanion(
      id: Value(id),
      posId: Value(posId),
      posName: Value(posName),
      serial: Value(serial),
      min: Value(min),
      ptu: Value(ptu),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory POSConfigTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return POSConfigTableData(
      id: serializer.fromJson<String>(json['id']),
      posId: serializer.fromJson<int>(json['posId']),
      posName: serializer.fromJson<String>(json['posName']),
      serial: serializer.fromJson<String>(json['serial']),
      min: serializer.fromJson<String>(json['min']),
      ptu: serializer.fromJson<String>(json['ptu']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'posId': serializer.toJson<int>(posId),
      'posName': serializer.toJson<String>(posName),
      'serial': serializer.toJson<String>(serial),
      'min': serializer.toJson<String>(min),
      'ptu': serializer.toJson<String>(ptu),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  POSConfigTableData copyWith({
    String? id,
    int? posId,
    String? posName,
    String? serial,
    String? min,
    String? ptu,
    String? status,
    String? createdBy,
    DateTime? createdDate,
  }) => POSConfigTableData(
    id: id ?? this.id,
    posId: posId ?? this.posId,
    posName: posName ?? this.posName,
    serial: serial ?? this.serial,
    min: min ?? this.min,
    ptu: ptu ?? this.ptu,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  POSConfigTableData copyWithCompanion(POSConfigTableCompanion data) {
    return POSConfigTableData(
      id: data.id.present ? data.id.value : this.id,
      posId: data.posId.present ? data.posId.value : this.posId,
      posName: data.posName.present ? data.posName.value : this.posName,
      serial: data.serial.present ? data.serial.value : this.serial,
      min: data.min.present ? data.min.value : this.min,
      ptu: data.ptu.present ? data.ptu.value : this.ptu,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('POSConfigTableData(')
          ..write('id: $id, ')
          ..write('posId: $posId, ')
          ..write('posName: $posName, ')
          ..write('serial: $serial, ')
          ..write('min: $min, ')
          ..write('ptu: $ptu, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    posId,
    posName,
    serial,
    min,
    ptu,
    status,
    createdBy,
    createdDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is POSConfigTableData &&
          other.id == this.id &&
          other.posId == this.posId &&
          other.posName == this.posName &&
          other.serial == this.serial &&
          other.min == this.min &&
          other.ptu == this.ptu &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class POSConfigTableCompanion extends UpdateCompanion<POSConfigTableData> {
  final Value<String> id;
  final Value<int> posId;
  final Value<String> posName;
  final Value<String> serial;
  final Value<String> min;
  final Value<String> ptu;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<DateTime> createdDate;
  final Value<int> rowid;
  const POSConfigTableCompanion({
    this.id = const Value.absent(),
    this.posId = const Value.absent(),
    this.posName = const Value.absent(),
    this.serial = const Value.absent(),
    this.min = const Value.absent(),
    this.ptu = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  POSConfigTableCompanion.insert({
    this.id = const Value.absent(),
    this.posId = const Value.absent(),
    this.posName = const Value.absent(),
    this.serial = const Value.absent(),
    this.min = const Value.absent(),
    this.ptu = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<POSConfigTableData> custom({
    Expression<String>? id,
    Expression<int>? posId,
    Expression<String>? posName,
    Expression<String>? serial,
    Expression<String>? min,
    Expression<String>? ptu,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<DateTime>? createdDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (posId != null) 'pos_id': posId,
      if (posName != null) 'pos_name': posName,
      if (serial != null) 'serial': serial,
      if (min != null) 'min': min,
      if (ptu != null) 'ptu': ptu,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  POSConfigTableCompanion copyWith({
    Value<String>? id,
    Value<int>? posId,
    Value<String>? posName,
    Value<String>? serial,
    Value<String>? min,
    Value<String>? ptu,
    Value<String>? status,
    Value<String>? createdBy,
    Value<DateTime>? createdDate,
    Value<int>? rowid,
  }) {
    return POSConfigTableCompanion(
      id: id ?? this.id,
      posId: posId ?? this.posId,
      posName: posName ?? this.posName,
      serial: serial ?? this.serial,
      min: min ?? this.min,
      ptu: ptu ?? this.ptu,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (posId.present) {
      map['pos_id'] = Variable<int>(posId.value);
    }
    if (posName.present) {
      map['pos_name'] = Variable<String>(posName.value);
    }
    if (serial.present) {
      map['serial'] = Variable<String>(serial.value);
    }
    if (min.present) {
      map['min'] = Variable<String>(min.value);
    }
    if (ptu.present) {
      map['ptu'] = Variable<String>(ptu.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('POSConfigTableCompanion(')
          ..write('id: $id, ')
          ..write('posId: $posId, ')
          ..write('posName: $posName, ')
          ..write('serial: $serial, ')
          ..write('min: $min, ')
          ..write('ptu: $ptu, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserDataTableTable extends UserDataTable
    with TableInfo<$UserDataTableTable, UserDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user_data'),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INVALID USER'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INVALID USER'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _contactInfoMeta = const VerificationMeta(
    'contactInfo',
  );
  @override
  late final GeneratedColumn<String> contactInfo = GeneratedColumn<String>(
    'contact_info',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INVALID USER'),
  );
  static const VerificationMeta _dateHiredMeta = const VerificationMeta(
    'dateHired',
  );
  @override
  late final GeneratedColumn<String> dateHired = GeneratedColumn<String>(
    'date_hired',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INVALID USER'),
  );
  static const VerificationMeta _userCodeMeta = const VerificationMeta(
    'userCode',
  );
  @override
  late final GeneratedColumn<int> userCode = GeneratedColumn<int>(
    'user_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accessTypeMeta = const VerificationMeta(
    'accessType',
  );
  @override
  late final GeneratedColumn<int> accessType = GeneratedColumn<int>(
    'access_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INVALID USER'),
  );
  static const VerificationMeta _apkMeta = const VerificationMeta('apk');
  @override
  late final GeneratedColumn<String> apk = GeneratedColumn<String>(
    'apk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INVALID USER'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    fullName,
    position,
    contactInfo,
    dateHired,
    userCode,
    accessType,
    status,
    apk,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_data_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserDataTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('contact_info')) {
      context.handle(
        _contactInfoMeta,
        contactInfo.isAcceptableOrUnknown(
          data['contact_info']!,
          _contactInfoMeta,
        ),
      );
    }
    if (data.containsKey('date_hired')) {
      context.handle(
        _dateHiredMeta,
        dateHired.isAcceptableOrUnknown(data['date_hired']!, _dateHiredMeta),
      );
    }
    if (data.containsKey('user_code')) {
      context.handle(
        _userCodeMeta,
        userCode.isAcceptableOrUnknown(data['user_code']!, _userCodeMeta),
      );
    }
    if (data.containsKey('access_type')) {
      context.handle(
        _accessTypeMeta,
        accessType.isAcceptableOrUnknown(data['access_type']!, _accessTypeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('apk')) {
      context.handle(
        _apkMeta,
        apk.isAcceptableOrUnknown(data['apk']!, _apkMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserDataTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      contactInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_info'],
      )!,
      dateHired: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_hired'],
      )!,
      userCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_code'],
      )!,
      accessType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}access_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      apk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apk'],
      )!,
    );
  }

  @override
  $UserDataTableTable createAlias(String alias) {
    return $UserDataTableTable(attachedDatabase, alias);
  }
}

class UserDataTableData extends DataClass
    implements Insertable<UserDataTableData> {
  final String id;
  final String employeeId;
  final String fullName;
  final int position;
  final String contactInfo;
  final String dateHired;
  final int userCode;
  final int accessType;
  final String status;
  final String apk;
  const UserDataTableData({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.position,
    required this.contactInfo,
    required this.dateHired,
    required this.userCode,
    required this.accessType,
    required this.status,
    required this.apk,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['full_name'] = Variable<String>(fullName);
    map['position'] = Variable<int>(position);
    map['contact_info'] = Variable<String>(contactInfo);
    map['date_hired'] = Variable<String>(dateHired);
    map['user_code'] = Variable<int>(userCode);
    map['access_type'] = Variable<int>(accessType);
    map['status'] = Variable<String>(status);
    map['apk'] = Variable<String>(apk);
    return map;
  }

  UserDataTableCompanion toCompanion(bool nullToAbsent) {
    return UserDataTableCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      fullName: Value(fullName),
      position: Value(position),
      contactInfo: Value(contactInfo),
      dateHired: Value(dateHired),
      userCode: Value(userCode),
      accessType: Value(accessType),
      status: Value(status),
      apk: Value(apk),
    );
  }

  factory UserDataTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserDataTableData(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      position: serializer.fromJson<int>(json['position']),
      contactInfo: serializer.fromJson<String>(json['contactInfo']),
      dateHired: serializer.fromJson<String>(json['dateHired']),
      userCode: serializer.fromJson<int>(json['userCode']),
      accessType: serializer.fromJson<int>(json['accessType']),
      status: serializer.fromJson<String>(json['status']),
      apk: serializer.fromJson<String>(json['apk']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'fullName': serializer.toJson<String>(fullName),
      'position': serializer.toJson<int>(position),
      'contactInfo': serializer.toJson<String>(contactInfo),
      'dateHired': serializer.toJson<String>(dateHired),
      'userCode': serializer.toJson<int>(userCode),
      'accessType': serializer.toJson<int>(accessType),
      'status': serializer.toJson<String>(status),
      'apk': serializer.toJson<String>(apk),
    };
  }

  UserDataTableData copyWith({
    String? id,
    String? employeeId,
    String? fullName,
    int? position,
    String? contactInfo,
    String? dateHired,
    int? userCode,
    int? accessType,
    String? status,
    String? apk,
  }) => UserDataTableData(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    fullName: fullName ?? this.fullName,
    position: position ?? this.position,
    contactInfo: contactInfo ?? this.contactInfo,
    dateHired: dateHired ?? this.dateHired,
    userCode: userCode ?? this.userCode,
    accessType: accessType ?? this.accessType,
    status: status ?? this.status,
    apk: apk ?? this.apk,
  );
  UserDataTableData copyWithCompanion(UserDataTableCompanion data) {
    return UserDataTableData(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      position: data.position.present ? data.position.value : this.position,
      contactInfo: data.contactInfo.present
          ? data.contactInfo.value
          : this.contactInfo,
      dateHired: data.dateHired.present ? data.dateHired.value : this.dateHired,
      userCode: data.userCode.present ? data.userCode.value : this.userCode,
      accessType: data.accessType.present
          ? data.accessType.value
          : this.accessType,
      status: data.status.present ? data.status.value : this.status,
      apk: data.apk.present ? data.apk.value : this.apk,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserDataTableData(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('fullName: $fullName, ')
          ..write('position: $position, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('dateHired: $dateHired, ')
          ..write('userCode: $userCode, ')
          ..write('accessType: $accessType, ')
          ..write('status: $status, ')
          ..write('apk: $apk')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    fullName,
    position,
    contactInfo,
    dateHired,
    userCode,
    accessType,
    status,
    apk,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserDataTableData &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.fullName == this.fullName &&
          other.position == this.position &&
          other.contactInfo == this.contactInfo &&
          other.dateHired == this.dateHired &&
          other.userCode == this.userCode &&
          other.accessType == this.accessType &&
          other.status == this.status &&
          other.apk == this.apk);
}

class UserDataTableCompanion extends UpdateCompanion<UserDataTableData> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> fullName;
  final Value<int> position;
  final Value<String> contactInfo;
  final Value<String> dateHired;
  final Value<int> userCode;
  final Value<int> accessType;
  final Value<String> status;
  final Value<String> apk;
  final Value<int> rowid;
  const UserDataTableCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.position = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.dateHired = const Value.absent(),
    this.userCode = const Value.absent(),
    this.accessType = const Value.absent(),
    this.status = const Value.absent(),
    this.apk = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserDataTableCompanion.insert({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.position = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.dateHired = const Value.absent(),
    this.userCode = const Value.absent(),
    this.accessType = const Value.absent(),
    this.status = const Value.absent(),
    this.apk = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<UserDataTableData> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? fullName,
    Expression<int>? position,
    Expression<String>? contactInfo,
    Expression<String>? dateHired,
    Expression<int>? userCode,
    Expression<int>? accessType,
    Expression<String>? status,
    Expression<String>? apk,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (fullName != null) 'full_name': fullName,
      if (position != null) 'position': position,
      if (contactInfo != null) 'contact_info': contactInfo,
      if (dateHired != null) 'date_hired': dateHired,
      if (userCode != null) 'user_code': userCode,
      if (accessType != null) 'access_type': accessType,
      if (status != null) 'status': status,
      if (apk != null) 'apk': apk,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserDataTableCompanion copyWith({
    Value<String>? id,
    Value<String>? employeeId,
    Value<String>? fullName,
    Value<int>? position,
    Value<String>? contactInfo,
    Value<String>? dateHired,
    Value<int>? userCode,
    Value<int>? accessType,
    Value<String>? status,
    Value<String>? apk,
    Value<int>? rowid,
  }) {
    return UserDataTableCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      contactInfo: contactInfo ?? this.contactInfo,
      dateHired: dateHired ?? this.dateHired,
      userCode: userCode ?? this.userCode,
      accessType: accessType ?? this.accessType,
      status: status ?? this.status,
      apk: apk ?? this.apk,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (contactInfo.present) {
      map['contact_info'] = Variable<String>(contactInfo.value);
    }
    if (dateHired.present) {
      map['date_hired'] = Variable<String>(dateHired.value);
    }
    if (userCode.present) {
      map['user_code'] = Variable<int>(userCode.value);
    }
    if (accessType.present) {
      map['access_type'] = Variable<int>(accessType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (apk.present) {
      map['apk'] = Variable<String>(apk.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserDataTableCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('fullName: $fullName, ')
          ..write('position: $position, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('dateHired: $dateHired, ')
          ..write('userCode: $userCode, ')
          ..write('accessType: $accessType, ')
          ..write('status: $status, ')
          ..write('apk: $apk, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BranchConfigTableTable extends BranchConfigTable
    with TableInfo<$BranchConfigTableTable, BranchConfigTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('branch_config'),
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _branchNameMeta = const VerificationMeta(
    'branchName',
  );
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
    'branch_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _tinMeta = const VerificationMeta('tin');
  @override
  late final GeneratedColumn<String> tin = GeneratedColumn<String>(
    'tin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _logoMeta = const VerificationMeta('logo');
  @override
  late final GeneratedColumn<String> logo = GeneratedColumn<String>(
    'logo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<String> createdDate = GeneratedColumn<String>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    branchName,
    tin,
    address,
    logo,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branch_config_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BranchConfigTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    }
    if (data.containsKey('branch_name')) {
      context.handle(
        _branchNameMeta,
        branchName.isAcceptableOrUnknown(data['branch_name']!, _branchNameMeta),
      );
    }
    if (data.containsKey('tin')) {
      context.handle(
        _tinMeta,
        tin.isAcceptableOrUnknown(data['tin']!, _tinMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('logo')) {
      context.handle(
        _logoMeta,
        logo.isAcceptableOrUnknown(data['logo']!, _logoMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BranchConfigTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BranchConfigTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      branchName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_name'],
      )!,
      tin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tin'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      logo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_date'],
      )!,
    );
  }

  @override
  $BranchConfigTableTable createAlias(String alias) {
    return $BranchConfigTableTable(attachedDatabase, alias);
  }
}

class BranchConfigTableData extends DataClass
    implements Insertable<BranchConfigTableData> {
  final String id;
  final String branchId;
  final String branchName;
  final String tin;
  final String address;
  final String logo;
  final String status;
  final String createdBy;
  final String createdDate;
  const BranchConfigTableData({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.tin,
    required this.address,
    required this.logo,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['branch_name'] = Variable<String>(branchName);
    map['tin'] = Variable<String>(tin);
    map['address'] = Variable<String>(address);
    map['logo'] = Variable<String>(logo);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  BranchConfigTableCompanion toCompanion(bool nullToAbsent) {
    return BranchConfigTableCompanion(
      id: Value(id),
      branchId: Value(branchId),
      branchName: Value(branchName),
      tin: Value(tin),
      address: Value(address),
      logo: Value(logo),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory BranchConfigTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BranchConfigTableData(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      branchName: serializer.fromJson<String>(json['branchName']),
      tin: serializer.fromJson<String>(json['tin']),
      address: serializer.fromJson<String>(json['address']),
      logo: serializer.fromJson<String>(json['logo']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<String>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'branchName': serializer.toJson<String>(branchName),
      'tin': serializer.toJson<String>(tin),
      'address': serializer.toJson<String>(address),
      'logo': serializer.toJson<String>(logo),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  BranchConfigTableData copyWith({
    String? id,
    String? branchId,
    String? branchName,
    String? tin,
    String? address,
    String? logo,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => BranchConfigTableData(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    branchName: branchName ?? this.branchName,
    tin: tin ?? this.tin,
    address: address ?? this.address,
    logo: logo ?? this.logo,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  BranchConfigTableData copyWithCompanion(BranchConfigTableCompanion data) {
    return BranchConfigTableData(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      branchName: data.branchName.present
          ? data.branchName.value
          : this.branchName,
      tin: data.tin.present ? data.tin.value : this.tin,
      address: data.address.present ? data.address.value : this.address,
      logo: data.logo.present ? data.logo.value : this.logo,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BranchConfigTableData(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('branchName: $branchName, ')
          ..write('tin: $tin, ')
          ..write('address: $address, ')
          ..write('logo: $logo, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    branchName,
    tin,
    address,
    logo,
    status,
    createdBy,
    createdDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BranchConfigTableData &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.branchName == this.branchName &&
          other.tin == this.tin &&
          other.address == this.address &&
          other.logo == this.logo &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class BranchConfigTableCompanion
    extends UpdateCompanion<BranchConfigTableData> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> branchName;
  final Value<String> tin;
  final Value<String> address;
  final Value<String> logo;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  final Value<int> rowid;
  const BranchConfigTableCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.branchName = const Value.absent(),
    this.tin = const Value.absent(),
    this.address = const Value.absent(),
    this.logo = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BranchConfigTableCompanion.insert({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.branchName = const Value.absent(),
    this.tin = const Value.absent(),
    this.address = const Value.absent(),
    this.logo = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<BranchConfigTableData> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? branchName,
    Expression<String>? tin,
    Expression<String>? address,
    Expression<String>? logo,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (branchName != null) 'branch_name': branchName,
      if (tin != null) 'tin': tin,
      if (address != null) 'address': address,
      if (logo != null) 'logo': logo,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BranchConfigTableCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? branchName,
    Value<String>? tin,
    Value<String>? address,
    Value<String>? logo,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
    Value<int>? rowid,
  }) {
    return BranchConfigTableCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      tin: tin ?? this.tin,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (tin.present) {
      map['tin'] = Variable<String>(tin.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (logo.present) {
      map['logo'] = Variable<String>(logo.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<String>(createdDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchConfigTableCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('branchName: $branchName, ')
          ..write('tin: $tin, ')
          ..write('address: $address, ')
          ..write('logo: $logo, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DomainConfigTableTable extends DomainConfigTable
    with TableInfo<$DomainConfigTableTable, DomainConfigTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DomainConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('domain_config'),
  );
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('http://please.setup.domain.com/'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, domain];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'domain_config_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DomainConfigTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DomainConfigTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DomainConfigTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      domain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}domain'],
      )!,
    );
  }

  @override
  $DomainConfigTableTable createAlias(String alias) {
    return $DomainConfigTableTable(attachedDatabase, alias);
  }
}

class DomainConfigTableData extends DataClass
    implements Insertable<DomainConfigTableData> {
  final String id;
  final String domain;
  const DomainConfigTableData({required this.id, required this.domain});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['domain'] = Variable<String>(domain);
    return map;
  }

  DomainConfigTableCompanion toCompanion(bool nullToAbsent) {
    return DomainConfigTableCompanion(id: Value(id), domain: Value(domain));
  }

  factory DomainConfigTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DomainConfigTableData(
      id: serializer.fromJson<String>(json['id']),
      domain: serializer.fromJson<String>(json['domain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'domain': serializer.toJson<String>(domain),
    };
  }

  DomainConfigTableData copyWith({String? id, String? domain}) =>
      DomainConfigTableData(id: id ?? this.id, domain: domain ?? this.domain);
  DomainConfigTableData copyWithCompanion(DomainConfigTableCompanion data) {
    return DomainConfigTableData(
      id: data.id.present ? data.id.value : this.id,
      domain: data.domain.present ? data.domain.value : this.domain,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DomainConfigTableData(')
          ..write('id: $id, ')
          ..write('domain: $domain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, domain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DomainConfigTableData &&
          other.id == this.id &&
          other.domain == this.domain);
}

class DomainConfigTableCompanion
    extends UpdateCompanion<DomainConfigTableData> {
  final Value<String> id;
  final Value<String> domain;
  final Value<int> rowid;
  const DomainConfigTableCompanion({
    this.id = const Value.absent(),
    this.domain = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DomainConfigTableCompanion.insert({
    this.id = const Value.absent(),
    this.domain = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<DomainConfigTableData> custom({
    Expression<String>? id,
    Expression<String>? domain,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (domain != null) 'domain': domain,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DomainConfigTableCompanion copyWith({
    Value<String>? id,
    Value<String>? domain,
    Value<int>? rowid,
  }) {
    return DomainConfigTableCompanion(
      id: id ?? this.id,
      domain: domain ?? this.domain,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DomainConfigTableCompanion(')
          ..write('id: $id, ')
          ..write('domain: $domain, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryCodeMeta = const VerificationMeta(
    'categoryCode',
  );
  @override
  late final GeneratedColumn<int> categoryCode = GeneratedColumn<int>(
    'category_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<String> createdDate = GeneratedColumn<String>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _isDisplayMeta = const VerificationMeta(
    'isDisplay',
  );
  @override
  late final GeneratedColumn<int> isDisplay = GeneratedColumn<int>(
    'is_display',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    categoryCode,
    categoryName,
    status,
    createdBy,
    createdDate,
    isDisplay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_code')) {
      context.handle(
        _categoryCodeMeta,
        categoryCode.isAcceptableOrUnknown(
          data['category_code']!,
          _categoryCodeMeta,
        ),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    if (data.containsKey('is_display')) {
      context.handle(
        _isDisplayMeta,
        isDisplay.isAcceptableOrUnknown(data['is_display']!, _isDisplayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryCode};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      categoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_code'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_date'],
      )!,
      isDisplay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_display'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int categoryCode;
  final String categoryName;
  final String status;
  final String createdBy;
  final String createdDate;
  final int isDisplay;
  const CategoriesTableData({
    required this.categoryCode,
    required this.categoryName,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.isDisplay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_code'] = Variable<int>(categoryCode);
    map['category_name'] = Variable<String>(categoryName);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    map['is_display'] = Variable<int>(isDisplay);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      categoryCode: Value(categoryCode),
      categoryName: Value(categoryName),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
      isDisplay: Value(isDisplay),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      categoryCode: serializer.fromJson<int>(json['categoryCode']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<String>(json['createdDate']),
      isDisplay: serializer.fromJson<int>(json['isDisplay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryCode': serializer.toJson<int>(categoryCode),
      'categoryName': serializer.toJson<String>(categoryName),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
      'isDisplay': serializer.toJson<int>(isDisplay),
    };
  }

  CategoriesTableData copyWith({
    int? categoryCode,
    String? categoryName,
    String? status,
    String? createdBy,
    String? createdDate,
    int? isDisplay,
  }) => CategoriesTableData(
    categoryCode: categoryCode ?? this.categoryCode,
    categoryName: categoryName ?? this.categoryName,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
    isDisplay: isDisplay ?? this.isDisplay,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
      isDisplay: data.isDisplay.present ? data.isDisplay.value : this.isDisplay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('categoryCode: $categoryCode, ')
          ..write('categoryName: $categoryName, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate, ')
          ..write('isDisplay: $isDisplay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    categoryCode,
    categoryName,
    status,
    createdBy,
    createdDate,
    isDisplay,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.categoryCode == this.categoryCode &&
          other.categoryName == this.categoryName &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate &&
          other.isDisplay == this.isDisplay);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> categoryCode;
  final Value<String> categoryName;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  final Value<int> isDisplay;
  const CategoriesTableCompanion({
    this.categoryCode = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.isDisplay = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.categoryCode = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.isDisplay = const Value.absent(),
  });
  static Insertable<CategoriesTableData> custom({
    Expression<int>? categoryCode,
    Expression<String>? categoryName,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
    Expression<int>? isDisplay,
  }) {
    return RawValuesInsertable({
      if (categoryCode != null) 'category_code': categoryCode,
      if (categoryName != null) 'category_name': categoryName,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
      if (isDisplay != null) 'is_display': isDisplay,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<int>? categoryCode,
    Value<String>? categoryName,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
    Value<int>? isDisplay,
  }) {
    return CategoriesTableCompanion(
      categoryCode: categoryCode ?? this.categoryCode,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      isDisplay: isDisplay ?? this.isDisplay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryCode.present) {
      map['category_code'] = Variable<int>(categoryCode.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<String>(createdDate.value);
    }
    if (isDisplay.present) {
      map['is_display'] = Variable<int>(isDisplay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('categoryCode: $categoryCode, ')
          ..write('categoryName: $categoryName, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate, ')
          ..write('isDisplay: $isDisplay')
          ..write(')'))
        .toString();
  }
}

class $DenominationsTableTable extends DenominationsTable
    with TableInfo<$DenominationsTableTable, DenominationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DenominationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<String> createdDate = GeneratedColumn<String>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    description,
    value,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'denominations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DenominationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DenominationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DenominationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_date'],
      )!,
    );
  }

  @override
  $DenominationsTableTable createAlias(String alias) {
    return $DenominationsTableTable(attachedDatabase, alias);
  }
}

class DenominationsTableData extends DataClass
    implements Insertable<DenominationsTableData> {
  final int id;
  final String code;
  final String description;
  final int value;
  final String status;
  final String createdBy;
  final String createdDate;
  const DenominationsTableData({
    required this.id,
    required this.code,
    required this.description,
    required this.value,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['description'] = Variable<String>(description);
    map['value'] = Variable<int>(value);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  DenominationsTableCompanion toCompanion(bool nullToAbsent) {
    return DenominationsTableCompanion(
      id: Value(id),
      code: Value(code),
      description: Value(description),
      value: Value(value),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory DenominationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DenominationsTableData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      description: serializer.fromJson<String>(json['description']),
      value: serializer.fromJson<int>(json['value']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<String>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'description': serializer.toJson<String>(description),
      'value': serializer.toJson<int>(value),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  DenominationsTableData copyWith({
    int? id,
    String? code,
    String? description,
    int? value,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => DenominationsTableData(
    id: id ?? this.id,
    code: code ?? this.code,
    description: description ?? this.description,
    value: value ?? this.value,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  DenominationsTableData copyWithCompanion(DenominationsTableCompanion data) {
    return DenominationsTableData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      description: data.description.present
          ? data.description.value
          : this.description,
      value: data.value.present ? data.value.value : this.value,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DenominationsTableData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('value: $value, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, description, value, status, createdBy, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DenominationsTableData &&
          other.id == this.id &&
          other.code == this.code &&
          other.description == this.description &&
          other.value == this.value &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class DenominationsTableCompanion
    extends UpdateCompanion<DenominationsTableData> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> description;
  final Value<int> value;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  const DenominationsTableCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  DenominationsTableCompanion.insert({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<DenominationsTableData> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? description,
    Expression<int>? value,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  DenominationsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? description,
    Value<int>? value,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
  }) {
    return DenominationsTableCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      value: value ?? this.value,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<String>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DenominationsTableCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('value: $value, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $DiscountsTableTable extends DiscountsTable
    with TableInfo<$DiscountsTableTable, DiscountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _discountIdMeta = const VerificationMeta(
    'discountId',
  );
  @override
  late final GeneratedColumn<int> discountId = GeneratedColumn<int>(
    'discount_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<String> createdDate = GeneratedColumn<String>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    discountId,
    name,
    description,
    rate,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discounts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiscountsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('discount_id')) {
      context.handle(
        _discountIdMeta,
        discountId.isAcceptableOrUnknown(data['discount_id']!, _discountIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {discountId};
  @override
  DiscountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscountsTableData(
      discountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rate'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_date'],
      )!,
    );
  }

  @override
  $DiscountsTableTable createAlias(String alias) {
    return $DiscountsTableTable(attachedDatabase, alias);
  }
}

class DiscountsTableData extends DataClass
    implements Insertable<DiscountsTableData> {
  final int discountId;
  final String name;
  final String description;
  final int rate;
  final String status;
  final String createdBy;
  final String createdDate;
  const DiscountsTableData({
    required this.discountId,
    required this.name,
    required this.description,
    required this.rate,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['discount_id'] = Variable<int>(discountId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['rate'] = Variable<int>(rate);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  DiscountsTableCompanion toCompanion(bool nullToAbsent) {
    return DiscountsTableCompanion(
      discountId: Value(discountId),
      name: Value(name),
      description: Value(description),
      rate: Value(rate),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory DiscountsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscountsTableData(
      discountId: serializer.fromJson<int>(json['discountId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      rate: serializer.fromJson<int>(json['rate']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<String>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'discountId': serializer.toJson<int>(discountId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'rate': serializer.toJson<int>(rate),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  DiscountsTableData copyWith({
    int? discountId,
    String? name,
    String? description,
    int? rate,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => DiscountsTableData(
    discountId: discountId ?? this.discountId,
    name: name ?? this.name,
    description: description ?? this.description,
    rate: rate ?? this.rate,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  DiscountsTableData copyWithCompanion(DiscountsTableCompanion data) {
    return DiscountsTableData(
      discountId: data.discountId.present
          ? data.discountId.value
          : this.discountId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      rate: data.rate.present ? data.rate.value : this.rate,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsTableData(')
          ..write('discountId: $discountId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rate: $rate, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    discountId,
    name,
    description,
    rate,
    status,
    createdBy,
    createdDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscountsTableData &&
          other.discountId == this.discountId &&
          other.name == this.name &&
          other.description == this.description &&
          other.rate == this.rate &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class DiscountsTableCompanion extends UpdateCompanion<DiscountsTableData> {
  final Value<int> discountId;
  final Value<String> name;
  final Value<String> description;
  final Value<int> rate;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  const DiscountsTableCompanion({
    this.discountId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  DiscountsTableCompanion.insert({
    this.discountId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<DiscountsTableData> custom({
    Expression<int>? discountId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rate,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
  }) {
    return RawValuesInsertable({
      if (discountId != null) 'discount_id': discountId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rate != null) 'rate': rate,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  DiscountsTableCompanion copyWith({
    Value<int>? discountId,
    Value<String>? name,
    Value<String>? description,
    Value<int>? rate,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
  }) {
    return DiscountsTableCompanion(
      discountId: discountId ?? this.discountId,
      name: name ?? this.name,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (discountId.present) {
      map['discount_id'] = Variable<int>(discountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<String>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsTableCompanion(')
          ..write('discountId: $discountId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rate: $rate, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTableTable extends EmployeesTable
    with TableInfo<$EmployeesTableTable, EmployeesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _contactInfoMeta = const VerificationMeta(
    'contactInfo',
  );
  @override
  late final GeneratedColumn<String> contactInfo = GeneratedColumn<String>(
    'contact_info',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _dateHiredMeta = const VerificationMeta(
    'dateHired',
  );
  @override
  late final GeneratedColumn<String> dateHired = GeneratedColumn<String>(
    'date_hired',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<String> createdDate = GeneratedColumn<String>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    employeeId,
    fullName,
    position,
    contactInfo,
    dateHired,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('contact_info')) {
      context.handle(
        _contactInfoMeta,
        contactInfo.isAcceptableOrUnknown(
          data['contact_info']!,
          _contactInfoMeta,
        ),
      );
    }
    if (data.containsKey('date_hired')) {
      context.handle(
        _dateHiredMeta,
        dateHired.isAcceptableOrUnknown(data['date_hired']!, _dateHiredMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeesTableData(
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      contactInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_info'],
      )!,
      dateHired: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_hired'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_date'],
      )!,
    );
  }

  @override
  $EmployeesTableTable createAlias(String alias) {
    return $EmployeesTableTable(attachedDatabase, alias);
  }
}

class EmployeesTableData extends DataClass
    implements Insertable<EmployeesTableData> {
  final int employeeId;
  final String fullName;
  final int position;
  final String contactInfo;
  final String dateHired;
  final String status;
  final String createdBy;
  final String createdDate;
  const EmployeesTableData({
    required this.employeeId,
    required this.fullName,
    required this.position,
    required this.contactInfo,
    required this.dateHired,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<int>(employeeId);
    map['full_name'] = Variable<String>(fullName);
    map['position'] = Variable<int>(position);
    map['contact_info'] = Variable<String>(contactInfo);
    map['date_hired'] = Variable<String>(dateHired);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  EmployeesTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeesTableCompanion(
      employeeId: Value(employeeId),
      fullName: Value(fullName),
      position: Value(position),
      contactInfo: Value(contactInfo),
      dateHired: Value(dateHired),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory EmployeesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeesTableData(
      employeeId: serializer.fromJson<int>(json['employeeId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      position: serializer.fromJson<int>(json['position']),
      contactInfo: serializer.fromJson<String>(json['contactInfo']),
      dateHired: serializer.fromJson<String>(json['dateHired']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<String>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<int>(employeeId),
      'fullName': serializer.toJson<String>(fullName),
      'position': serializer.toJson<int>(position),
      'contactInfo': serializer.toJson<String>(contactInfo),
      'dateHired': serializer.toJson<String>(dateHired),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  EmployeesTableData copyWith({
    int? employeeId,
    String? fullName,
    int? position,
    String? contactInfo,
    String? dateHired,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => EmployeesTableData(
    employeeId: employeeId ?? this.employeeId,
    fullName: fullName ?? this.fullName,
    position: position ?? this.position,
    contactInfo: contactInfo ?? this.contactInfo,
    dateHired: dateHired ?? this.dateHired,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  EmployeesTableData copyWithCompanion(EmployeesTableCompanion data) {
    return EmployeesTableData(
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      position: data.position.present ? data.position.value : this.position,
      contactInfo: data.contactInfo.present
          ? data.contactInfo.value
          : this.contactInfo,
      dateHired: data.dateHired.present ? data.dateHired.value : this.dateHired,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesTableData(')
          ..write('employeeId: $employeeId, ')
          ..write('fullName: $fullName, ')
          ..write('position: $position, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('dateHired: $dateHired, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    employeeId,
    fullName,
    position,
    contactInfo,
    dateHired,
    status,
    createdBy,
    createdDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeesTableData &&
          other.employeeId == this.employeeId &&
          other.fullName == this.fullName &&
          other.position == this.position &&
          other.contactInfo == this.contactInfo &&
          other.dateHired == this.dateHired &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class EmployeesTableCompanion extends UpdateCompanion<EmployeesTableData> {
  final Value<int> employeeId;
  final Value<String> fullName;
  final Value<int> position;
  final Value<String> contactInfo;
  final Value<String> dateHired;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  const EmployeesTableCompanion({
    this.employeeId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.position = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.dateHired = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  EmployeesTableCompanion.insert({
    this.employeeId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.position = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.dateHired = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<EmployeesTableData> custom({
    Expression<int>? employeeId,
    Expression<String>? fullName,
    Expression<int>? position,
    Expression<String>? contactInfo,
    Expression<String>? dateHired,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (fullName != null) 'full_name': fullName,
      if (position != null) 'position': position,
      if (contactInfo != null) 'contact_info': contactInfo,
      if (dateHired != null) 'date_hired': dateHired,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  EmployeesTableCompanion copyWith({
    Value<int>? employeeId,
    Value<String>? fullName,
    Value<int>? position,
    Value<String>? contactInfo,
    Value<String>? dateHired,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
  }) {
    return EmployeesTableCompanion(
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      contactInfo: contactInfo ?? this.contactInfo,
      dateHired: dateHired ?? this.dateHired,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (contactInfo.present) {
      map['contact_info'] = Variable<String>(contactInfo.value);
    }
    if (dateHired.present) {
      map['date_hired'] = Variable<String>(dateHired.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<String>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesTableCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('fullName: $fullName, ')
          ..write('position: $position, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('dateHired: $dateHired, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTableTable extends PaymentsTable
    with TableInfo<$PaymentsTableTable, PaymentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _paymentIdMeta = const VerificationMeta(
    'paymentId',
  );
  @override
  late final GeneratedColumn<int> paymentId = GeneratedColumn<int>(
    'payment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentNameMeta = const VerificationMeta(
    'paymentName',
  );
  @override
  late final GeneratedColumn<String> paymentName = GeneratedColumn<String>(
    'payment_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdbyMeta = const VerificationMeta(
    'createdby',
  );
  @override
  late final GeneratedColumn<String> createdby = GeneratedColumn<String>(
    'createdby',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createddateMeta = const VerificationMeta(
    'createddate',
  );
  @override
  late final GeneratedColumn<String> createddate = GeneratedColumn<String>(
    'createddate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    paymentId,
    paymentName,
    status,
    createdby,
    createddate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('payment_id')) {
      context.handle(
        _paymentIdMeta,
        paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta),
      );
    }
    if (data.containsKey('payment_name')) {
      context.handle(
        _paymentNameMeta,
        paymentName.isAcceptableOrUnknown(
          data['payment_name']!,
          _paymentNameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('createdby')) {
      context.handle(
        _createdbyMeta,
        createdby.isAcceptableOrUnknown(data['createdby']!, _createdbyMeta),
      );
    }
    if (data.containsKey('createddate')) {
      context.handle(
        _createddateMeta,
        createddate.isAcceptableOrUnknown(
          data['createddate']!,
          _createddateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {paymentId};
  @override
  PaymentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentsTableData(
      paymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_id'],
      )!,
      paymentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdby: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}createdby'],
      )!,
      createddate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}createddate'],
      )!,
    );
  }

  @override
  $PaymentsTableTable createAlias(String alias) {
    return $PaymentsTableTable(attachedDatabase, alias);
  }
}

class PaymentsTableData extends DataClass
    implements Insertable<PaymentsTableData> {
  final int paymentId;
  final String paymentName;
  final String status;
  final String createdby;
  final String createddate;
  const PaymentsTableData({
    required this.paymentId,
    required this.paymentName,
    required this.status,
    required this.createdby,
    required this.createddate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['payment_id'] = Variable<int>(paymentId);
    map['payment_name'] = Variable<String>(paymentName);
    map['status'] = Variable<String>(status);
    map['createdby'] = Variable<String>(createdby);
    map['createddate'] = Variable<String>(createddate);
    return map;
  }

  PaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentsTableCompanion(
      paymentId: Value(paymentId),
      paymentName: Value(paymentName),
      status: Value(status),
      createdby: Value(createdby),
      createddate: Value(createddate),
    );
  }

  factory PaymentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentsTableData(
      paymentId: serializer.fromJson<int>(json['paymentId']),
      paymentName: serializer.fromJson<String>(json['paymentName']),
      status: serializer.fromJson<String>(json['status']),
      createdby: serializer.fromJson<String>(json['createdby']),
      createddate: serializer.fromJson<String>(json['createddate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'paymentId': serializer.toJson<int>(paymentId),
      'paymentName': serializer.toJson<String>(paymentName),
      'status': serializer.toJson<String>(status),
      'createdby': serializer.toJson<String>(createdby),
      'createddate': serializer.toJson<String>(createddate),
    };
  }

  PaymentsTableData copyWith({
    int? paymentId,
    String? paymentName,
    String? status,
    String? createdby,
    String? createddate,
  }) => PaymentsTableData(
    paymentId: paymentId ?? this.paymentId,
    paymentName: paymentName ?? this.paymentName,
    status: status ?? this.status,
    createdby: createdby ?? this.createdby,
    createddate: createddate ?? this.createddate,
  );
  PaymentsTableData copyWithCompanion(PaymentsTableCompanion data) {
    return PaymentsTableData(
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      paymentName: data.paymentName.present
          ? data.paymentName.value
          : this.paymentName,
      status: data.status.present ? data.status.value : this.status,
      createdby: data.createdby.present ? data.createdby.value : this.createdby,
      createddate: data.createddate.present
          ? data.createddate.value
          : this.createddate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableData(')
          ..write('paymentId: $paymentId, ')
          ..write('paymentName: $paymentName, ')
          ..write('status: $status, ')
          ..write('createdby: $createdby, ')
          ..write('createddate: $createddate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(paymentId, paymentName, status, createdby, createddate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentsTableData &&
          other.paymentId == this.paymentId &&
          other.paymentName == this.paymentName &&
          other.status == this.status &&
          other.createdby == this.createdby &&
          other.createddate == this.createddate);
}

class PaymentsTableCompanion extends UpdateCompanion<PaymentsTableData> {
  final Value<int> paymentId;
  final Value<String> paymentName;
  final Value<String> status;
  final Value<String> createdby;
  final Value<String> createddate;
  const PaymentsTableCompanion({
    this.paymentId = const Value.absent(),
    this.paymentName = const Value.absent(),
    this.status = const Value.absent(),
    this.createdby = const Value.absent(),
    this.createddate = const Value.absent(),
  });
  PaymentsTableCompanion.insert({
    this.paymentId = const Value.absent(),
    this.paymentName = const Value.absent(),
    this.status = const Value.absent(),
    this.createdby = const Value.absent(),
    this.createddate = const Value.absent(),
  });
  static Insertable<PaymentsTableData> custom({
    Expression<int>? paymentId,
    Expression<String>? paymentName,
    Expression<String>? status,
    Expression<String>? createdby,
    Expression<String>? createddate,
  }) {
    return RawValuesInsertable({
      if (paymentId != null) 'payment_id': paymentId,
      if (paymentName != null) 'payment_name': paymentName,
      if (status != null) 'status': status,
      if (createdby != null) 'createdby': createdby,
      if (createddate != null) 'createddate': createddate,
    });
  }

  PaymentsTableCompanion copyWith({
    Value<int>? paymentId,
    Value<String>? paymentName,
    Value<String>? status,
    Value<String>? createdby,
    Value<String>? createddate,
  }) {
    return PaymentsTableCompanion(
      paymentId: paymentId ?? this.paymentId,
      paymentName: paymentName ?? this.paymentName,
      status: status ?? this.status,
      createdby: createdby ?? this.createdby,
      createddate: createddate ?? this.createddate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (paymentName.present) {
      map['payment_name'] = Variable<String>(paymentName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdby.present) {
      map['createdby'] = Variable<String>(createdby.value);
    }
    if (createddate.present) {
      map['createddate'] = Variable<String>(createddate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableCompanion(')
          ..write('paymentId: $paymentId, ')
          ..write('paymentName: $paymentName, ')
          ..write('status: $status, ')
          ..write('createdby: $createdby, ')
          ..write('createddate: $createddate')
          ..write(')'))
        .toString();
  }
}

class $PosDetailIdTableTable extends PosDetailIdTable
    with TableInfo<$PosDetailIdTableTable, PosDetailIdTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PosDetailIdTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pos_detail_id'),
  );
  static const VerificationMeta _posDetailIdMeta = const VerificationMeta(
    'posDetailId',
  );
  @override
  late final GeneratedColumn<String> posDetailId = GeneratedColumn<String>(
    'pos_detail_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, posDetailId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos_detail_id_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PosDetailIdTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pos_detail_id')) {
      context.handle(
        _posDetailIdMeta,
        posDetailId.isAcceptableOrUnknown(
          data['pos_detail_id']!,
          _posDetailIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PosDetailIdTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosDetailIdTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      posDetailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_detail_id'],
      )!,
    );
  }

  @override
  $PosDetailIdTableTable createAlias(String alias) {
    return $PosDetailIdTableTable(attachedDatabase, alias);
  }
}

class PosDetailIdTableData extends DataClass
    implements Insertable<PosDetailIdTableData> {
  final String id;
  final String posDetailId;
  const PosDetailIdTableData({required this.id, required this.posDetailId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pos_detail_id'] = Variable<String>(posDetailId);
    return map;
  }

  PosDetailIdTableCompanion toCompanion(bool nullToAbsent) {
    return PosDetailIdTableCompanion(
      id: Value(id),
      posDetailId: Value(posDetailId),
    );
  }

  factory PosDetailIdTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosDetailIdTableData(
      id: serializer.fromJson<String>(json['id']),
      posDetailId: serializer.fromJson<String>(json['posDetailId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'posDetailId': serializer.toJson<String>(posDetailId),
    };
  }

  PosDetailIdTableData copyWith({String? id, String? posDetailId}) =>
      PosDetailIdTableData(
        id: id ?? this.id,
        posDetailId: posDetailId ?? this.posDetailId,
      );
  PosDetailIdTableData copyWithCompanion(PosDetailIdTableCompanion data) {
    return PosDetailIdTableData(
      id: data.id.present ? data.id.value : this.id,
      posDetailId: data.posDetailId.present
          ? data.posDetailId.value
          : this.posDetailId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PosDetailIdTableData(')
          ..write('id: $id, ')
          ..write('posDetailId: $posDetailId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, posDetailId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosDetailIdTableData &&
          other.id == this.id &&
          other.posDetailId == this.posDetailId);
}

class PosDetailIdTableCompanion extends UpdateCompanion<PosDetailIdTableData> {
  final Value<String> id;
  final Value<String> posDetailId;
  final Value<int> rowid;
  const PosDetailIdTableCompanion({
    this.id = const Value.absent(),
    this.posDetailId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PosDetailIdTableCompanion.insert({
    this.id = const Value.absent(),
    this.posDetailId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PosDetailIdTableData> custom({
    Expression<String>? id,
    Expression<String>? posDetailId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (posDetailId != null) 'pos_detail_id': posDetailId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PosDetailIdTableCompanion copyWith({
    Value<String>? id,
    Value<String>? posDetailId,
    Value<int>? rowid,
  }) {
    return PosDetailIdTableCompanion(
      id: id ?? this.id,
      posDetailId: posDetailId ?? this.posDetailId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (posDetailId.present) {
      map['pos_detail_id'] = Variable<String>(posDetailId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosDetailIdTableCompanion(')
          ..write('id: $id, ')
          ..write('posDetailId: $posDetailId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PosShiftTableTable extends PosShiftTable
    with TableInfo<$PosShiftTableTable, PosShiftTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PosShiftTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<String> posId = GeneratedColumn<String>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<String> shift = GeneratedColumn<String>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [posId, date, shift, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos_shift_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PosShiftTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {posId};
  @override
  PosShiftTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosShiftTableData(
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $PosShiftTableTable createAlias(String alias) {
    return $PosShiftTableTable(attachedDatabase, alias);
  }
}

class PosShiftTableData extends DataClass
    implements Insertable<PosShiftTableData> {
  final String posId;
  final String date;
  final String shift;
  final String status;
  const PosShiftTableData({
    required this.posId,
    required this.date,
    required this.shift,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pos_id'] = Variable<String>(posId);
    map['date'] = Variable<String>(date);
    map['shift'] = Variable<String>(shift);
    map['status'] = Variable<String>(status);
    return map;
  }

  PosShiftTableCompanion toCompanion(bool nullToAbsent) {
    return PosShiftTableCompanion(
      posId: Value(posId),
      date: Value(date),
      shift: Value(shift),
      status: Value(status),
    );
  }

  factory PosShiftTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosShiftTableData(
      posId: serializer.fromJson<String>(json['posId']),
      date: serializer.fromJson<String>(json['date']),
      shift: serializer.fromJson<String>(json['shift']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'posId': serializer.toJson<String>(posId),
      'date': serializer.toJson<String>(date),
      'shift': serializer.toJson<String>(shift),
      'status': serializer.toJson<String>(status),
    };
  }

  PosShiftTableData copyWith({
    String? posId,
    String? date,
    String? shift,
    String? status,
  }) => PosShiftTableData(
    posId: posId ?? this.posId,
    date: date ?? this.date,
    shift: shift ?? this.shift,
    status: status ?? this.status,
  );
  PosShiftTableData copyWithCompanion(PosShiftTableCompanion data) {
    return PosShiftTableData(
      posId: data.posId.present ? data.posId.value : this.posId,
      date: data.date.present ? data.date.value : this.date,
      shift: data.shift.present ? data.shift.value : this.shift,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PosShiftTableData(')
          ..write('posId: $posId, ')
          ..write('date: $date, ')
          ..write('shift: $shift, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(posId, date, shift, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosShiftTableData &&
          other.posId == this.posId &&
          other.date == this.date &&
          other.shift == this.shift &&
          other.status == this.status);
}

class PosShiftTableCompanion extends UpdateCompanion<PosShiftTableData> {
  final Value<String> posId;
  final Value<String> date;
  final Value<String> shift;
  final Value<String> status;
  final Value<int> rowid;
  const PosShiftTableCompanion({
    this.posId = const Value.absent(),
    this.date = const Value.absent(),
    this.shift = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PosShiftTableCompanion.insert({
    this.posId = const Value.absent(),
    this.date = const Value.absent(),
    this.shift = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PosShiftTableData> custom({
    Expression<String>? posId,
    Expression<String>? date,
    Expression<String>? shift,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (posId != null) 'pos_id': posId,
      if (date != null) 'date': date,
      if (shift != null) 'shift': shift,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PosShiftTableCompanion copyWith({
    Value<String>? posId,
    Value<String>? date,
    Value<String>? shift,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return PosShiftTableCompanion(
      posId: posId ?? this.posId,
      date: date ?? this.date,
      shift: shift ?? this.shift,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (posId.present) {
      map['pos_id'] = Variable<String>(posId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosShiftTableCompanion(')
          ..write('posId: $posId, ')
          ..write('date: $date, ')
          ..write('shift: $shift, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductPriceTableTable extends ProductPriceTable
    with TableInfo<$ProductPriceTableTable, ProductPriceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPriceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    description,
    barcode,
    price,
    category,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_price_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductPriceTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  ProductPriceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPriceTableData(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $ProductPriceTableTable createAlias(String alias) {
    return $ProductPriceTableTable(attachedDatabase, alias);
  }
}

class ProductPriceTableData extends DataClass
    implements Insertable<ProductPriceTableData> {
  final int productId;
  final String description;
  final String barcode;
  final String price;
  final int category;
  final int quantity;
  const ProductPriceTableData({
    required this.productId,
    required this.description,
    required this.barcode,
    required this.price,
    required this.category,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['description'] = Variable<String>(description);
    map['barcode'] = Variable<String>(barcode);
    map['price'] = Variable<String>(price);
    map['category'] = Variable<int>(category);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  ProductPriceTableCompanion toCompanion(bool nullToAbsent) {
    return ProductPriceTableCompanion(
      productId: Value(productId),
      description: Value(description),
      barcode: Value(barcode),
      price: Value(price),
      category: Value(category),
      quantity: Value(quantity),
    );
  }

  factory ProductPriceTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPriceTableData(
      productId: serializer.fromJson<int>(json['productId']),
      description: serializer.fromJson<String>(json['description']),
      barcode: serializer.fromJson<String>(json['barcode']),
      price: serializer.fromJson<String>(json['price']),
      category: serializer.fromJson<int>(json['category']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'description': serializer.toJson<String>(description),
      'barcode': serializer.toJson<String>(barcode),
      'price': serializer.toJson<String>(price),
      'category': serializer.toJson<int>(category),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  ProductPriceTableData copyWith({
    int? productId,
    String? description,
    String? barcode,
    String? price,
    int? category,
    int? quantity,
  }) => ProductPriceTableData(
    productId: productId ?? this.productId,
    description: description ?? this.description,
    barcode: barcode ?? this.barcode,
    price: price ?? this.price,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
  );
  ProductPriceTableData copyWithCompanion(ProductPriceTableCompanion data) {
    return ProductPriceTableData(
      productId: data.productId.present ? data.productId.value : this.productId,
      description: data.description.present
          ? data.description.value
          : this.description,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPriceTableData(')
          ..write('productId: $productId, ')
          ..write('description: $description, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(productId, description, barcode, price, category, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPriceTableData &&
          other.productId == this.productId &&
          other.description == this.description &&
          other.barcode == this.barcode &&
          other.price == this.price &&
          other.category == this.category &&
          other.quantity == this.quantity);
}

class ProductPriceTableCompanion
    extends UpdateCompanion<ProductPriceTableData> {
  final Value<int> productId;
  final Value<String> description;
  final Value<String> barcode;
  final Value<String> price;
  final Value<int> category;
  final Value<int> quantity;
  const ProductPriceTableCompanion({
    this.productId = const Value.absent(),
    this.description = const Value.absent(),
    this.barcode = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  ProductPriceTableCompanion.insert({
    this.productId = const Value.absent(),
    this.description = const Value.absent(),
    this.barcode = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  static Insertable<ProductPriceTableData> custom({
    Expression<int>? productId,
    Expression<String>? description,
    Expression<String>? barcode,
    Expression<String>? price,
    Expression<int>? category,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (description != null) 'description': description,
      if (barcode != null) 'barcode': barcode,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
    });
  }

  ProductPriceTableCompanion copyWith({
    Value<int>? productId,
    Value<String>? description,
    Value<String>? barcode,
    Value<String>? price,
    Value<int>? category,
    Value<int>? quantity,
  }) {
    return ProductPriceTableCompanion(
      productId: productId ?? this.productId,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPriceTableCompanion(')
          ..write('productId: $productId, ')
          ..write('description: $description, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $PromoTableTable extends PromoTable
    with TableInfo<$PromoTableTable, PromoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _promoIdMeta = const VerificationMeta(
    'promoId',
  );
  @override
  late final GeneratedColumn<int> promoId = GeneratedColumn<int>(
    'promo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta(
    'createdDate',
  );
  @override
  late final GeneratedColumn<String> createdDate = GeneratedColumn<String>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    promoId,
    name,
    description,
    condition,
    startDate,
    endDate,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promo_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('promo_id')) {
      context.handle(
        _promoIdMeta,
        promoId.isAcceptableOrUnknown(data['promo_id']!, _promoIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(
          data['created_date']!,
          _createdDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {promoId};
  @override
  PromoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromoTableData(
      promoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}promo_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_date'],
      )!,
    );
  }

  @override
  $PromoTableTable createAlias(String alias) {
    return $PromoTableTable(attachedDatabase, alias);
  }
}

class PromoTableData extends DataClass implements Insertable<PromoTableData> {
  final int promoId;
  final String name;
  final String description;
  final String condition;
  final String startDate;
  final String endDate;
  final String status;
  final String createdBy;
  final String createdDate;
  const PromoTableData({
    required this.promoId,
    required this.name,
    required this.description,
    required this.condition,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['promo_id'] = Variable<int>(promoId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['condition'] = Variable<String>(condition);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  PromoTableCompanion toCompanion(bool nullToAbsent) {
    return PromoTableCompanion(
      promoId: Value(promoId),
      name: Value(name),
      description: Value(description),
      condition: Value(condition),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory PromoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromoTableData(
      promoId: serializer.fromJson<int>(json['promoId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      condition: serializer.fromJson<String>(json['condition']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdDate: serializer.fromJson<String>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'promoId': serializer.toJson<int>(promoId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'condition': serializer.toJson<String>(condition),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  PromoTableData copyWith({
    int? promoId,
    String? name,
    String? description,
    String? condition,
    String? startDate,
    String? endDate,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => PromoTableData(
    promoId: promoId ?? this.promoId,
    name: name ?? this.name,
    description: description ?? this.description,
    condition: condition ?? this.condition,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  PromoTableData copyWithCompanion(PromoTableCompanion data) {
    return PromoTableData(
      promoId: data.promoId.present ? data.promoId.value : this.promoId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      condition: data.condition.present ? data.condition.value : this.condition,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromoTableData(')
          ..write('promoId: $promoId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('condition: $condition, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    promoId,
    name,
    description,
    condition,
    startDate,
    endDate,
    status,
    createdBy,
    createdDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromoTableData &&
          other.promoId == this.promoId &&
          other.name == this.name &&
          other.description == this.description &&
          other.condition == this.condition &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class PromoTableCompanion extends UpdateCompanion<PromoTableData> {
  final Value<int> promoId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> condition;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  const PromoTableCompanion({
    this.promoId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.condition = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  PromoTableCompanion.insert({
    this.promoId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.condition = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<PromoTableData> custom({
    Expression<int>? promoId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? condition,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
  }) {
    return RawValuesInsertable({
      if (promoId != null) 'promo_id': promoId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (condition != null) 'condition': condition,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  PromoTableCompanion copyWith({
    Value<int>? promoId,
    Value<String>? name,
    Value<String>? description,
    Value<String>? condition,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
  }) {
    return PromoTableCompanion(
      promoId: promoId ?? this.promoId,
      name: name ?? this.name,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (promoId.present) {
      map['promo_id'] = Variable<int>(promoId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<String>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromoTableCompanion(')
          ..write('promoId: $promoId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('condition: $condition, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $PrintersTableTable extends PrintersTable
    with TableInfo<$PrintersTableTable, PrintersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrintersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DEFAULT'),
  );
  static const VerificationMeta _connectionTypeMeta = const VerificationMeta(
    'connectionType',
  );
  @override
  late final GeneratedColumn<String> connectionType = GeneratedColumn<String>(
    'connection_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('WIFI'),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paperSizeMeta = const VerificationMeta(
    'paperSize',
  );
  @override
  late final GeneratedColumn<String> paperSize = GeneratedColumn<String>(
    'paper_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mm80'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    connectionType,
    address,
    paperSize,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrintersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('connection_type')) {
      context.handle(
        _connectionTypeMeta,
        connectionType.isAcceptableOrUnknown(
          data['connection_type']!,
          _connectionTypeMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('paper_size')) {
      context.handle(
        _paperSizeMeta,
        paperSize.isAcceptableOrUnknown(data['paper_size']!, _paperSizeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrintersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrintersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      connectionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_type'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      paperSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paper_size'],
      )!,
    );
  }

  @override
  $PrintersTableTable createAlias(String alias) {
    return $PrintersTableTable(attachedDatabase, alias);
  }
}

class PrintersTableData extends DataClass
    implements Insertable<PrintersTableData> {
  final String id;
  final String name;
  final String connectionType;
  final String address;
  final String paperSize;
  const PrintersTableData({
    required this.id,
    required this.name,
    required this.connectionType,
    required this.address,
    required this.paperSize,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['connection_type'] = Variable<String>(connectionType);
    map['address'] = Variable<String>(address);
    map['paper_size'] = Variable<String>(paperSize);
    return map;
  }

  PrintersTableCompanion toCompanion(bool nullToAbsent) {
    return PrintersTableCompanion(
      id: Value(id),
      name: Value(name),
      connectionType: Value(connectionType),
      address: Value(address),
      paperSize: Value(paperSize),
    );
  }

  factory PrintersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrintersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      connectionType: serializer.fromJson<String>(json['connectionType']),
      address: serializer.fromJson<String>(json['address']),
      paperSize: serializer.fromJson<String>(json['paperSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'connectionType': serializer.toJson<String>(connectionType),
      'address': serializer.toJson<String>(address),
      'paperSize': serializer.toJson<String>(paperSize),
    };
  }

  PrintersTableData copyWith({
    String? id,
    String? name,
    String? connectionType,
    String? address,
    String? paperSize,
  }) => PrintersTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    connectionType: connectionType ?? this.connectionType,
    address: address ?? this.address,
    paperSize: paperSize ?? this.paperSize,
  );
  PrintersTableData copyWithCompanion(PrintersTableCompanion data) {
    return PrintersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      connectionType: data.connectionType.present
          ? data.connectionType.value
          : this.connectionType,
      address: data.address.present ? data.address.value : this.address,
      paperSize: data.paperSize.present ? data.paperSize.value : this.paperSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrintersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('address: $address, ')
          ..write('paperSize: $paperSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, connectionType, address, paperSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrintersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.connectionType == this.connectionType &&
          other.address == this.address &&
          other.paperSize == this.paperSize);
}

class PrintersTableCompanion extends UpdateCompanion<PrintersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> connectionType;
  final Value<String> address;
  final Value<String> paperSize;
  final Value<int> rowid;
  const PrintersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.address = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrintersTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.address = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PrintersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? connectionType,
    Expression<String>? address,
    Expression<String>? paperSize,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (connectionType != null) 'connection_type': connectionType,
      if (address != null) 'address': address,
      if (paperSize != null) 'paper_size': paperSize,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrintersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? connectionType,
    Value<String>? address,
    Value<String>? paperSize,
    Value<int>? rowid,
  }) {
    return PrintersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      connectionType: connectionType ?? this.connectionType,
      address: address ?? this.address,
      paperSize: paperSize ?? this.paperSize,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<String>(connectionType.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (paperSize.present) {
      map['paper_size'] = Variable<String>(paperSize.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrintersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('address: $address, ')
          ..write('paperSize: $paperSize, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $POSConfigTableTable pOSConfigTable = $POSConfigTableTable(this);
  late final $UserDataTableTable userDataTable = $UserDataTableTable(this);
  late final $BranchConfigTableTable branchConfigTable =
      $BranchConfigTableTable(this);
  late final $DomainConfigTableTable domainConfigTable =
      $DomainConfigTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $DenominationsTableTable denominationsTable =
      $DenominationsTableTable(this);
  late final $DiscountsTableTable discountsTable = $DiscountsTableTable(this);
  late final $EmployeesTableTable employeesTable = $EmployeesTableTable(this);
  late final $PaymentsTableTable paymentsTable = $PaymentsTableTable(this);
  late final $PosDetailIdTableTable posDetailIdTable = $PosDetailIdTableTable(
    this,
  );
  late final $PosShiftTableTable posShiftTable = $PosShiftTableTable(this);
  late final $ProductPriceTableTable productPriceTable =
      $ProductPriceTableTable(this);
  late final $PromoTableTable promoTable = $PromoTableTable(this);
  late final $PrintersTableTable printersTable = $PrintersTableTable(this);
  late final DomainConfigDao domainConfigDao = DomainConfigDao(
    this as AppDatabase,
  );
  late final BranchConfigDao branchConfigDao = BranchConfigDao(
    this as AppDatabase,
  );
  late final PosConfigDao posConfigDao = PosConfigDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pOSConfigTable,
    userDataTable,
    branchConfigTable,
    domainConfigTable,
    categoriesTable,
    denominationsTable,
    discountsTable,
    employeesTable,
    paymentsTable,
    posDetailIdTable,
    posShiftTable,
    productPriceTable,
    promoTable,
    printersTable,
  ];
}

typedef $$POSConfigTableTableCreateCompanionBuilder =
    POSConfigTableCompanion Function({
      Value<String> id,
      Value<int> posId,
      Value<String> posName,
      Value<String> serial,
      Value<String> min,
      Value<String> ptu,
      Value<String> status,
      Value<String> createdBy,
      Value<DateTime> createdDate,
      Value<int> rowid,
    });
typedef $$POSConfigTableTableUpdateCompanionBuilder =
    POSConfigTableCompanion Function({
      Value<String> id,
      Value<int> posId,
      Value<String> posName,
      Value<String> serial,
      Value<String> min,
      Value<String> ptu,
      Value<String> status,
      Value<String> createdBy,
      Value<DateTime> createdDate,
      Value<int> rowid,
    });

class $$POSConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $POSConfigTableTable> {
  $$POSConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posName => $composableBuilder(
    column: $table.posName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get min => $composableBuilder(
    column: $table.min,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ptu => $composableBuilder(
    column: $table.ptu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$POSConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $POSConfigTableTable> {
  $$POSConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posName => $composableBuilder(
    column: $table.posName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get min => $composableBuilder(
    column: $table.min,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ptu => $composableBuilder(
    column: $table.ptu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$POSConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $POSConfigTableTable> {
  $$POSConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<String> get posName =>
      $composableBuilder(column: $table.posName, builder: (column) => column);

  GeneratedColumn<String> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<String> get min =>
      $composableBuilder(column: $table.min, builder: (column) => column);

  GeneratedColumn<String> get ptu =>
      $composableBuilder(column: $table.ptu, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$POSConfigTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $POSConfigTableTable,
          POSConfigTableData,
          $$POSConfigTableTableFilterComposer,
          $$POSConfigTableTableOrderingComposer,
          $$POSConfigTableTableAnnotationComposer,
          $$POSConfigTableTableCreateCompanionBuilder,
          $$POSConfigTableTableUpdateCompanionBuilder,
          (
            POSConfigTableData,
            BaseReferences<
              _$AppDatabase,
              $POSConfigTableTable,
              POSConfigTableData
            >,
          ),
          POSConfigTableData,
          PrefetchHooks Function()
        > {
  $$POSConfigTableTableTableManager(
    _$AppDatabase db,
    $POSConfigTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$POSConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$POSConfigTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$POSConfigTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> posId = const Value.absent(),
                Value<String> posName = const Value.absent(),
                Value<String> serial = const Value.absent(),
                Value<String> min = const Value.absent(),
                Value<String> ptu = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => POSConfigTableCompanion(
                id: id,
                posId: posId,
                posName: posName,
                serial: serial,
                min: min,
                ptu: ptu,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> posId = const Value.absent(),
                Value<String> posName = const Value.absent(),
                Value<String> serial = const Value.absent(),
                Value<String> min = const Value.absent(),
                Value<String> ptu = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => POSConfigTableCompanion.insert(
                id: id,
                posId: posId,
                posName: posName,
                serial: serial,
                min: min,
                ptu: ptu,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$POSConfigTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $POSConfigTableTable,
      POSConfigTableData,
      $$POSConfigTableTableFilterComposer,
      $$POSConfigTableTableOrderingComposer,
      $$POSConfigTableTableAnnotationComposer,
      $$POSConfigTableTableCreateCompanionBuilder,
      $$POSConfigTableTableUpdateCompanionBuilder,
      (
        POSConfigTableData,
        BaseReferences<_$AppDatabase, $POSConfigTableTable, POSConfigTableData>,
      ),
      POSConfigTableData,
      PrefetchHooks Function()
    >;
typedef $$UserDataTableTableCreateCompanionBuilder =
    UserDataTableCompanion Function({
      Value<String> id,
      Value<String> employeeId,
      Value<String> fullName,
      Value<int> position,
      Value<String> contactInfo,
      Value<String> dateHired,
      Value<int> userCode,
      Value<int> accessType,
      Value<String> status,
      Value<String> apk,
      Value<int> rowid,
    });
typedef $$UserDataTableTableUpdateCompanionBuilder =
    UserDataTableCompanion Function({
      Value<String> id,
      Value<String> employeeId,
      Value<String> fullName,
      Value<int> position,
      Value<String> contactInfo,
      Value<String> dateHired,
      Value<int> userCode,
      Value<int> accessType,
      Value<String> status,
      Value<String> apk,
      Value<int> rowid,
    });

class $$UserDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserDataTableTable> {
  $$UserDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactInfo => $composableBuilder(
    column: $table.contactInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateHired => $composableBuilder(
    column: $table.dateHired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userCode => $composableBuilder(
    column: $table.userCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accessType => $composableBuilder(
    column: $table.accessType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apk => $composableBuilder(
    column: $table.apk,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserDataTableTable> {
  $$UserDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactInfo => $composableBuilder(
    column: $table.contactInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateHired => $composableBuilder(
    column: $table.dateHired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userCode => $composableBuilder(
    column: $table.userCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accessType => $composableBuilder(
    column: $table.accessType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apk => $composableBuilder(
    column: $table.apk,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserDataTableTable> {
  $$UserDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get contactInfo => $composableBuilder(
    column: $table.contactInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateHired =>
      $composableBuilder(column: $table.dateHired, builder: (column) => column);

  GeneratedColumn<int> get userCode =>
      $composableBuilder(column: $table.userCode, builder: (column) => column);

  GeneratedColumn<int> get accessType => $composableBuilder(
    column: $table.accessType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get apk =>
      $composableBuilder(column: $table.apk, builder: (column) => column);
}

class $$UserDataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserDataTableTable,
          UserDataTableData,
          $$UserDataTableTableFilterComposer,
          $$UserDataTableTableOrderingComposer,
          $$UserDataTableTableAnnotationComposer,
          $$UserDataTableTableCreateCompanionBuilder,
          $$UserDataTableTableUpdateCompanionBuilder,
          (
            UserDataTableData,
            BaseReferences<
              _$AppDatabase,
              $UserDataTableTable,
              UserDataTableData
            >,
          ),
          UserDataTableData,
          PrefetchHooks Function()
        > {
  $$UserDataTableTableTableManager(_$AppDatabase db, $UserDataTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserDataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> contactInfo = const Value.absent(),
                Value<String> dateHired = const Value.absent(),
                Value<int> userCode = const Value.absent(),
                Value<int> accessType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> apk = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserDataTableCompanion(
                id: id,
                employeeId: employeeId,
                fullName: fullName,
                position: position,
                contactInfo: contactInfo,
                dateHired: dateHired,
                userCode: userCode,
                accessType: accessType,
                status: status,
                apk: apk,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> contactInfo = const Value.absent(),
                Value<String> dateHired = const Value.absent(),
                Value<int> userCode = const Value.absent(),
                Value<int> accessType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> apk = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserDataTableCompanion.insert(
                id: id,
                employeeId: employeeId,
                fullName: fullName,
                position: position,
                contactInfo: contactInfo,
                dateHired: dateHired,
                userCode: userCode,
                accessType: accessType,
                status: status,
                apk: apk,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserDataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserDataTableTable,
      UserDataTableData,
      $$UserDataTableTableFilterComposer,
      $$UserDataTableTableOrderingComposer,
      $$UserDataTableTableAnnotationComposer,
      $$UserDataTableTableCreateCompanionBuilder,
      $$UserDataTableTableUpdateCompanionBuilder,
      (
        UserDataTableData,
        BaseReferences<_$AppDatabase, $UserDataTableTable, UserDataTableData>,
      ),
      UserDataTableData,
      PrefetchHooks Function()
    >;
typedef $$BranchConfigTableTableCreateCompanionBuilder =
    BranchConfigTableCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> branchName,
      Value<String> tin,
      Value<String> address,
      Value<String> logo,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
      Value<int> rowid,
    });
typedef $$BranchConfigTableTableUpdateCompanionBuilder =
    BranchConfigTableCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> branchName,
      Value<String> tin,
      Value<String> address,
      Value<String> logo,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
      Value<int> rowid,
    });

class $$BranchConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $BranchConfigTableTable> {
  $$BranchConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tin => $composableBuilder(
    column: $table.tin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logo => $composableBuilder(
    column: $table.logo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BranchConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchConfigTableTable> {
  $$BranchConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tin => $composableBuilder(
    column: $table.tin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logo => $composableBuilder(
    column: $table.logo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BranchConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchConfigTableTable> {
  $$BranchConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tin =>
      $composableBuilder(column: $table.tin, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get logo =>
      $composableBuilder(column: $table.logo, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$BranchConfigTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BranchConfigTableTable,
          BranchConfigTableData,
          $$BranchConfigTableTableFilterComposer,
          $$BranchConfigTableTableOrderingComposer,
          $$BranchConfigTableTableAnnotationComposer,
          $$BranchConfigTableTableCreateCompanionBuilder,
          $$BranchConfigTableTableUpdateCompanionBuilder,
          (
            BranchConfigTableData,
            BaseReferences<
              _$AppDatabase,
              $BranchConfigTableTable,
              BranchConfigTableData
            >,
          ),
          BranchConfigTableData,
          PrefetchHooks Function()
        > {
  $$BranchConfigTableTableTableManager(
    _$AppDatabase db,
    $BranchConfigTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchConfigTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchConfigTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> branchName = const Value.absent(),
                Value<String> tin = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> logo = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BranchConfigTableCompanion(
                id: id,
                branchId: branchId,
                branchName: branchName,
                tin: tin,
                address: address,
                logo: logo,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> branchName = const Value.absent(),
                Value<String> tin = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> logo = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BranchConfigTableCompanion.insert(
                id: id,
                branchId: branchId,
                branchName: branchName,
                tin: tin,
                address: address,
                logo: logo,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BranchConfigTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BranchConfigTableTable,
      BranchConfigTableData,
      $$BranchConfigTableTableFilterComposer,
      $$BranchConfigTableTableOrderingComposer,
      $$BranchConfigTableTableAnnotationComposer,
      $$BranchConfigTableTableCreateCompanionBuilder,
      $$BranchConfigTableTableUpdateCompanionBuilder,
      (
        BranchConfigTableData,
        BaseReferences<
          _$AppDatabase,
          $BranchConfigTableTable,
          BranchConfigTableData
        >,
      ),
      BranchConfigTableData,
      PrefetchHooks Function()
    >;
typedef $$DomainConfigTableTableCreateCompanionBuilder =
    DomainConfigTableCompanion Function({
      Value<String> id,
      Value<String> domain,
      Value<int> rowid,
    });
typedef $$DomainConfigTableTableUpdateCompanionBuilder =
    DomainConfigTableCompanion Function({
      Value<String> id,
      Value<String> domain,
      Value<int> rowid,
    });

class $$DomainConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $DomainConfigTableTable> {
  $$DomainConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DomainConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DomainConfigTableTable> {
  $$DomainConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DomainConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DomainConfigTableTable> {
  $$DomainConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);
}

class $$DomainConfigTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DomainConfigTableTable,
          DomainConfigTableData,
          $$DomainConfigTableTableFilterComposer,
          $$DomainConfigTableTableOrderingComposer,
          $$DomainConfigTableTableAnnotationComposer,
          $$DomainConfigTableTableCreateCompanionBuilder,
          $$DomainConfigTableTableUpdateCompanionBuilder,
          (
            DomainConfigTableData,
            BaseReferences<
              _$AppDatabase,
              $DomainConfigTableTable,
              DomainConfigTableData
            >,
          ),
          DomainConfigTableData,
          PrefetchHooks Function()
        > {
  $$DomainConfigTableTableTableManager(
    _$AppDatabase db,
    $DomainConfigTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DomainConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DomainConfigTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DomainConfigTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> domain = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DomainConfigTableCompanion(
                id: id,
                domain: domain,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> domain = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DomainConfigTableCompanion.insert(
                id: id,
                domain: domain,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DomainConfigTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DomainConfigTableTable,
      DomainConfigTableData,
      $$DomainConfigTableTableFilterComposer,
      $$DomainConfigTableTableOrderingComposer,
      $$DomainConfigTableTableAnnotationComposer,
      $$DomainConfigTableTableCreateCompanionBuilder,
      $$DomainConfigTableTableUpdateCompanionBuilder,
      (
        DomainConfigTableData,
        BaseReferences<
          _$AppDatabase,
          $DomainConfigTableTable,
          DomainConfigTableData
        >,
      ),
      DomainConfigTableData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> categoryCode,
      Value<String> categoryName,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
      Value<int> isDisplay,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> categoryCode,
      Value<String> categoryName,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
      Value<int> isDisplay,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDisplay => $composableBuilder(
    column: $table.isDisplay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDisplay => $composableBuilder(
    column: $table.isDisplay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDisplay =>
      $composableBuilder(column: $table.isDisplay, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $CategoriesTableTable,
              CategoriesTableData
            >,
          ),
          CategoriesTableData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> categoryCode = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
                Value<int> isDisplay = const Value.absent(),
              }) => CategoriesTableCompanion(
                categoryCode: categoryCode,
                categoryName: categoryName,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
                isDisplay: isDisplay,
              ),
          createCompanionCallback:
              ({
                Value<int> categoryCode = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
                Value<int> isDisplay = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                categoryCode: categoryCode,
                categoryName: categoryName,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
                isDisplay: isDisplay,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        >,
      ),
      CategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$DenominationsTableTableCreateCompanionBuilder =
    DenominationsTableCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> description,
      Value<int> value,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });
typedef $$DenominationsTableTableUpdateCompanionBuilder =
    DenominationsTableCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> description,
      Value<int> value,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });

class $$DenominationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DenominationsTableTable> {
  $$DenominationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DenominationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DenominationsTableTable> {
  $$DenominationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DenominationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DenominationsTableTable> {
  $$DenominationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$DenominationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DenominationsTableTable,
          DenominationsTableData,
          $$DenominationsTableTableFilterComposer,
          $$DenominationsTableTableOrderingComposer,
          $$DenominationsTableTableAnnotationComposer,
          $$DenominationsTableTableCreateCompanionBuilder,
          $$DenominationsTableTableUpdateCompanionBuilder,
          (
            DenominationsTableData,
            BaseReferences<
              _$AppDatabase,
              $DenominationsTableTable,
              DenominationsTableData
            >,
          ),
          DenominationsTableData,
          PrefetchHooks Function()
        > {
  $$DenominationsTableTableTableManager(
    _$AppDatabase db,
    $DenominationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DenominationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DenominationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DenominationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => DenominationsTableCompanion(
                id: id,
                code: code,
                description: description,
                value: value,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => DenominationsTableCompanion.insert(
                id: id,
                code: code,
                description: description,
                value: value,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DenominationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DenominationsTableTable,
      DenominationsTableData,
      $$DenominationsTableTableFilterComposer,
      $$DenominationsTableTableOrderingComposer,
      $$DenominationsTableTableAnnotationComposer,
      $$DenominationsTableTableCreateCompanionBuilder,
      $$DenominationsTableTableUpdateCompanionBuilder,
      (
        DenominationsTableData,
        BaseReferences<
          _$AppDatabase,
          $DenominationsTableTable,
          DenominationsTableData
        >,
      ),
      DenominationsTableData,
      PrefetchHooks Function()
    >;
typedef $$DiscountsTableTableCreateCompanionBuilder =
    DiscountsTableCompanion Function({
      Value<int> discountId,
      Value<String> name,
      Value<String> description,
      Value<int> rate,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });
typedef $$DiscountsTableTableUpdateCompanionBuilder =
    DiscountsTableCompanion Function({
      Value<int> discountId,
      Value<String> name,
      Value<String> description,
      Value<int> rate,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });

class $$DiscountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get discountId => $composableBuilder(
    column: $table.discountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiscountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get discountId => $composableBuilder(
    column: $table.discountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiscountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get discountId => $composableBuilder(
    column: $table.discountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$DiscountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiscountsTableTable,
          DiscountsTableData,
          $$DiscountsTableTableFilterComposer,
          $$DiscountsTableTableOrderingComposer,
          $$DiscountsTableTableAnnotationComposer,
          $$DiscountsTableTableCreateCompanionBuilder,
          $$DiscountsTableTableUpdateCompanionBuilder,
          (
            DiscountsTableData,
            BaseReferences<
              _$AppDatabase,
              $DiscountsTableTable,
              DiscountsTableData
            >,
          ),
          DiscountsTableData,
          PrefetchHooks Function()
        > {
  $$DiscountsTableTableTableManager(
    _$AppDatabase db,
    $DiscountsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> discountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => DiscountsTableCompanion(
                discountId: discountId,
                name: name,
                description: description,
                rate: rate,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> discountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => DiscountsTableCompanion.insert(
                discountId: discountId,
                name: name,
                description: description,
                rate: rate,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiscountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiscountsTableTable,
      DiscountsTableData,
      $$DiscountsTableTableFilterComposer,
      $$DiscountsTableTableOrderingComposer,
      $$DiscountsTableTableAnnotationComposer,
      $$DiscountsTableTableCreateCompanionBuilder,
      $$DiscountsTableTableUpdateCompanionBuilder,
      (
        DiscountsTableData,
        BaseReferences<_$AppDatabase, $DiscountsTableTable, DiscountsTableData>,
      ),
      DiscountsTableData,
      PrefetchHooks Function()
    >;
typedef $$EmployeesTableTableCreateCompanionBuilder =
    EmployeesTableCompanion Function({
      Value<int> employeeId,
      Value<String> fullName,
      Value<int> position,
      Value<String> contactInfo,
      Value<String> dateHired,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });
typedef $$EmployeesTableTableUpdateCompanionBuilder =
    EmployeesTableCompanion Function({
      Value<int> employeeId,
      Value<String> fullName,
      Value<int> position,
      Value<String> contactInfo,
      Value<String> dateHired,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });

class $$EmployeesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTableTable> {
  $$EmployeesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactInfo => $composableBuilder(
    column: $table.contactInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateHired => $composableBuilder(
    column: $table.dateHired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTableTable> {
  $$EmployeesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactInfo => $composableBuilder(
    column: $table.contactInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateHired => $composableBuilder(
    column: $table.dateHired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTableTable> {
  $$EmployeesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get contactInfo => $composableBuilder(
    column: $table.contactInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateHired =>
      $composableBuilder(column: $table.dateHired, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$EmployeesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTableTable,
          EmployeesTableData,
          $$EmployeesTableTableFilterComposer,
          $$EmployeesTableTableOrderingComposer,
          $$EmployeesTableTableAnnotationComposer,
          $$EmployeesTableTableCreateCompanionBuilder,
          $$EmployeesTableTableUpdateCompanionBuilder,
          (
            EmployeesTableData,
            BaseReferences<
              _$AppDatabase,
              $EmployeesTableTable,
              EmployeesTableData
            >,
          ),
          EmployeesTableData,
          PrefetchHooks Function()
        > {
  $$EmployeesTableTableTableManager(
    _$AppDatabase db,
    $EmployeesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> employeeId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> contactInfo = const Value.absent(),
                Value<String> dateHired = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => EmployeesTableCompanion(
                employeeId: employeeId,
                fullName: fullName,
                position: position,
                contactInfo: contactInfo,
                dateHired: dateHired,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> employeeId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> contactInfo = const Value.absent(),
                Value<String> dateHired = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => EmployeesTableCompanion.insert(
                employeeId: employeeId,
                fullName: fullName,
                position: position,
                contactInfo: contactInfo,
                dateHired: dateHired,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTableTable,
      EmployeesTableData,
      $$EmployeesTableTableFilterComposer,
      $$EmployeesTableTableOrderingComposer,
      $$EmployeesTableTableAnnotationComposer,
      $$EmployeesTableTableCreateCompanionBuilder,
      $$EmployeesTableTableUpdateCompanionBuilder,
      (
        EmployeesTableData,
        BaseReferences<_$AppDatabase, $EmployeesTableTable, EmployeesTableData>,
      ),
      EmployeesTableData,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableTableCreateCompanionBuilder =
    PaymentsTableCompanion Function({
      Value<int> paymentId,
      Value<String> paymentName,
      Value<String> status,
      Value<String> createdby,
      Value<String> createddate,
    });
typedef $$PaymentsTableTableUpdateCompanionBuilder =
    PaymentsTableCompanion Function({
      Value<int> paymentId,
      Value<String> paymentName,
      Value<String> status,
      Value<String> createdby,
      Value<String> createddate,
    });

class $$PaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdby => $composableBuilder(
    column: $table.createdby,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createddate => $composableBuilder(
    column: $table.createddate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdby => $composableBuilder(
    column: $table.createdby,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createddate => $composableBuilder(
    column: $table.createddate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get paymentId =>
      $composableBuilder(column: $table.paymentId, builder: (column) => column);

  GeneratedColumn<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdby =>
      $composableBuilder(column: $table.createdby, builder: (column) => column);

  GeneratedColumn<String> get createddate => $composableBuilder(
    column: $table.createddate,
    builder: (column) => column,
  );
}

class $$PaymentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTableTable,
          PaymentsTableData,
          $$PaymentsTableTableFilterComposer,
          $$PaymentsTableTableOrderingComposer,
          $$PaymentsTableTableAnnotationComposer,
          $$PaymentsTableTableCreateCompanionBuilder,
          $$PaymentsTableTableUpdateCompanionBuilder,
          (
            PaymentsTableData,
            BaseReferences<
              _$AppDatabase,
              $PaymentsTableTable,
              PaymentsTableData
            >,
          ),
          PaymentsTableData,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableTableManager(_$AppDatabase db, $PaymentsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> paymentId = const Value.absent(),
                Value<String> paymentName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdby = const Value.absent(),
                Value<String> createddate = const Value.absent(),
              }) => PaymentsTableCompanion(
                paymentId: paymentId,
                paymentName: paymentName,
                status: status,
                createdby: createdby,
                createddate: createddate,
              ),
          createCompanionCallback:
              ({
                Value<int> paymentId = const Value.absent(),
                Value<String> paymentName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdby = const Value.absent(),
                Value<String> createddate = const Value.absent(),
              }) => PaymentsTableCompanion.insert(
                paymentId: paymentId,
                paymentName: paymentName,
                status: status,
                createdby: createdby,
                createddate: createddate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTableTable,
      PaymentsTableData,
      $$PaymentsTableTableFilterComposer,
      $$PaymentsTableTableOrderingComposer,
      $$PaymentsTableTableAnnotationComposer,
      $$PaymentsTableTableCreateCompanionBuilder,
      $$PaymentsTableTableUpdateCompanionBuilder,
      (
        PaymentsTableData,
        BaseReferences<_$AppDatabase, $PaymentsTableTable, PaymentsTableData>,
      ),
      PaymentsTableData,
      PrefetchHooks Function()
    >;
typedef $$PosDetailIdTableTableCreateCompanionBuilder =
    PosDetailIdTableCompanion Function({
      Value<String> id,
      Value<String> posDetailId,
      Value<int> rowid,
    });
typedef $$PosDetailIdTableTableUpdateCompanionBuilder =
    PosDetailIdTableCompanion Function({
      Value<String> id,
      Value<String> posDetailId,
      Value<int> rowid,
    });

class $$PosDetailIdTableTableFilterComposer
    extends Composer<_$AppDatabase, $PosDetailIdTableTable> {
  $$PosDetailIdTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posDetailId => $composableBuilder(
    column: $table.posDetailId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PosDetailIdTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PosDetailIdTableTable> {
  $$PosDetailIdTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posDetailId => $composableBuilder(
    column: $table.posDetailId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PosDetailIdTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PosDetailIdTableTable> {
  $$PosDetailIdTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get posDetailId => $composableBuilder(
    column: $table.posDetailId,
    builder: (column) => column,
  );
}

class $$PosDetailIdTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PosDetailIdTableTable,
          PosDetailIdTableData,
          $$PosDetailIdTableTableFilterComposer,
          $$PosDetailIdTableTableOrderingComposer,
          $$PosDetailIdTableTableAnnotationComposer,
          $$PosDetailIdTableTableCreateCompanionBuilder,
          $$PosDetailIdTableTableUpdateCompanionBuilder,
          (
            PosDetailIdTableData,
            BaseReferences<
              _$AppDatabase,
              $PosDetailIdTableTable,
              PosDetailIdTableData
            >,
          ),
          PosDetailIdTableData,
          PrefetchHooks Function()
        > {
  $$PosDetailIdTableTableTableManager(
    _$AppDatabase db,
    $PosDetailIdTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PosDetailIdTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PosDetailIdTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PosDetailIdTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> posDetailId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PosDetailIdTableCompanion(
                id: id,
                posDetailId: posDetailId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> posDetailId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PosDetailIdTableCompanion.insert(
                id: id,
                posDetailId: posDetailId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PosDetailIdTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PosDetailIdTableTable,
      PosDetailIdTableData,
      $$PosDetailIdTableTableFilterComposer,
      $$PosDetailIdTableTableOrderingComposer,
      $$PosDetailIdTableTableAnnotationComposer,
      $$PosDetailIdTableTableCreateCompanionBuilder,
      $$PosDetailIdTableTableUpdateCompanionBuilder,
      (
        PosDetailIdTableData,
        BaseReferences<
          _$AppDatabase,
          $PosDetailIdTableTable,
          PosDetailIdTableData
        >,
      ),
      PosDetailIdTableData,
      PrefetchHooks Function()
    >;
typedef $$PosShiftTableTableCreateCompanionBuilder =
    PosShiftTableCompanion Function({
      Value<String> posId,
      Value<String> date,
      Value<String> shift,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$PosShiftTableTableUpdateCompanionBuilder =
    PosShiftTableCompanion Function({
      Value<String> posId,
      Value<String> date,
      Value<String> shift,
      Value<String> status,
      Value<int> rowid,
    });

class $$PosShiftTableTableFilterComposer
    extends Composer<_$AppDatabase, $PosShiftTableTable> {
  $$PosShiftTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PosShiftTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PosShiftTableTable> {
  $$PosShiftTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PosShiftTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PosShiftTableTable> {
  $$PosShiftTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PosShiftTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PosShiftTableTable,
          PosShiftTableData,
          $$PosShiftTableTableFilterComposer,
          $$PosShiftTableTableOrderingComposer,
          $$PosShiftTableTableAnnotationComposer,
          $$PosShiftTableTableCreateCompanionBuilder,
          $$PosShiftTableTableUpdateCompanionBuilder,
          (
            PosShiftTableData,
            BaseReferences<
              _$AppDatabase,
              $PosShiftTableTable,
              PosShiftTableData
            >,
          ),
          PosShiftTableData,
          PrefetchHooks Function()
        > {
  $$PosShiftTableTableTableManager(_$AppDatabase db, $PosShiftTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PosShiftTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PosShiftTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PosShiftTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> posId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PosShiftTableCompanion(
                posId: posId,
                date: date,
                shift: shift,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> posId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PosShiftTableCompanion.insert(
                posId: posId,
                date: date,
                shift: shift,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PosShiftTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PosShiftTableTable,
      PosShiftTableData,
      $$PosShiftTableTableFilterComposer,
      $$PosShiftTableTableOrderingComposer,
      $$PosShiftTableTableAnnotationComposer,
      $$PosShiftTableTableCreateCompanionBuilder,
      $$PosShiftTableTableUpdateCompanionBuilder,
      (
        PosShiftTableData,
        BaseReferences<_$AppDatabase, $PosShiftTableTable, PosShiftTableData>,
      ),
      PosShiftTableData,
      PrefetchHooks Function()
    >;
typedef $$ProductPriceTableTableCreateCompanionBuilder =
    ProductPriceTableCompanion Function({
      Value<int> productId,
      Value<String> description,
      Value<String> barcode,
      Value<String> price,
      Value<int> category,
      Value<int> quantity,
    });
typedef $$ProductPriceTableTableUpdateCompanionBuilder =
    ProductPriceTableCompanion Function({
      Value<int> productId,
      Value<String> description,
      Value<String> barcode,
      Value<String> price,
      Value<int> category,
      Value<int> quantity,
    });

class $$ProductPriceTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductPriceTableTable> {
  $$ProductPriceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductPriceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductPriceTableTable> {
  $$ProductPriceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductPriceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductPriceTableTable> {
  $$ProductPriceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$ProductPriceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductPriceTableTable,
          ProductPriceTableData,
          $$ProductPriceTableTableFilterComposer,
          $$ProductPriceTableTableOrderingComposer,
          $$ProductPriceTableTableAnnotationComposer,
          $$ProductPriceTableTableCreateCompanionBuilder,
          $$ProductPriceTableTableUpdateCompanionBuilder,
          (
            ProductPriceTableData,
            BaseReferences<
              _$AppDatabase,
              $ProductPriceTableTable,
              ProductPriceTableData
            >,
          ),
          ProductPriceTableData,
          PrefetchHooks Function()
        > {
  $$ProductPriceTableTableTableManager(
    _$AppDatabase db,
    $ProductPriceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductPriceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductPriceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductPriceTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> price = const Value.absent(),
                Value<int> category = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => ProductPriceTableCompanion(
                productId: productId,
                description: description,
                barcode: barcode,
                price: price,
                category: category,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> price = const Value.absent(),
                Value<int> category = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => ProductPriceTableCompanion.insert(
                productId: productId,
                description: description,
                barcode: barcode,
                price: price,
                category: category,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductPriceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductPriceTableTable,
      ProductPriceTableData,
      $$ProductPriceTableTableFilterComposer,
      $$ProductPriceTableTableOrderingComposer,
      $$ProductPriceTableTableAnnotationComposer,
      $$ProductPriceTableTableCreateCompanionBuilder,
      $$ProductPriceTableTableUpdateCompanionBuilder,
      (
        ProductPriceTableData,
        BaseReferences<
          _$AppDatabase,
          $ProductPriceTableTable,
          ProductPriceTableData
        >,
      ),
      ProductPriceTableData,
      PrefetchHooks Function()
    >;
typedef $$PromoTableTableCreateCompanionBuilder =
    PromoTableCompanion Function({
      Value<int> promoId,
      Value<String> name,
      Value<String> description,
      Value<String> condition,
      Value<String> startDate,
      Value<String> endDate,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });
typedef $$PromoTableTableUpdateCompanionBuilder =
    PromoTableCompanion Function({
      Value<int> promoId,
      Value<String> name,
      Value<String> description,
      Value<String> condition,
      Value<String> startDate,
      Value<String> endDate,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });

class $$PromoTableTableFilterComposer
    extends Composer<_$AppDatabase, $PromoTableTable> {
  $$PromoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get promoId => $composableBuilder(
    column: $table.promoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PromoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PromoTableTable> {
  $$PromoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get promoId => $composableBuilder(
    column: $table.promoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromoTableTable> {
  $$PromoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get promoId =>
      $composableBuilder(column: $table.promoId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$PromoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromoTableTable,
          PromoTableData,
          $$PromoTableTableFilterComposer,
          $$PromoTableTableOrderingComposer,
          $$PromoTableTableAnnotationComposer,
          $$PromoTableTableCreateCompanionBuilder,
          $$PromoTableTableUpdateCompanionBuilder,
          (
            PromoTableData,
            BaseReferences<_$AppDatabase, $PromoTableTable, PromoTableData>,
          ),
          PromoTableData,
          PrefetchHooks Function()
        > {
  $$PromoTableTableTableManager(_$AppDatabase db, $PromoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> promoId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => PromoTableCompanion(
                promoId: promoId,
                name: name,
                description: description,
                condition: condition,
                startDate: startDate,
                endDate: endDate,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> promoId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => PromoTableCompanion.insert(
                promoId: promoId,
                name: name,
                description: description,
                condition: condition,
                startDate: startDate,
                endDate: endDate,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PromoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromoTableTable,
      PromoTableData,
      $$PromoTableTableFilterComposer,
      $$PromoTableTableOrderingComposer,
      $$PromoTableTableAnnotationComposer,
      $$PromoTableTableCreateCompanionBuilder,
      $$PromoTableTableUpdateCompanionBuilder,
      (
        PromoTableData,
        BaseReferences<_$AppDatabase, $PromoTableTable, PromoTableData>,
      ),
      PromoTableData,
      PrefetchHooks Function()
    >;
typedef $$PrintersTableTableCreateCompanionBuilder =
    PrintersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> connectionType,
      Value<String> address,
      Value<String> paperSize,
      Value<int> rowid,
    });
typedef $$PrintersTableTableUpdateCompanionBuilder =
    PrintersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> connectionType,
      Value<String> address,
      Value<String> paperSize,
      Value<int> rowid,
    });

class $$PrintersTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrintersTableTable> {
  $$PrintersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paperSize => $composableBuilder(
    column: $table.paperSize,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrintersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrintersTableTable> {
  $$PrintersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paperSize => $composableBuilder(
    column: $table.paperSize,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrintersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrintersTableTable> {
  $$PrintersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get paperSize =>
      $composableBuilder(column: $table.paperSize, builder: (column) => column);
}

class $$PrintersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrintersTableTable,
          PrintersTableData,
          $$PrintersTableTableFilterComposer,
          $$PrintersTableTableOrderingComposer,
          $$PrintersTableTableAnnotationComposer,
          $$PrintersTableTableCreateCompanionBuilder,
          $$PrintersTableTableUpdateCompanionBuilder,
          (
            PrintersTableData,
            BaseReferences<
              _$AppDatabase,
              $PrintersTableTable,
              PrintersTableData
            >,
          ),
          PrintersTableData,
          PrefetchHooks Function()
        > {
  $$PrintersTableTableTableManager(_$AppDatabase db, $PrintersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrintersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrintersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrintersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> connectionType = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> paperSize = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrintersTableCompanion(
                id: id,
                name: name,
                connectionType: connectionType,
                address: address,
                paperSize: paperSize,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> connectionType = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> paperSize = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrintersTableCompanion.insert(
                id: id,
                name: name,
                connectionType: connectionType,
                address: address,
                paperSize: paperSize,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrintersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrintersTableTable,
      PrintersTableData,
      $$PrintersTableTableFilterComposer,
      $$PrintersTableTableOrderingComposer,
      $$PrintersTableTableAnnotationComposer,
      $$PrintersTableTableCreateCompanionBuilder,
      $$PrintersTableTableUpdateCompanionBuilder,
      (
        PrintersTableData,
        BaseReferences<_$AppDatabase, $PrintersTableTable, PrintersTableData>,
      ),
      PrintersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$POSConfigTableTableTableManager get pOSConfigTable =>
      $$POSConfigTableTableTableManager(_db, _db.pOSConfigTable);
  $$UserDataTableTableTableManager get userDataTable =>
      $$UserDataTableTableTableManager(_db, _db.userDataTable);
  $$BranchConfigTableTableTableManager get branchConfigTable =>
      $$BranchConfigTableTableTableManager(_db, _db.branchConfigTable);
  $$DomainConfigTableTableTableManager get domainConfigTable =>
      $$DomainConfigTableTableTableManager(_db, _db.domainConfigTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$DenominationsTableTableTableManager get denominationsTable =>
      $$DenominationsTableTableTableManager(_db, _db.denominationsTable);
  $$DiscountsTableTableTableManager get discountsTable =>
      $$DiscountsTableTableTableManager(_db, _db.discountsTable);
  $$EmployeesTableTableTableManager get employeesTable =>
      $$EmployeesTableTableTableManager(_db, _db.employeesTable);
  $$PaymentsTableTableTableManager get paymentsTable =>
      $$PaymentsTableTableTableManager(_db, _db.paymentsTable);
  $$PosDetailIdTableTableTableManager get posDetailIdTable =>
      $$PosDetailIdTableTableTableManager(_db, _db.posDetailIdTable);
  $$PosShiftTableTableTableManager get posShiftTable =>
      $$PosShiftTableTableTableManager(_db, _db.posShiftTable);
  $$ProductPriceTableTableTableManager get productPriceTable =>
      $$ProductPriceTableTableTableManager(_db, _db.productPriceTable);
  $$PromoTableTableTableManager get promoTable =>
      $$PromoTableTableTableManager(_db, _db.promoTable);
  $$PrintersTableTableTableManager get printersTable =>
      $$PrintersTableTableTableManager(_db, _db.printersTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider to make the database accessible throughout the app.
/// [keepAlive] is true because we want one database instance to live as long as the app.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Riverpod provider to make the database accessible throughout the app.
/// [keepAlive] is true because we want one database instance to live as long as the app.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Riverpod provider to make the database accessible throughout the app.
  /// [keepAlive] is true because we want one database instance to live as long as the app.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'448adad5717e7b1c0b3ca3ca7e03d0b2116237af';
