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
    defaultValue: const Constant('INVALID USER'),
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $POSConfigTableTable pOSConfigTable = $POSConfigTableTable(this);
  late final $UserDataTableTable userDataTable = $UserDataTableTable(this);
  late final $BranchConfigTableTable branchConfigTable =
      $BranchConfigTableTable(this);
  late final $DomainConfigTableTable domainConfigTable =
      $DomainConfigTableTable(this);
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
