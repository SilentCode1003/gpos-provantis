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
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hasCashDrawerMeta = const VerificationMeta(
    'hasCashDrawer',
  );
  @override
  late final GeneratedColumn<bool> hasCashDrawer = GeneratedColumn<bool>(
    'has_cash_drawer',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_cash_drawer" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    connectionType,
    address,
    paperSize,
    isEnabled,
    hasCashDrawer,
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
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('has_cash_drawer')) {
      context.handle(
        _hasCashDrawerMeta,
        hasCashDrawer.isAcceptableOrUnknown(
          data['has_cash_drawer']!,
          _hasCashDrawerMeta,
        ),
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
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      hasCashDrawer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_cash_drawer'],
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

  /// Lets the user switch a printer off without deleting it.
  final bool isEnabled;

  /// True when a cash drawer is plugged into this printer.
  final bool hasCashDrawer;
  const PrintersTableData({
    required this.id,
    required this.name,
    required this.connectionType,
    required this.address,
    required this.paperSize,
    required this.isEnabled,
    required this.hasCashDrawer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['connection_type'] = Variable<String>(connectionType);
    map['address'] = Variable<String>(address);
    map['paper_size'] = Variable<String>(paperSize);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['has_cash_drawer'] = Variable<bool>(hasCashDrawer);
    return map;
  }

  PrintersTableCompanion toCompanion(bool nullToAbsent) {
    return PrintersTableCompanion(
      id: Value(id),
      name: Value(name),
      connectionType: Value(connectionType),
      address: Value(address),
      paperSize: Value(paperSize),
      isEnabled: Value(isEnabled),
      hasCashDrawer: Value(hasCashDrawer),
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
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      hasCashDrawer: serializer.fromJson<bool>(json['hasCashDrawer']),
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
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'hasCashDrawer': serializer.toJson<bool>(hasCashDrawer),
    };
  }

  PrintersTableData copyWith({
    String? id,
    String? name,
    String? connectionType,
    String? address,
    String? paperSize,
    bool? isEnabled,
    bool? hasCashDrawer,
  }) => PrintersTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    connectionType: connectionType ?? this.connectionType,
    address: address ?? this.address,
    paperSize: paperSize ?? this.paperSize,
    isEnabled: isEnabled ?? this.isEnabled,
    hasCashDrawer: hasCashDrawer ?? this.hasCashDrawer,
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
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      hasCashDrawer: data.hasCashDrawer.present
          ? data.hasCashDrawer.value
          : this.hasCashDrawer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrintersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('connectionType: $connectionType, ')
          ..write('address: $address, ')
          ..write('paperSize: $paperSize, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('hasCashDrawer: $hasCashDrawer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    connectionType,
    address,
    paperSize,
    isEnabled,
    hasCashDrawer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrintersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.connectionType == this.connectionType &&
          other.address == this.address &&
          other.paperSize == this.paperSize &&
          other.isEnabled == this.isEnabled &&
          other.hasCashDrawer == this.hasCashDrawer);
}

class PrintersTableCompanion extends UpdateCompanion<PrintersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> connectionType;
  final Value<String> address;
  final Value<String> paperSize;
  final Value<bool> isEnabled;
  final Value<bool> hasCashDrawer;
  final Value<int> rowid;
  const PrintersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.address = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.hasCashDrawer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrintersTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.address = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.hasCashDrawer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PrintersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? connectionType,
    Expression<String>? address,
    Expression<String>? paperSize,
    Expression<bool>? isEnabled,
    Expression<bool>? hasCashDrawer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (connectionType != null) 'connection_type': connectionType,
      if (address != null) 'address': address,
      if (paperSize != null) 'paper_size': paperSize,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (hasCashDrawer != null) 'has_cash_drawer': hasCashDrawer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrintersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? connectionType,
    Value<String>? address,
    Value<String>? paperSize,
    Value<bool>? isEnabled,
    Value<bool>? hasCashDrawer,
    Value<int>? rowid,
  }) {
    return PrintersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      connectionType: connectionType ?? this.connectionType,
      address: address ?? this.address,
      paperSize: paperSize ?? this.paperSize,
      isEnabled: isEnabled ?? this.isEnabled,
      hasCashDrawer: hasCashDrawer ?? this.hasCashDrawer,
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
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (hasCashDrawer.present) {
      map['has_cash_drawer'] = Variable<bool>(hasCashDrawer.value);
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
          ..write('isEnabled: $isEnabled, ')
          ..write('hasCashDrawer: $hasCashDrawer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('settings_config'),
  );
  static const VerificationMeta _mainPrinterMeta = const VerificationMeta(
    'mainPrinter',
  );
  @override
  late final GeneratedColumn<String> mainPrinter = GeneratedColumn<String>(
    'main_printer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _subPrinterMeta = const VerificationMeta(
    'subPrinter',
  );
  @override
  late final GeneratedColumn<String> subPrinter = GeneratedColumn<String>(
    'sub_printer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _showVatOnReceiptMeta = const VerificationMeta(
    'showVatOnReceipt',
  );
  @override
  late final GeneratedColumn<bool> showVatOnReceipt = GeneratedColumn<bool>(
    'show_vat_on_receipt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_vat_on_receipt" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showOfficialReceiptMessageAtTheBottomMeta =
      const VerificationMeta('showOfficialReceiptMessageAtTheBottom');
  @override
  late final GeneratedColumn<bool> showOfficialReceiptMessageAtTheBottom =
      GeneratedColumn<bool>(
        'show_official_receipt_message_at_the_bottom',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_official_receipt_message_at_the_bottom" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _birAccreditedMeta = const VerificationMeta(
    'birAccredited',
  );
  @override
  late final GeneratedColumn<bool> birAccredited = GeneratedColumn<bool>(
    'bir_accredited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bir_accredited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showReceiptPreviewMeta =
      const VerificationMeta('showReceiptPreview');
  @override
  late final GeneratedColumn<bool> showReceiptPreview = GeneratedColumn<bool>(
    'show_receipt_preview',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_receipt_preview" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addCustomerToTransactionMeta =
      const VerificationMeta('addCustomerToTransaction');
  @override
  late final GeneratedColumn<bool> addCustomerToTransaction =
      GeneratedColumn<bool>(
        'add_customer_to_transaction',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("add_customer_to_transaction" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _addPurchaseOrderToTransactionMeta =
      const VerificationMeta('addPurchaseOrderToTransaction');
  @override
  late final GeneratedColumn<bool> addPurchaseOrderToTransaction =
      GeneratedColumn<bool>(
        'add_purchase_order_to_transaction',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("add_purchase_order_to_transaction" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _counterDisplayMeta = const VerificationMeta(
    'counterDisplay',
  );
  @override
  late final GeneratedColumn<String> counterDisplay = GeneratedColumn<String>(
    'counter_display',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
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
  static const VerificationMeta _accreditationNoMeta = const VerificationMeta(
    'accreditationNo',
  );
  @override
  late final GeneratedColumn<String> accreditationNo = GeneratedColumn<String>(
    'accreditation_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<String> validUntil = GeneratedColumn<String>(
    'valid_until',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _vatRegMeta = const VerificationMeta('vatReg');
  @override
  late final GeneratedColumn<String> vatReg = GeneratedColumn<String>(
    'vat_reg',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _permitToUseMeta = const VerificationMeta(
    'permitToUse',
  );
  @override
  late final GeneratedColumn<String> permitToUse = GeneratedColumn<String>(
    'permit_to_use',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _machineIdentificationNumberMeta =
      const VerificationMeta('machineIdentificationNumber');
  @override
  late final GeneratedColumn<String> machineIdentificationNumber =
      GeneratedColumn<String>(
        'machine_identification_number',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('UNREGISTERED'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mainPrinter,
    subPrinter,
    showVatOnReceipt,
    showOfficialReceiptMessageAtTheBottom,
    birAccredited,
    showReceiptPreview,
    addCustomerToTransaction,
    addPurchaseOrderToTransaction,
    counterDisplay,
    companyName,
    address,
    accreditationNo,
    validUntil,
    vatReg,
    permitToUse,
    machineIdentificationNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('main_printer')) {
      context.handle(
        _mainPrinterMeta,
        mainPrinter.isAcceptableOrUnknown(
          data['main_printer']!,
          _mainPrinterMeta,
        ),
      );
    }
    if (data.containsKey('sub_printer')) {
      context.handle(
        _subPrinterMeta,
        subPrinter.isAcceptableOrUnknown(data['sub_printer']!, _subPrinterMeta),
      );
    }
    if (data.containsKey('show_vat_on_receipt')) {
      context.handle(
        _showVatOnReceiptMeta,
        showVatOnReceipt.isAcceptableOrUnknown(
          data['show_vat_on_receipt']!,
          _showVatOnReceiptMeta,
        ),
      );
    }
    if (data.containsKey('show_official_receipt_message_at_the_bottom')) {
      context.handle(
        _showOfficialReceiptMessageAtTheBottomMeta,
        showOfficialReceiptMessageAtTheBottom.isAcceptableOrUnknown(
          data['show_official_receipt_message_at_the_bottom']!,
          _showOfficialReceiptMessageAtTheBottomMeta,
        ),
      );
    }
    if (data.containsKey('bir_accredited')) {
      context.handle(
        _birAccreditedMeta,
        birAccredited.isAcceptableOrUnknown(
          data['bir_accredited']!,
          _birAccreditedMeta,
        ),
      );
    }
    if (data.containsKey('show_receipt_preview')) {
      context.handle(
        _showReceiptPreviewMeta,
        showReceiptPreview.isAcceptableOrUnknown(
          data['show_receipt_preview']!,
          _showReceiptPreviewMeta,
        ),
      );
    }
    if (data.containsKey('add_customer_to_transaction')) {
      context.handle(
        _addCustomerToTransactionMeta,
        addCustomerToTransaction.isAcceptableOrUnknown(
          data['add_customer_to_transaction']!,
          _addCustomerToTransactionMeta,
        ),
      );
    }
    if (data.containsKey('add_purchase_order_to_transaction')) {
      context.handle(
        _addPurchaseOrderToTransactionMeta,
        addPurchaseOrderToTransaction.isAcceptableOrUnknown(
          data['add_purchase_order_to_transaction']!,
          _addPurchaseOrderToTransactionMeta,
        ),
      );
    }
    if (data.containsKey('counter_display')) {
      context.handle(
        _counterDisplayMeta,
        counterDisplay.isAcceptableOrUnknown(
          data['counter_display']!,
          _counterDisplayMeta,
        ),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('accreditation_no')) {
      context.handle(
        _accreditationNoMeta,
        accreditationNo.isAcceptableOrUnknown(
          data['accreditation_no']!,
          _accreditationNoMeta,
        ),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('vat_reg')) {
      context.handle(
        _vatRegMeta,
        vatReg.isAcceptableOrUnknown(data['vat_reg']!, _vatRegMeta),
      );
    }
    if (data.containsKey('permit_to_use')) {
      context.handle(
        _permitToUseMeta,
        permitToUse.isAcceptableOrUnknown(
          data['permit_to_use']!,
          _permitToUseMeta,
        ),
      );
    }
    if (data.containsKey('machine_identification_number')) {
      context.handle(
        _machineIdentificationNumberMeta,
        machineIdentificationNumber.isAcceptableOrUnknown(
          data['machine_identification_number']!,
          _machineIdentificationNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mainPrinter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}main_printer'],
      )!,
      subPrinter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_printer'],
      )!,
      showVatOnReceipt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_vat_on_receipt'],
      )!,
      showOfficialReceiptMessageAtTheBottom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_official_receipt_message_at_the_bottom'],
      )!,
      birAccredited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bir_accredited'],
      )!,
      showReceiptPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_receipt_preview'],
      )!,
      addCustomerToTransaction: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}add_customer_to_transaction'],
      )!,
      addPurchaseOrderToTransaction: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}add_purchase_order_to_transaction'],
      )!,
      counterDisplay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counter_display'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      accreditationNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accreditation_no'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_until'],
      )!,
      vatReg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_reg'],
      )!,
      permitToUse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permit_to_use'],
      )!,
      machineIdentificationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_identification_number'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
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
  const SettingsTableData({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['main_printer'] = Variable<String>(mainPrinter);
    map['sub_printer'] = Variable<String>(subPrinter);
    map['show_vat_on_receipt'] = Variable<bool>(showVatOnReceipt);
    map['show_official_receipt_message_at_the_bottom'] = Variable<bool>(
      showOfficialReceiptMessageAtTheBottom,
    );
    map['bir_accredited'] = Variable<bool>(birAccredited);
    map['show_receipt_preview'] = Variable<bool>(showReceiptPreview);
    map['add_customer_to_transaction'] = Variable<bool>(
      addCustomerToTransaction,
    );
    map['add_purchase_order_to_transaction'] = Variable<bool>(
      addPurchaseOrderToTransaction,
    );
    map['counter_display'] = Variable<String>(counterDisplay);
    map['company_name'] = Variable<String>(companyName);
    map['address'] = Variable<String>(address);
    map['accreditation_no'] = Variable<String>(accreditationNo);
    map['valid_until'] = Variable<String>(validUntil);
    map['vat_reg'] = Variable<String>(vatReg);
    map['permit_to_use'] = Variable<String>(permitToUse);
    map['machine_identification_number'] = Variable<String>(
      machineIdentificationNumber,
    );
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
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

  factory SettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      mainPrinter: serializer.fromJson<String>(json['mainPrinter']),
      subPrinter: serializer.fromJson<String>(json['subPrinter']),
      showVatOnReceipt: serializer.fromJson<bool>(json['showVatOnReceipt']),
      showOfficialReceiptMessageAtTheBottom: serializer.fromJson<bool>(
        json['showOfficialReceiptMessageAtTheBottom'],
      ),
      birAccredited: serializer.fromJson<bool>(json['birAccredited']),
      showReceiptPreview: serializer.fromJson<bool>(json['showReceiptPreview']),
      addCustomerToTransaction: serializer.fromJson<bool>(
        json['addCustomerToTransaction'],
      ),
      addPurchaseOrderToTransaction: serializer.fromJson<bool>(
        json['addPurchaseOrderToTransaction'],
      ),
      counterDisplay: serializer.fromJson<String>(json['counterDisplay']),
      companyName: serializer.fromJson<String>(json['companyName']),
      address: serializer.fromJson<String>(json['address']),
      accreditationNo: serializer.fromJson<String>(json['accreditationNo']),
      validUntil: serializer.fromJson<String>(json['validUntil']),
      vatReg: serializer.fromJson<String>(json['vatReg']),
      permitToUse: serializer.fromJson<String>(json['permitToUse']),
      machineIdentificationNumber: serializer.fromJson<String>(
        json['machineIdentificationNumber'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mainPrinter': serializer.toJson<String>(mainPrinter),
      'subPrinter': serializer.toJson<String>(subPrinter),
      'showVatOnReceipt': serializer.toJson<bool>(showVatOnReceipt),
      'showOfficialReceiptMessageAtTheBottom': serializer.toJson<bool>(
        showOfficialReceiptMessageAtTheBottom,
      ),
      'birAccredited': serializer.toJson<bool>(birAccredited),
      'showReceiptPreview': serializer.toJson<bool>(showReceiptPreview),
      'addCustomerToTransaction': serializer.toJson<bool>(
        addCustomerToTransaction,
      ),
      'addPurchaseOrderToTransaction': serializer.toJson<bool>(
        addPurchaseOrderToTransaction,
      ),
      'counterDisplay': serializer.toJson<String>(counterDisplay),
      'companyName': serializer.toJson<String>(companyName),
      'address': serializer.toJson<String>(address),
      'accreditationNo': serializer.toJson<String>(accreditationNo),
      'validUntil': serializer.toJson<String>(validUntil),
      'vatReg': serializer.toJson<String>(vatReg),
      'permitToUse': serializer.toJson<String>(permitToUse),
      'machineIdentificationNumber': serializer.toJson<String>(
        machineIdentificationNumber,
      ),
    };
  }

  SettingsTableData copyWith({
    String? id,
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
  }) => SettingsTableData(
    id: id ?? this.id,
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
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      mainPrinter: data.mainPrinter.present
          ? data.mainPrinter.value
          : this.mainPrinter,
      subPrinter: data.subPrinter.present
          ? data.subPrinter.value
          : this.subPrinter,
      showVatOnReceipt: data.showVatOnReceipt.present
          ? data.showVatOnReceipt.value
          : this.showVatOnReceipt,
      showOfficialReceiptMessageAtTheBottom:
          data.showOfficialReceiptMessageAtTheBottom.present
          ? data.showOfficialReceiptMessageAtTheBottom.value
          : this.showOfficialReceiptMessageAtTheBottom,
      birAccredited: data.birAccredited.present
          ? data.birAccredited.value
          : this.birAccredited,
      showReceiptPreview: data.showReceiptPreview.present
          ? data.showReceiptPreview.value
          : this.showReceiptPreview,
      addCustomerToTransaction: data.addCustomerToTransaction.present
          ? data.addCustomerToTransaction.value
          : this.addCustomerToTransaction,
      addPurchaseOrderToTransaction: data.addPurchaseOrderToTransaction.present
          ? data.addPurchaseOrderToTransaction.value
          : this.addPurchaseOrderToTransaction,
      counterDisplay: data.counterDisplay.present
          ? data.counterDisplay.value
          : this.counterDisplay,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      address: data.address.present ? data.address.value : this.address,
      accreditationNo: data.accreditationNo.present
          ? data.accreditationNo.value
          : this.accreditationNo,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      vatReg: data.vatReg.present ? data.vatReg.value : this.vatReg,
      permitToUse: data.permitToUse.present
          ? data.permitToUse.value
          : this.permitToUse,
      machineIdentificationNumber: data.machineIdentificationNumber.present
          ? data.machineIdentificationNumber.value
          : this.machineIdentificationNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('id: $id, ')
          ..write('mainPrinter: $mainPrinter, ')
          ..write('subPrinter: $subPrinter, ')
          ..write('showVatOnReceipt: $showVatOnReceipt, ')
          ..write(
            'showOfficialReceiptMessageAtTheBottom: $showOfficialReceiptMessageAtTheBottom, ',
          )
          ..write('birAccredited: $birAccredited, ')
          ..write('showReceiptPreview: $showReceiptPreview, ')
          ..write('addCustomerToTransaction: $addCustomerToTransaction, ')
          ..write(
            'addPurchaseOrderToTransaction: $addPurchaseOrderToTransaction, ',
          )
          ..write('counterDisplay: $counterDisplay, ')
          ..write('companyName: $companyName, ')
          ..write('address: $address, ')
          ..write('accreditationNo: $accreditationNo, ')
          ..write('validUntil: $validUntil, ')
          ..write('vatReg: $vatReg, ')
          ..write('permitToUse: $permitToUse, ')
          ..write('machineIdentificationNumber: $machineIdentificationNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mainPrinter,
    subPrinter,
    showVatOnReceipt,
    showOfficialReceiptMessageAtTheBottom,
    birAccredited,
    showReceiptPreview,
    addCustomerToTransaction,
    addPurchaseOrderToTransaction,
    counterDisplay,
    companyName,
    address,
    accreditationNo,
    validUntil,
    vatReg,
    permitToUse,
    machineIdentificationNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.id == this.id &&
          other.mainPrinter == this.mainPrinter &&
          other.subPrinter == this.subPrinter &&
          other.showVatOnReceipt == this.showVatOnReceipt &&
          other.showOfficialReceiptMessageAtTheBottom ==
              this.showOfficialReceiptMessageAtTheBottom &&
          other.birAccredited == this.birAccredited &&
          other.showReceiptPreview == this.showReceiptPreview &&
          other.addCustomerToTransaction == this.addCustomerToTransaction &&
          other.addPurchaseOrderToTransaction ==
              this.addPurchaseOrderToTransaction &&
          other.counterDisplay == this.counterDisplay &&
          other.companyName == this.companyName &&
          other.address == this.address &&
          other.accreditationNo == this.accreditationNo &&
          other.validUntil == this.validUntil &&
          other.vatReg == this.vatReg &&
          other.permitToUse == this.permitToUse &&
          other.machineIdentificationNumber ==
              this.machineIdentificationNumber);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<String> id;
  final Value<String> mainPrinter;
  final Value<String> subPrinter;
  final Value<bool> showVatOnReceipt;
  final Value<bool> showOfficialReceiptMessageAtTheBottom;
  final Value<bool> birAccredited;
  final Value<bool> showReceiptPreview;
  final Value<bool> addCustomerToTransaction;
  final Value<bool> addPurchaseOrderToTransaction;
  final Value<String> counterDisplay;
  final Value<String> companyName;
  final Value<String> address;
  final Value<String> accreditationNo;
  final Value<String> validUntil;
  final Value<String> vatReg;
  final Value<String> permitToUse;
  final Value<String> machineIdentificationNumber;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.mainPrinter = const Value.absent(),
    this.subPrinter = const Value.absent(),
    this.showVatOnReceipt = const Value.absent(),
    this.showOfficialReceiptMessageAtTheBottom = const Value.absent(),
    this.birAccredited = const Value.absent(),
    this.showReceiptPreview = const Value.absent(),
    this.addCustomerToTransaction = const Value.absent(),
    this.addPurchaseOrderToTransaction = const Value.absent(),
    this.counterDisplay = const Value.absent(),
    this.companyName = const Value.absent(),
    this.address = const Value.absent(),
    this.accreditationNo = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.vatReg = const Value.absent(),
    this.permitToUse = const Value.absent(),
    this.machineIdentificationNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.mainPrinter = const Value.absent(),
    this.subPrinter = const Value.absent(),
    this.showVatOnReceipt = const Value.absent(),
    this.showOfficialReceiptMessageAtTheBottom = const Value.absent(),
    this.birAccredited = const Value.absent(),
    this.showReceiptPreview = const Value.absent(),
    this.addCustomerToTransaction = const Value.absent(),
    this.addPurchaseOrderToTransaction = const Value.absent(),
    this.counterDisplay = const Value.absent(),
    this.companyName = const Value.absent(),
    this.address = const Value.absent(),
    this.accreditationNo = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.vatReg = const Value.absent(),
    this.permitToUse = const Value.absent(),
    this.machineIdentificationNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<SettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? mainPrinter,
    Expression<String>? subPrinter,
    Expression<bool>? showVatOnReceipt,
    Expression<bool>? showOfficialReceiptMessageAtTheBottom,
    Expression<bool>? birAccredited,
    Expression<bool>? showReceiptPreview,
    Expression<bool>? addCustomerToTransaction,
    Expression<bool>? addPurchaseOrderToTransaction,
    Expression<String>? counterDisplay,
    Expression<String>? companyName,
    Expression<String>? address,
    Expression<String>? accreditationNo,
    Expression<String>? validUntil,
    Expression<String>? vatReg,
    Expression<String>? permitToUse,
    Expression<String>? machineIdentificationNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mainPrinter != null) 'main_printer': mainPrinter,
      if (subPrinter != null) 'sub_printer': subPrinter,
      if (showVatOnReceipt != null) 'show_vat_on_receipt': showVatOnReceipt,
      if (showOfficialReceiptMessageAtTheBottom != null)
        'show_official_receipt_message_at_the_bottom':
            showOfficialReceiptMessageAtTheBottom,
      if (birAccredited != null) 'bir_accredited': birAccredited,
      if (showReceiptPreview != null)
        'show_receipt_preview': showReceiptPreview,
      if (addCustomerToTransaction != null)
        'add_customer_to_transaction': addCustomerToTransaction,
      if (addPurchaseOrderToTransaction != null)
        'add_purchase_order_to_transaction': addPurchaseOrderToTransaction,
      if (counterDisplay != null) 'counter_display': counterDisplay,
      if (companyName != null) 'company_name': companyName,
      if (address != null) 'address': address,
      if (accreditationNo != null) 'accreditation_no': accreditationNo,
      if (validUntil != null) 'valid_until': validUntil,
      if (vatReg != null) 'vat_reg': vatReg,
      if (permitToUse != null) 'permit_to_use': permitToUse,
      if (machineIdentificationNumber != null)
        'machine_identification_number': machineIdentificationNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? mainPrinter,
    Value<String>? subPrinter,
    Value<bool>? showVatOnReceipt,
    Value<bool>? showOfficialReceiptMessageAtTheBottom,
    Value<bool>? birAccredited,
    Value<bool>? showReceiptPreview,
    Value<bool>? addCustomerToTransaction,
    Value<bool>? addPurchaseOrderToTransaction,
    Value<String>? counterDisplay,
    Value<String>? companyName,
    Value<String>? address,
    Value<String>? accreditationNo,
    Value<String>? validUntil,
    Value<String>? vatReg,
    Value<String>? permitToUse,
    Value<String>? machineIdentificationNumber,
    Value<int>? rowid,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mainPrinter.present) {
      map['main_printer'] = Variable<String>(mainPrinter.value);
    }
    if (subPrinter.present) {
      map['sub_printer'] = Variable<String>(subPrinter.value);
    }
    if (showVatOnReceipt.present) {
      map['show_vat_on_receipt'] = Variable<bool>(showVatOnReceipt.value);
    }
    if (showOfficialReceiptMessageAtTheBottom.present) {
      map['show_official_receipt_message_at_the_bottom'] = Variable<bool>(
        showOfficialReceiptMessageAtTheBottom.value,
      );
    }
    if (birAccredited.present) {
      map['bir_accredited'] = Variable<bool>(birAccredited.value);
    }
    if (showReceiptPreview.present) {
      map['show_receipt_preview'] = Variable<bool>(showReceiptPreview.value);
    }
    if (addCustomerToTransaction.present) {
      map['add_customer_to_transaction'] = Variable<bool>(
        addCustomerToTransaction.value,
      );
    }
    if (addPurchaseOrderToTransaction.present) {
      map['add_purchase_order_to_transaction'] = Variable<bool>(
        addPurchaseOrderToTransaction.value,
      );
    }
    if (counterDisplay.present) {
      map['counter_display'] = Variable<String>(counterDisplay.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (accreditationNo.present) {
      map['accreditation_no'] = Variable<String>(accreditationNo.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<String>(validUntil.value);
    }
    if (vatReg.present) {
      map['vat_reg'] = Variable<String>(vatReg.value);
    }
    if (permitToUse.present) {
      map['permit_to_use'] = Variable<String>(permitToUse.value);
    }
    if (machineIdentificationNumber.present) {
      map['machine_identification_number'] = Variable<String>(
        machineIdentificationNumber.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('mainPrinter: $mainPrinter, ')
          ..write('subPrinter: $subPrinter, ')
          ..write('showVatOnReceipt: $showVatOnReceipt, ')
          ..write(
            'showOfficialReceiptMessageAtTheBottom: $showOfficialReceiptMessageAtTheBottom, ',
          )
          ..write('birAccredited: $birAccredited, ')
          ..write('showReceiptPreview: $showReceiptPreview, ')
          ..write('addCustomerToTransaction: $addCustomerToTransaction, ')
          ..write(
            'addPurchaseOrderToTransaction: $addPurchaseOrderToTransaction, ',
          )
          ..write('counterDisplay: $counterDisplay, ')
          ..write('companyName: $companyName, ')
          ..write('address: $address, ')
          ..write('accreditationNo: $accreditationNo, ')
          ..write('validUntil: $validUntil, ')
          ..write('vatReg: $vatReg, ')
          ..write('permitToUse: $permitToUse, ')
          ..write('machineIdentificationNumber: $machineIdentificationNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTableTable extends SalesTable
    with TableInfo<$SalesTableTable, SalesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _detailIdMeta = const VerificationMeta(
    'detailId',
  );
  @override
  late final GeneratedColumn<String> detailId = GeneratedColumn<String>(
    'detail_id',
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
  static const VerificationMeta _posidMeta = const VerificationMeta('posid');
  @override
  late final GeneratedColumn<String> posid = GeneratedColumn<String>(
    'posid',
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
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
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
  static const VerificationMeta _itemsMeta = const VerificationMeta('items');
  @override
  late final GeneratedColumn<String> items = GeneratedColumn<String>(
    'items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<String> total = GeneratedColumn<String>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _cashierMeta = const VerificationMeta(
    'cashier',
  );
  @override
  late final GeneratedColumn<String> cashier = GeneratedColumn<String>(
    'cashier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _cashMeta = const VerificationMeta('cash');
  @override
  late final GeneratedColumn<String> cash = GeneratedColumn<String>(
    'cash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _ecashMeta = const VerificationMeta('ecash');
  @override
  late final GeneratedColumn<String> ecash = GeneratedColumn<String>(
    'ecash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _discountDetailMeta = const VerificationMeta(
    'discountDetail',
  );
  @override
  late final GeneratedColumn<String> discountDetail = GeneratedColumn<String>(
    'discount_detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _isSyncMeta = const VerificationMeta('isSync');
  @override
  late final GeneratedColumn<String> isSync = GeneratedColumn<String>(
    'is_sync',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    detailId,
    date,
    posid,
    shift,
    paymentType,
    referenceId,
    paymentName,
    items,
    total,
    cashier,
    cash,
    ecash,
    branch,
    discountDetail,
    isSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('detail_id')) {
      context.handle(
        _detailIdMeta,
        detailId.isAcceptableOrUnknown(data['detail_id']!, _detailIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('posid')) {
      context.handle(
        _posidMeta,
        posid.isAcceptableOrUnknown(data['posid']!, _posidMeta),
      );
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
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
    if (data.containsKey('items')) {
      context.handle(
        _itemsMeta,
        items.isAcceptableOrUnknown(data['items']!, _itemsMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('cashier')) {
      context.handle(
        _cashierMeta,
        cashier.isAcceptableOrUnknown(data['cashier']!, _cashierMeta),
      );
    }
    if (data.containsKey('cash')) {
      context.handle(
        _cashMeta,
        cash.isAcceptableOrUnknown(data['cash']!, _cashMeta),
      );
    }
    if (data.containsKey('ecash')) {
      context.handle(
        _ecashMeta,
        ecash.isAcceptableOrUnknown(data['ecash']!, _ecashMeta),
      );
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    if (data.containsKey('discount_detail')) {
      context.handle(
        _discountDetailMeta,
        discountDetail.isAcceptableOrUnknown(
          data['discount_detail']!,
          _discountDetailMeta,
        ),
      );
    }
    if (data.containsKey('is_sync')) {
      context.handle(
        _isSyncMeta,
        isSync.isAcceptableOrUnknown(data['is_sync']!, _isSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      detailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      posid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}posid'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      paymentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_name'],
      )!,
      items: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total'],
      )!,
      cashier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier'],
      )!,
      cash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cash'],
      )!,
      ecash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ecash'],
      )!,
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      )!,
      discountDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_detail'],
      )!,
      isSync: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}is_sync'],
      )!,
    );
  }

  @override
  $SalesTableTable createAlias(String alias) {
    return $SalesTableTable(attachedDatabase, alias);
  }
}

class SalesTableData extends DataClass implements Insertable<SalesTableData> {
  final String id;
  final DateTime createdAt;
  final String detailId;
  final String date;
  final String posid;
  final String shift;
  final String paymentType;
  final String referenceId;
  final String paymentName;
  final String items;
  final String total;
  final String cashier;
  final String cash;
  final String ecash;
  final String branch;
  final String discountDetail;
  final String isSync;
  const SalesTableData({
    required this.id,
    required this.createdAt,
    required this.detailId,
    required this.date,
    required this.posid,
    required this.shift,
    required this.paymentType,
    required this.referenceId,
    required this.paymentName,
    required this.items,
    required this.total,
    required this.cashier,
    required this.cash,
    required this.ecash,
    required this.branch,
    required this.discountDetail,
    required this.isSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['detail_id'] = Variable<String>(detailId);
    map['date'] = Variable<String>(date);
    map['posid'] = Variable<String>(posid);
    map['shift'] = Variable<String>(shift);
    map['payment_type'] = Variable<String>(paymentType);
    map['reference_id'] = Variable<String>(referenceId);
    map['payment_name'] = Variable<String>(paymentName);
    map['items'] = Variable<String>(items);
    map['total'] = Variable<String>(total);
    map['cashier'] = Variable<String>(cashier);
    map['cash'] = Variable<String>(cash);
    map['ecash'] = Variable<String>(ecash);
    map['branch'] = Variable<String>(branch);
    map['discount_detail'] = Variable<String>(discountDetail);
    map['is_sync'] = Variable<String>(isSync);
    return map;
  }

  SalesTableCompanion toCompanion(bool nullToAbsent) {
    return SalesTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      detailId: Value(detailId),
      date: Value(date),
      posid: Value(posid),
      shift: Value(shift),
      paymentType: Value(paymentType),
      referenceId: Value(referenceId),
      paymentName: Value(paymentName),
      items: Value(items),
      total: Value(total),
      cashier: Value(cashier),
      cash: Value(cash),
      ecash: Value(ecash),
      branch: Value(branch),
      discountDetail: Value(discountDetail),
      isSync: Value(isSync),
    );
  }

  factory SalesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      detailId: serializer.fromJson<String>(json['detailId']),
      date: serializer.fromJson<String>(json['date']),
      posid: serializer.fromJson<String>(json['posid']),
      shift: serializer.fromJson<String>(json['shift']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      paymentName: serializer.fromJson<String>(json['paymentName']),
      items: serializer.fromJson<String>(json['items']),
      total: serializer.fromJson<String>(json['total']),
      cashier: serializer.fromJson<String>(json['cashier']),
      cash: serializer.fromJson<String>(json['cash']),
      ecash: serializer.fromJson<String>(json['ecash']),
      branch: serializer.fromJson<String>(json['branch']),
      discountDetail: serializer.fromJson<String>(json['discountDetail']),
      isSync: serializer.fromJson<String>(json['isSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'detailId': serializer.toJson<String>(detailId),
      'date': serializer.toJson<String>(date),
      'posid': serializer.toJson<String>(posid),
      'shift': serializer.toJson<String>(shift),
      'paymentType': serializer.toJson<String>(paymentType),
      'referenceId': serializer.toJson<String>(referenceId),
      'paymentName': serializer.toJson<String>(paymentName),
      'items': serializer.toJson<String>(items),
      'total': serializer.toJson<String>(total),
      'cashier': serializer.toJson<String>(cashier),
      'cash': serializer.toJson<String>(cash),
      'ecash': serializer.toJson<String>(ecash),
      'branch': serializer.toJson<String>(branch),
      'discountDetail': serializer.toJson<String>(discountDetail),
      'isSync': serializer.toJson<String>(isSync),
    };
  }

  SalesTableData copyWith({
    String? id,
    DateTime? createdAt,
    String? detailId,
    String? date,
    String? posid,
    String? shift,
    String? paymentType,
    String? referenceId,
    String? paymentName,
    String? items,
    String? total,
    String? cashier,
    String? cash,
    String? ecash,
    String? branch,
    String? discountDetail,
    String? isSync,
  }) => SalesTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    detailId: detailId ?? this.detailId,
    date: date ?? this.date,
    posid: posid ?? this.posid,
    shift: shift ?? this.shift,
    paymentType: paymentType ?? this.paymentType,
    referenceId: referenceId ?? this.referenceId,
    paymentName: paymentName ?? this.paymentName,
    items: items ?? this.items,
    total: total ?? this.total,
    cashier: cashier ?? this.cashier,
    cash: cash ?? this.cash,
    ecash: ecash ?? this.ecash,
    branch: branch ?? this.branch,
    discountDetail: discountDetail ?? this.discountDetail,
    isSync: isSync ?? this.isSync,
  );
  SalesTableData copyWithCompanion(SalesTableCompanion data) {
    return SalesTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      detailId: data.detailId.present ? data.detailId.value : this.detailId,
      date: data.date.present ? data.date.value : this.date,
      posid: data.posid.present ? data.posid.value : this.posid,
      shift: data.shift.present ? data.shift.value : this.shift,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      paymentName: data.paymentName.present
          ? data.paymentName.value
          : this.paymentName,
      items: data.items.present ? data.items.value : this.items,
      total: data.total.present ? data.total.value : this.total,
      cashier: data.cashier.present ? data.cashier.value : this.cashier,
      cash: data.cash.present ? data.cash.value : this.cash,
      ecash: data.ecash.present ? data.ecash.value : this.ecash,
      branch: data.branch.present ? data.branch.value : this.branch,
      discountDetail: data.discountDetail.present
          ? data.discountDetail.value
          : this.discountDetail,
      isSync: data.isSync.present ? data.isSync.value : this.isSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('detailId: $detailId, ')
          ..write('date: $date, ')
          ..write('posid: $posid, ')
          ..write('shift: $shift, ')
          ..write('paymentType: $paymentType, ')
          ..write('referenceId: $referenceId, ')
          ..write('paymentName: $paymentName, ')
          ..write('items: $items, ')
          ..write('total: $total, ')
          ..write('cashier: $cashier, ')
          ..write('cash: $cash, ')
          ..write('ecash: $ecash, ')
          ..write('branch: $branch, ')
          ..write('discountDetail: $discountDetail, ')
          ..write('isSync: $isSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    detailId,
    date,
    posid,
    shift,
    paymentType,
    referenceId,
    paymentName,
    items,
    total,
    cashier,
    cash,
    ecash,
    branch,
    discountDetail,
    isSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.detailId == this.detailId &&
          other.date == this.date &&
          other.posid == this.posid &&
          other.shift == this.shift &&
          other.paymentType == this.paymentType &&
          other.referenceId == this.referenceId &&
          other.paymentName == this.paymentName &&
          other.items == this.items &&
          other.total == this.total &&
          other.cashier == this.cashier &&
          other.cash == this.cash &&
          other.ecash == this.ecash &&
          other.branch == this.branch &&
          other.discountDetail == this.discountDetail &&
          other.isSync == this.isSync);
}

class SalesTableCompanion extends UpdateCompanion<SalesTableData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<String> detailId;
  final Value<String> date;
  final Value<String> posid;
  final Value<String> shift;
  final Value<String> paymentType;
  final Value<String> referenceId;
  final Value<String> paymentName;
  final Value<String> items;
  final Value<String> total;
  final Value<String> cashier;
  final Value<String> cash;
  final Value<String> ecash;
  final Value<String> branch;
  final Value<String> discountDetail;
  final Value<String> isSync;
  final Value<int> rowid;
  const SalesTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.detailId = const Value.absent(),
    this.date = const Value.absent(),
    this.posid = const Value.absent(),
    this.shift = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.paymentName = const Value.absent(),
    this.items = const Value.absent(),
    this.total = const Value.absent(),
    this.cashier = const Value.absent(),
    this.cash = const Value.absent(),
    this.ecash = const Value.absent(),
    this.branch = const Value.absent(),
    this.discountDetail = const Value.absent(),
    this.isSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.detailId = const Value.absent(),
    this.date = const Value.absent(),
    this.posid = const Value.absent(),
    this.shift = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.paymentName = const Value.absent(),
    this.items = const Value.absent(),
    this.total = const Value.absent(),
    this.cashier = const Value.absent(),
    this.cash = const Value.absent(),
    this.ecash = const Value.absent(),
    this.branch = const Value.absent(),
    this.discountDetail = const Value.absent(),
    this.isSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<SalesTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? detailId,
    Expression<String>? date,
    Expression<String>? posid,
    Expression<String>? shift,
    Expression<String>? paymentType,
    Expression<String>? referenceId,
    Expression<String>? paymentName,
    Expression<String>? items,
    Expression<String>? total,
    Expression<String>? cashier,
    Expression<String>? cash,
    Expression<String>? ecash,
    Expression<String>? branch,
    Expression<String>? discountDetail,
    Expression<String>? isSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (detailId != null) 'detail_id': detailId,
      if (date != null) 'date': date,
      if (posid != null) 'posid': posid,
      if (shift != null) 'shift': shift,
      if (paymentType != null) 'payment_type': paymentType,
      if (referenceId != null) 'reference_id': referenceId,
      if (paymentName != null) 'payment_name': paymentName,
      if (items != null) 'items': items,
      if (total != null) 'total': total,
      if (cashier != null) 'cashier': cashier,
      if (cash != null) 'cash': cash,
      if (ecash != null) 'ecash': ecash,
      if (branch != null) 'branch': branch,
      if (discountDetail != null) 'discount_detail': discountDetail,
      if (isSync != null) 'is_sync': isSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<String>? detailId,
    Value<String>? date,
    Value<String>? posid,
    Value<String>? shift,
    Value<String>? paymentType,
    Value<String>? referenceId,
    Value<String>? paymentName,
    Value<String>? items,
    Value<String>? total,
    Value<String>? cashier,
    Value<String>? cash,
    Value<String>? ecash,
    Value<String>? branch,
    Value<String>? discountDetail,
    Value<String>? isSync,
    Value<int>? rowid,
  }) {
    return SalesTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      detailId: detailId ?? this.detailId,
      date: date ?? this.date,
      posid: posid ?? this.posid,
      shift: shift ?? this.shift,
      paymentType: paymentType ?? this.paymentType,
      referenceId: referenceId ?? this.referenceId,
      paymentName: paymentName ?? this.paymentName,
      items: items ?? this.items,
      total: total ?? this.total,
      cashier: cashier ?? this.cashier,
      cash: cash ?? this.cash,
      ecash: ecash ?? this.ecash,
      branch: branch ?? this.branch,
      discountDetail: discountDetail ?? this.discountDetail,
      isSync: isSync ?? this.isSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (detailId.present) {
      map['detail_id'] = Variable<String>(detailId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (posid.present) {
      map['posid'] = Variable<String>(posid.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (paymentName.present) {
      map['payment_name'] = Variable<String>(paymentName.value);
    }
    if (items.present) {
      map['items'] = Variable<String>(items.value);
    }
    if (total.present) {
      map['total'] = Variable<String>(total.value);
    }
    if (cashier.present) {
      map['cashier'] = Variable<String>(cashier.value);
    }
    if (cash.present) {
      map['cash'] = Variable<String>(cash.value);
    }
    if (ecash.present) {
      map['ecash'] = Variable<String>(ecash.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (discountDetail.present) {
      map['discount_detail'] = Variable<String>(discountDetail.value);
    }
    if (isSync.present) {
      map['is_sync'] = Variable<String>(isSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('detailId: $detailId, ')
          ..write('date: $date, ')
          ..write('posid: $posid, ')
          ..write('shift: $shift, ')
          ..write('paymentType: $paymentType, ')
          ..write('referenceId: $referenceId, ')
          ..write('paymentName: $paymentName, ')
          ..write('items: $items, ')
          ..write('total: $total, ')
          ..write('cashier: $cashier, ')
          ..write('cash: $cash, ')
          ..write('ecash: $ecash, ')
          ..write('branch: $branch, ')
          ..write('discountDetail: $discountDetail, ')
          ..write('isSync: $isSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EndShiftTableTable extends EndShiftTable
    with TableInfo<$EndShiftTableTable, EndShiftTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EndShiftTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<int> pos = GeneratedColumn<int>(
    'pos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<int> shift = GeneratedColumn<int>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashierMeta = const VerificationMeta(
    'cashier',
  );
  @override
  late final GeneratedColumn<String> cashier = GeneratedColumn<String>(
    'cashier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _floatingMeta = const VerificationMeta(
    'floating',
  );
  @override
  late final GeneratedColumn<String> floating = GeneratedColumn<String>(
    'floating',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashfloatMeta = const VerificationMeta(
    'cashfloat',
  );
  @override
  late final GeneratedColumn<String> cashfloat = GeneratedColumn<String>(
    'cashfloat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salesBeginningMeta = const VerificationMeta(
    'salesBeginning',
  );
  @override
  late final GeneratedColumn<double> salesBeginning = GeneratedColumn<double>(
    'sales_beginning',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salesEndingMeta = const VerificationMeta(
    'salesEnding',
  );
  @override
  late final GeneratedColumn<double> salesEnding = GeneratedColumn<double>(
    'sales_ending',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSalesMeta = const VerificationMeta(
    'totalSales',
  );
  @override
  late final GeneratedColumn<double> totalSales = GeneratedColumn<double>(
    'total_sales',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedDateMeta = const VerificationMeta(
    'approvedDate',
  );
  @override
  late final GeneratedColumn<String> approvedDate = GeneratedColumn<String>(
    'approved_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    pos,
    shift,
    cashier,
    floating,
    cashfloat,
    salesBeginning,
    salesEnding,
    totalSales,
    receiptBeginning,
    receiptEnding,
    status,
    approvedBy,
    approvedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'end_shift_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EndShiftTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    } else if (isInserting) {
      context.missing(_posMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('cashier')) {
      context.handle(
        _cashierMeta,
        cashier.isAcceptableOrUnknown(data['cashier']!, _cashierMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierMeta);
    }
    if (data.containsKey('floating')) {
      context.handle(
        _floatingMeta,
        floating.isAcceptableOrUnknown(data['floating']!, _floatingMeta),
      );
    }
    if (data.containsKey('cashfloat')) {
      context.handle(
        _cashfloatMeta,
        cashfloat.isAcceptableOrUnknown(data['cashfloat']!, _cashfloatMeta),
      );
    }
    if (data.containsKey('sales_beginning')) {
      context.handle(
        _salesBeginningMeta,
        salesBeginning.isAcceptableOrUnknown(
          data['sales_beginning']!,
          _salesBeginningMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salesBeginningMeta);
    }
    if (data.containsKey('sales_ending')) {
      context.handle(
        _salesEndingMeta,
        salesEnding.isAcceptableOrUnknown(
          data['sales_ending']!,
          _salesEndingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salesEndingMeta);
    }
    if (data.containsKey('total_sales')) {
      context.handle(
        _totalSalesMeta,
        totalSales.isAcceptableOrUnknown(data['total_sales']!, _totalSalesMeta),
      );
    } else if (isInserting) {
      context.missing(_totalSalesMeta);
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptBeginningMeta);
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptEndingMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('approved_date')) {
      context.handle(
        _approvedDateMeta,
        approvedDate.isAcceptableOrUnknown(
          data['approved_date']!,
          _approvedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date, pos, shift},
  ];
  @override
  EndShiftTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EndShiftTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pos'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift'],
      )!,
      cashier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier'],
      )!,
      floating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}floating'],
      ),
      cashfloat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashfloat'],
      ),
      salesBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sales_beginning'],
      )!,
      salesEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sales_ending'],
      )!,
      totalSales: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_sales'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      approvedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_date'],
      ),
    );
  }

  @override
  $EndShiftTableTable createAlias(String alias) {
    return $EndShiftTableTable(attachedDatabase, alias);
  }
}

class EndShiftTableData extends DataClass
    implements Insertable<EndShiftTableData> {
  final String id;
  final String date;
  final int pos;
  final int shift;
  final String cashier;
  final String? floating;
  final String? cashfloat;
  final double salesBeginning;
  final double salesEnding;
  final double totalSales;
  final int receiptBeginning;
  final int receiptEnding;
  final String status;
  final String? approvedBy;
  final String? approvedDate;
  const EndShiftTableData({
    required this.id,
    required this.date,
    required this.pos,
    required this.shift,
    required this.cashier,
    this.floating,
    this.cashfloat,
    required this.salesBeginning,
    required this.salesEnding,
    required this.totalSales,
    required this.receiptBeginning,
    required this.receiptEnding,
    required this.status,
    this.approvedBy,
    this.approvedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['pos'] = Variable<int>(pos);
    map['shift'] = Variable<int>(shift);
    map['cashier'] = Variable<String>(cashier);
    if (!nullToAbsent || floating != null) {
      map['floating'] = Variable<String>(floating);
    }
    if (!nullToAbsent || cashfloat != null) {
      map['cashfloat'] = Variable<String>(cashfloat);
    }
    map['sales_beginning'] = Variable<double>(salesBeginning);
    map['sales_ending'] = Variable<double>(salesEnding);
    map['total_sales'] = Variable<double>(totalSales);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || approvedDate != null) {
      map['approved_date'] = Variable<String>(approvedDate);
    }
    return map;
  }

  EndShiftTableCompanion toCompanion(bool nullToAbsent) {
    return EndShiftTableCompanion(
      id: Value(id),
      date: Value(date),
      pos: Value(pos),
      shift: Value(shift),
      cashier: Value(cashier),
      floating: floating == null && nullToAbsent
          ? const Value.absent()
          : Value(floating),
      cashfloat: cashfloat == null && nullToAbsent
          ? const Value.absent()
          : Value(cashfloat),
      salesBeginning: Value(salesBeginning),
      salesEnding: Value(salesEnding),
      totalSales: Value(totalSales),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
      status: Value(status),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedDate: approvedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedDate),
    );
  }

  factory EndShiftTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EndShiftTableData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      pos: serializer.fromJson<int>(json['pos']),
      shift: serializer.fromJson<int>(json['shift']),
      cashier: serializer.fromJson<String>(json['cashier']),
      floating: serializer.fromJson<String?>(json['floating']),
      cashfloat: serializer.fromJson<String?>(json['cashfloat']),
      salesBeginning: serializer.fromJson<double>(json['salesBeginning']),
      salesEnding: serializer.fromJson<double>(json['salesEnding']),
      totalSales: serializer.fromJson<double>(json['totalSales']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
      status: serializer.fromJson<String>(json['status']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      approvedDate: serializer.fromJson<String?>(json['approvedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'pos': serializer.toJson<int>(pos),
      'shift': serializer.toJson<int>(shift),
      'cashier': serializer.toJson<String>(cashier),
      'floating': serializer.toJson<String?>(floating),
      'cashfloat': serializer.toJson<String?>(cashfloat),
      'salesBeginning': serializer.toJson<double>(salesBeginning),
      'salesEnding': serializer.toJson<double>(salesEnding),
      'totalSales': serializer.toJson<double>(totalSales),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
      'status': serializer.toJson<String>(status),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'approvedDate': serializer.toJson<String?>(approvedDate),
    };
  }

  EndShiftTableData copyWith({
    String? id,
    String? date,
    int? pos,
    int? shift,
    String? cashier,
    Value<String?> floating = const Value.absent(),
    Value<String?> cashfloat = const Value.absent(),
    double? salesBeginning,
    double? salesEnding,
    double? totalSales,
    int? receiptBeginning,
    int? receiptEnding,
    String? status,
    Value<String?> approvedBy = const Value.absent(),
    Value<String?> approvedDate = const Value.absent(),
  }) => EndShiftTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    pos: pos ?? this.pos,
    shift: shift ?? this.shift,
    cashier: cashier ?? this.cashier,
    floating: floating.present ? floating.value : this.floating,
    cashfloat: cashfloat.present ? cashfloat.value : this.cashfloat,
    salesBeginning: salesBeginning ?? this.salesBeginning,
    salesEnding: salesEnding ?? this.salesEnding,
    totalSales: totalSales ?? this.totalSales,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
    status: status ?? this.status,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    approvedDate: approvedDate.present ? approvedDate.value : this.approvedDate,
  );
  EndShiftTableData copyWithCompanion(EndShiftTableCompanion data) {
    return EndShiftTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      pos: data.pos.present ? data.pos.value : this.pos,
      shift: data.shift.present ? data.shift.value : this.shift,
      cashier: data.cashier.present ? data.cashier.value : this.cashier,
      floating: data.floating.present ? data.floating.value : this.floating,
      cashfloat: data.cashfloat.present ? data.cashfloat.value : this.cashfloat,
      salesBeginning: data.salesBeginning.present
          ? data.salesBeginning.value
          : this.salesBeginning,
      salesEnding: data.salesEnding.present
          ? data.salesEnding.value
          : this.salesEnding,
      totalSales: data.totalSales.present
          ? data.totalSales.value
          : this.totalSales,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
      status: data.status.present ? data.status.value : this.status,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      approvedDate: data.approvedDate.present
          ? data.approvedDate.value
          : this.approvedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EndShiftTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('pos: $pos, ')
          ..write('shift: $shift, ')
          ..write('cashier: $cashier, ')
          ..write('floating: $floating, ')
          ..write('cashfloat: $cashfloat, ')
          ..write('salesBeginning: $salesBeginning, ')
          ..write('salesEnding: $salesEnding, ')
          ..write('totalSales: $totalSales, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedDate: $approvedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    pos,
    shift,
    cashier,
    floating,
    cashfloat,
    salesBeginning,
    salesEnding,
    totalSales,
    receiptBeginning,
    receiptEnding,
    status,
    approvedBy,
    approvedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EndShiftTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.pos == this.pos &&
          other.shift == this.shift &&
          other.cashier == this.cashier &&
          other.floating == this.floating &&
          other.cashfloat == this.cashfloat &&
          other.salesBeginning == this.salesBeginning &&
          other.salesEnding == this.salesEnding &&
          other.totalSales == this.totalSales &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding &&
          other.status == this.status &&
          other.approvedBy == this.approvedBy &&
          other.approvedDate == this.approvedDate);
}

class EndShiftTableCompanion extends UpdateCompanion<EndShiftTableData> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> pos;
  final Value<int> shift;
  final Value<String> cashier;
  final Value<String?> floating;
  final Value<String?> cashfloat;
  final Value<double> salesBeginning;
  final Value<double> salesEnding;
  final Value<double> totalSales;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<String> status;
  final Value<String?> approvedBy;
  final Value<String?> approvedDate;
  final Value<int> rowid;
  const EndShiftTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.pos = const Value.absent(),
    this.shift = const Value.absent(),
    this.cashier = const Value.absent(),
    this.floating = const Value.absent(),
    this.cashfloat = const Value.absent(),
    this.salesBeginning = const Value.absent(),
    this.salesEnding = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EndShiftTableCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int pos,
    required int shift,
    required String cashier,
    this.floating = const Value.absent(),
    this.cashfloat = const Value.absent(),
    required double salesBeginning,
    required double salesEnding,
    required double totalSales,
    required int receiptBeginning,
    required int receiptEnding,
    required String status,
    this.approvedBy = const Value.absent(),
    this.approvedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       pos = Value(pos),
       shift = Value(shift),
       cashier = Value(cashier),
       salesBeginning = Value(salesBeginning),
       salesEnding = Value(salesEnding),
       totalSales = Value(totalSales),
       receiptBeginning = Value(receiptBeginning),
       receiptEnding = Value(receiptEnding),
       status = Value(status);
  static Insertable<EndShiftTableData> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? pos,
    Expression<int>? shift,
    Expression<String>? cashier,
    Expression<String>? floating,
    Expression<String>? cashfloat,
    Expression<double>? salesBeginning,
    Expression<double>? salesEnding,
    Expression<double>? totalSales,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<String>? status,
    Expression<String>? approvedBy,
    Expression<String>? approvedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (pos != null) 'pos': pos,
      if (shift != null) 'shift': shift,
      if (cashier != null) 'cashier': cashier,
      if (floating != null) 'floating': floating,
      if (cashfloat != null) 'cashfloat': cashfloat,
      if (salesBeginning != null) 'sales_beginning': salesBeginning,
      if (salesEnding != null) 'sales_ending': salesEnding,
      if (totalSales != null) 'total_sales': totalSales,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (status != null) 'status': status,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedDate != null) 'approved_date': approvedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EndShiftTableCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? pos,
    Value<int>? shift,
    Value<String>? cashier,
    Value<String?>? floating,
    Value<String?>? cashfloat,
    Value<double>? salesBeginning,
    Value<double>? salesEnding,
    Value<double>? totalSales,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<String>? status,
    Value<String?>? approvedBy,
    Value<String?>? approvedDate,
    Value<int>? rowid,
  }) {
    return EndShiftTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      pos: pos ?? this.pos,
      shift: shift ?? this.shift,
      cashier: cashier ?? this.cashier,
      floating: floating ?? this.floating,
      cashfloat: cashfloat ?? this.cashfloat,
      salesBeginning: salesBeginning ?? this.salesBeginning,
      salesEnding: salesEnding ?? this.salesEnding,
      totalSales: totalSales ?? this.totalSales,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (pos.present) {
      map['pos'] = Variable<int>(pos.value);
    }
    if (shift.present) {
      map['shift'] = Variable<int>(shift.value);
    }
    if (cashier.present) {
      map['cashier'] = Variable<String>(cashier.value);
    }
    if (floating.present) {
      map['floating'] = Variable<String>(floating.value);
    }
    if (cashfloat.present) {
      map['cashfloat'] = Variable<String>(cashfloat.value);
    }
    if (salesBeginning.present) {
      map['sales_beginning'] = Variable<double>(salesBeginning.value);
    }
    if (salesEnding.present) {
      map['sales_ending'] = Variable<double>(salesEnding.value);
    }
    if (totalSales.present) {
      map['total_sales'] = Variable<double>(totalSales.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (approvedDate.present) {
      map['approved_date'] = Variable<String>(approvedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EndShiftTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('pos: $pos, ')
          ..write('shift: $shift, ')
          ..write('cashier: $cashier, ')
          ..write('floating: $floating, ')
          ..write('cashfloat: $cashfloat, ')
          ..write('salesBeginning: $salesBeginning, ')
          ..write('salesEnding: $salesEnding, ')
          ..write('totalSales: $totalSales, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedDate: $approvedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoldItemsTableTable extends SoldItemsTable
    with TableInfo<$SoldItemsTableTable, SoldItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoldItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _dateRangeMeta = const VerificationMeta(
    'dateRange',
  );
  @override
  late final GeneratedColumn<String> dateRange = GeneratedColumn<String>(
    'date_range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryFilterMeta = const VerificationMeta(
    'categoryFilter',
  );
  @override
  late final GeneratedColumn<String> categoryFilter = GeneratedColumn<String>(
    'category_filter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ALL'),
  );
  static const VerificationMeta _productFilterMeta = const VerificationMeta(
    'productFilter',
  );
  @override
  late final GeneratedColumn<String> productFilter = GeneratedColumn<String>(
    'product_filter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ALL'),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
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
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
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
    id,
    dateRange,
    categoryFilter,
    productFilter,
    fetchedAt,
    branch,
    category,
    name,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sold_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoldItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_range')) {
      context.handle(
        _dateRangeMeta,
        dateRange.isAcceptableOrUnknown(data['date_range']!, _dateRangeMeta),
      );
    } else if (isInserting) {
      context.missing(_dateRangeMeta);
    }
    if (data.containsKey('category_filter')) {
      context.handle(
        _categoryFilterMeta,
        categoryFilter.isAcceptableOrUnknown(
          data['category_filter']!,
          _categoryFilterMeta,
        ),
      );
    }
    if (data.containsKey('product_filter')) {
      context.handle(
        _productFilterMeta,
        productFilter.isAcceptableOrUnknown(
          data['product_filter']!,
          _productFilterMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {dateRange, categoryFilter, productFilter, branch, category, name},
  ];
  @override
  SoldItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoldItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dateRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_range'],
      )!,
      categoryFilter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_filter'],
      )!,
      productFilter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_filter'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at'],
      )!,
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $SoldItemsTableTable createAlias(String alias) {
    return $SoldItemsTableTable(attachedDatabase, alias);
  }
}

class SoldItemsTableData extends DataClass
    implements Insertable<SoldItemsTableData> {
  final String id;

  /// "2026-09-28" for a single day, "2026-09-21 - 2026-09-28" for a range.
  final String dateRange;

  /// Category filter as sent to the API. 'ALL' means no filter.
  final String categoryFilter;

  /// Product filter as sent to the API. 'ALL' means no filter.
  final String productFilter;

  /// When this row was fetched (epoch millis). Lets the UI say
  /// "Last updated ..." when showing offline data.
  final int fetchedAt;
  final String branch;
  final String category;
  final String name;
  final int quantity;
  const SoldItemsTableData({
    required this.id,
    required this.dateRange,
    required this.categoryFilter,
    required this.productFilter,
    required this.fetchedAt,
    required this.branch,
    required this.category,
    required this.name,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_range'] = Variable<String>(dateRange);
    map['category_filter'] = Variable<String>(categoryFilter);
    map['product_filter'] = Variable<String>(productFilter);
    map['fetched_at'] = Variable<int>(fetchedAt);
    map['branch'] = Variable<String>(branch);
    map['category'] = Variable<String>(category);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  SoldItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SoldItemsTableCompanion(
      id: Value(id),
      dateRange: Value(dateRange),
      categoryFilter: Value(categoryFilter),
      productFilter: Value(productFilter),
      fetchedAt: Value(fetchedAt),
      branch: Value(branch),
      category: Value(category),
      name: Value(name),
      quantity: Value(quantity),
    );
  }

  factory SoldItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoldItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      dateRange: serializer.fromJson<String>(json['dateRange']),
      categoryFilter: serializer.fromJson<String>(json['categoryFilter']),
      productFilter: serializer.fromJson<String>(json['productFilter']),
      fetchedAt: serializer.fromJson<int>(json['fetchedAt']),
      branch: serializer.fromJson<String>(json['branch']),
      category: serializer.fromJson<String>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateRange': serializer.toJson<String>(dateRange),
      'categoryFilter': serializer.toJson<String>(categoryFilter),
      'productFilter': serializer.toJson<String>(productFilter),
      'fetchedAt': serializer.toJson<int>(fetchedAt),
      'branch': serializer.toJson<String>(branch),
      'category': serializer.toJson<String>(category),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  SoldItemsTableData copyWith({
    String? id,
    String? dateRange,
    String? categoryFilter,
    String? productFilter,
    int? fetchedAt,
    String? branch,
    String? category,
    String? name,
    int? quantity,
  }) => SoldItemsTableData(
    id: id ?? this.id,
    dateRange: dateRange ?? this.dateRange,
    categoryFilter: categoryFilter ?? this.categoryFilter,
    productFilter: productFilter ?? this.productFilter,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    branch: branch ?? this.branch,
    category: category ?? this.category,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
  );
  SoldItemsTableData copyWithCompanion(SoldItemsTableCompanion data) {
    return SoldItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      dateRange: data.dateRange.present ? data.dateRange.value : this.dateRange,
      categoryFilter: data.categoryFilter.present
          ? data.categoryFilter.value
          : this.categoryFilter,
      productFilter: data.productFilter.present
          ? data.productFilter.value
          : this.productFilter,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      branch: data.branch.present ? data.branch.value : this.branch,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoldItemsTableData(')
          ..write('id: $id, ')
          ..write('dateRange: $dateRange, ')
          ..write('categoryFilter: $categoryFilter, ')
          ..write('productFilter: $productFilter, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('branch: $branch, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateRange,
    categoryFilter,
    productFilter,
    fetchedAt,
    branch,
    category,
    name,
    quantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoldItemsTableData &&
          other.id == this.id &&
          other.dateRange == this.dateRange &&
          other.categoryFilter == this.categoryFilter &&
          other.productFilter == this.productFilter &&
          other.fetchedAt == this.fetchedAt &&
          other.branch == this.branch &&
          other.category == this.category &&
          other.name == this.name &&
          other.quantity == this.quantity);
}

class SoldItemsTableCompanion extends UpdateCompanion<SoldItemsTableData> {
  final Value<String> id;
  final Value<String> dateRange;
  final Value<String> categoryFilter;
  final Value<String> productFilter;
  final Value<int> fetchedAt;
  final Value<String> branch;
  final Value<String> category;
  final Value<String> name;
  final Value<int> quantity;
  final Value<int> rowid;
  const SoldItemsTableCompanion({
    this.id = const Value.absent(),
    this.dateRange = const Value.absent(),
    this.categoryFilter = const Value.absent(),
    this.productFilter = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.branch = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoldItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required String dateRange,
    this.categoryFilter = const Value.absent(),
    this.productFilter = const Value.absent(),
    required int fetchedAt,
    this.branch = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dateRange = Value(dateRange),
       fetchedAt = Value(fetchedAt);
  static Insertable<SoldItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? dateRange,
    Expression<String>? categoryFilter,
    Expression<String>? productFilter,
    Expression<int>? fetchedAt,
    Expression<String>? branch,
    Expression<String>? category,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateRange != null) 'date_range': dateRange,
      if (categoryFilter != null) 'category_filter': categoryFilter,
      if (productFilter != null) 'product_filter': productFilter,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (branch != null) 'branch': branch,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoldItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? dateRange,
    Value<String>? categoryFilter,
    Value<String>? productFilter,
    Value<int>? fetchedAt,
    Value<String>? branch,
    Value<String>? category,
    Value<String>? name,
    Value<int>? quantity,
    Value<int>? rowid,
  }) {
    return SoldItemsTableCompanion(
      id: id ?? this.id,
      dateRange: dateRange ?? this.dateRange,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      productFilter: productFilter ?? this.productFilter,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      branch: branch ?? this.branch,
      category: category ?? this.category,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateRange.present) {
      map['date_range'] = Variable<String>(dateRange.value);
    }
    if (categoryFilter.present) {
      map['category_filter'] = Variable<String>(categoryFilter.value);
    }
    if (productFilter.present) {
      map['product_filter'] = Variable<String>(productFilter.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoldItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('dateRange: $dateRange, ')
          ..write('categoryFilter: $categoryFilter, ')
          ..write('productFilter: $productFilter, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('branch: $branch, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashDrawerTableTable extends CashDrawerTable
    with TableInfo<$CashDrawerTableTable, CashDrawerTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashDrawerTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
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
  static const VerificationMeta _cashierMeta = const VerificationMeta(
    'cashier',
  );
  @override
  late final GeneratedColumn<String> cashier = GeneratedColumn<String>(
    'cashier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _shiftDateMeta = const VerificationMeta(
    'shiftDate',
  );
  @override
  late final GeneratedColumn<String> shiftDate = GeneratedColumn<String>(
    'shift_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
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
  static const VerificationMeta _denominationMeta = const VerificationMeta(
    'denomination',
  );
  @override
  late final GeneratedColumn<String> denomination = GeneratedColumn<String>(
    'denomination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _activityMeta = const VerificationMeta(
    'activity',
  );
  @override
  late final GeneratedColumn<String> activity = GeneratedColumn<String>(
    'activity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<int> queuedAt = GeneratedColumn<int>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shift,
    cashier,
    shiftDate,
    branchId,
    posId,
    denomination,
    activity,
    queuedAt,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_drawer_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashDrawerTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    }
    if (data.containsKey('cashier')) {
      context.handle(
        _cashierMeta,
        cashier.isAcceptableOrUnknown(data['cashier']!, _cashierMeta),
      );
    }
    if (data.containsKey('shift_date')) {
      context.handle(
        _shiftDateMeta,
        shiftDate.isAcceptableOrUnknown(data['shift_date']!, _shiftDateMeta),
      );
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    }
    if (data.containsKey('denomination')) {
      context.handle(
        _denominationMeta,
        denomination.isAcceptableOrUnknown(
          data['denomination']!,
          _denominationMeta,
        ),
      );
    }
    if (data.containsKey('activity')) {
      context.handle(
        _activityMeta,
        activity.isAcceptableOrUnknown(data['activity']!, _activityMeta),
      );
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_queuedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashDrawerTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashDrawerTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      cashier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier'],
      )!,
      shiftDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_date'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_id'],
      )!,
      denomination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}denomination'],
      )!,
      activity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}queued_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $CashDrawerTableTable createAlias(String alias) {
    return $CashDrawerTableTable(attachedDatabase, alias);
  }
}

class CashDrawerTableData extends DataClass
    implements Insertable<CashDrawerTableData> {
  final String id;
  final String shift;
  final String cashier;
  final String shiftDate;
  final String branchId;
  final String posId;

  /// The exact JSON string the server expects for the `denomination` field
  /// (already `jsonEncode`d — the API takes a JSON-encoded STRING, not a
  /// nested array). Stored pre-encoded so what gets sent is byte-for-byte
  /// what was queued, with no re-serialization step that could drift from it.
  final String denomination;

  /// 'endshift' or 'transaction'. Named `activity` to match the API's own
  /// field name, even though it also fires at start shift (the server calls
  /// both open-shift and close-shift traffic 'endshift').
  final String activity;

  /// When this row was queued (epoch millis). Used to send activities to the
  /// server in the order they happened.
  final int queuedAt;

  /// True once the server has confirmed this activity. Unsynced rows are what
  /// gets retried; synced rows are kept as a local audit trail.
  final bool synced;
  const CashDrawerTableData({
    required this.id,
    required this.shift,
    required this.cashier,
    required this.shiftDate,
    required this.branchId,
    required this.posId,
    required this.denomination,
    required this.activity,
    required this.queuedAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift'] = Variable<String>(shift);
    map['cashier'] = Variable<String>(cashier);
    map['shift_date'] = Variable<String>(shiftDate);
    map['branch_id'] = Variable<String>(branchId);
    map['pos_id'] = Variable<String>(posId);
    map['denomination'] = Variable<String>(denomination);
    map['activity'] = Variable<String>(activity);
    map['queued_at'] = Variable<int>(queuedAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  CashDrawerTableCompanion toCompanion(bool nullToAbsent) {
    return CashDrawerTableCompanion(
      id: Value(id),
      shift: Value(shift),
      cashier: Value(cashier),
      shiftDate: Value(shiftDate),
      branchId: Value(branchId),
      posId: Value(posId),
      denomination: Value(denomination),
      activity: Value(activity),
      queuedAt: Value(queuedAt),
      synced: Value(synced),
    );
  }

  factory CashDrawerTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashDrawerTableData(
      id: serializer.fromJson<String>(json['id']),
      shift: serializer.fromJson<String>(json['shift']),
      cashier: serializer.fromJson<String>(json['cashier']),
      shiftDate: serializer.fromJson<String>(json['shiftDate']),
      branchId: serializer.fromJson<String>(json['branchId']),
      posId: serializer.fromJson<String>(json['posId']),
      denomination: serializer.fromJson<String>(json['denomination']),
      activity: serializer.fromJson<String>(json['activity']),
      queuedAt: serializer.fromJson<int>(json['queuedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shift': serializer.toJson<String>(shift),
      'cashier': serializer.toJson<String>(cashier),
      'shiftDate': serializer.toJson<String>(shiftDate),
      'branchId': serializer.toJson<String>(branchId),
      'posId': serializer.toJson<String>(posId),
      'denomination': serializer.toJson<String>(denomination),
      'activity': serializer.toJson<String>(activity),
      'queuedAt': serializer.toJson<int>(queuedAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  CashDrawerTableData copyWith({
    String? id,
    String? shift,
    String? cashier,
    String? shiftDate,
    String? branchId,
    String? posId,
    String? denomination,
    String? activity,
    int? queuedAt,
    bool? synced,
  }) => CashDrawerTableData(
    id: id ?? this.id,
    shift: shift ?? this.shift,
    cashier: cashier ?? this.cashier,
    shiftDate: shiftDate ?? this.shiftDate,
    branchId: branchId ?? this.branchId,
    posId: posId ?? this.posId,
    denomination: denomination ?? this.denomination,
    activity: activity ?? this.activity,
    queuedAt: queuedAt ?? this.queuedAt,
    synced: synced ?? this.synced,
  );
  CashDrawerTableData copyWithCompanion(CashDrawerTableCompanion data) {
    return CashDrawerTableData(
      id: data.id.present ? data.id.value : this.id,
      shift: data.shift.present ? data.shift.value : this.shift,
      cashier: data.cashier.present ? data.cashier.value : this.cashier,
      shiftDate: data.shiftDate.present ? data.shiftDate.value : this.shiftDate,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      posId: data.posId.present ? data.posId.value : this.posId,
      denomination: data.denomination.present
          ? data.denomination.value
          : this.denomination,
      activity: data.activity.present ? data.activity.value : this.activity,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashDrawerTableData(')
          ..write('id: $id, ')
          ..write('shift: $shift, ')
          ..write('cashier: $cashier, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('denomination: $denomination, ')
          ..write('activity: $activity, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shift,
    cashier,
    shiftDate,
    branchId,
    posId,
    denomination,
    activity,
    queuedAt,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashDrawerTableData &&
          other.id == this.id &&
          other.shift == this.shift &&
          other.cashier == this.cashier &&
          other.shiftDate == this.shiftDate &&
          other.branchId == this.branchId &&
          other.posId == this.posId &&
          other.denomination == this.denomination &&
          other.activity == this.activity &&
          other.queuedAt == this.queuedAt &&
          other.synced == this.synced);
}

class CashDrawerTableCompanion extends UpdateCompanion<CashDrawerTableData> {
  final Value<String> id;
  final Value<String> shift;
  final Value<String> cashier;
  final Value<String> shiftDate;
  final Value<String> branchId;
  final Value<String> posId;
  final Value<String> denomination;
  final Value<String> activity;
  final Value<int> queuedAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const CashDrawerTableCompanion({
    this.id = const Value.absent(),
    this.shift = const Value.absent(),
    this.cashier = const Value.absent(),
    this.shiftDate = const Value.absent(),
    this.branchId = const Value.absent(),
    this.posId = const Value.absent(),
    this.denomination = const Value.absent(),
    this.activity = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashDrawerTableCompanion.insert({
    this.id = const Value.absent(),
    this.shift = const Value.absent(),
    this.cashier = const Value.absent(),
    this.shiftDate = const Value.absent(),
    this.branchId = const Value.absent(),
    this.posId = const Value.absent(),
    this.denomination = const Value.absent(),
    this.activity = const Value.absent(),
    required int queuedAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : queuedAt = Value(queuedAt);
  static Insertable<CashDrawerTableData> custom({
    Expression<String>? id,
    Expression<String>? shift,
    Expression<String>? cashier,
    Expression<String>? shiftDate,
    Expression<String>? branchId,
    Expression<String>? posId,
    Expression<String>? denomination,
    Expression<String>? activity,
    Expression<int>? queuedAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shift != null) 'shift': shift,
      if (cashier != null) 'cashier': cashier,
      if (shiftDate != null) 'shift_date': shiftDate,
      if (branchId != null) 'branch_id': branchId,
      if (posId != null) 'pos_id': posId,
      if (denomination != null) 'denomination': denomination,
      if (activity != null) 'activity': activity,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashDrawerTableCompanion copyWith({
    Value<String>? id,
    Value<String>? shift,
    Value<String>? cashier,
    Value<String>? shiftDate,
    Value<String>? branchId,
    Value<String>? posId,
    Value<String>? denomination,
    Value<String>? activity,
    Value<int>? queuedAt,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return CashDrawerTableCompanion(
      id: id ?? this.id,
      shift: shift ?? this.shift,
      cashier: cashier ?? this.cashier,
      shiftDate: shiftDate ?? this.shiftDate,
      branchId: branchId ?? this.branchId,
      posId: posId ?? this.posId,
      denomination: denomination ?? this.denomination,
      activity: activity ?? this.activity,
      queuedAt: queuedAt ?? this.queuedAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (cashier.present) {
      map['cashier'] = Variable<String>(cashier.value);
    }
    if (shiftDate.present) {
      map['shift_date'] = Variable<String>(shiftDate.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (posId.present) {
      map['pos_id'] = Variable<String>(posId.value);
    }
    if (denomination.present) {
      map['denomination'] = Variable<String>(denomination.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(activity.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<int>(queuedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashDrawerTableCompanion(')
          ..write('id: $id, ')
          ..write('shift: $shift, ')
          ..write('cashier: $cashier, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('denomination: $denomination, ')
          ..write('activity: $activity, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoldItemsReportTableTable extends SoldItemsReportTable
    with TableInfo<$SoldItemsReportTableTable, SoldItemsReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoldItemsReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
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
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    item,
    quantity,
    total,
    receiptBeginning,
    receiptEnding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sold_items_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoldItemsReportTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoldItemsReportTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoldItemsReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
    );
  }

  @override
  $SoldItemsReportTableTable createAlias(String alias) {
    return $SoldItemsReportTableTable(attachedDatabase, alias);
  }
}

class SoldItemsReportTableData extends DataClass
    implements Insertable<SoldItemsReportTableData> {
  final String id;
  final String item;
  final int quantity;
  final double total;

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's items.
  final int receiptBeginning;
  final int receiptEnding;
  const SoldItemsReportTableData({
    required this.id,
    required this.item,
    required this.quantity,
    required this.total,
    required this.receiptBeginning,
    required this.receiptEnding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item'] = Variable<String>(item);
    map['quantity'] = Variable<int>(quantity);
    map['total'] = Variable<double>(total);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    return map;
  }

  SoldItemsReportTableCompanion toCompanion(bool nullToAbsent) {
    return SoldItemsReportTableCompanion(
      id: Value(id),
      item: Value(item),
      quantity: Value(quantity),
      total: Value(total),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
    );
  }

  factory SoldItemsReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoldItemsReportTableData(
      id: serializer.fromJson<String>(json['id']),
      item: serializer.fromJson<String>(json['item']),
      quantity: serializer.fromJson<int>(json['quantity']),
      total: serializer.fromJson<double>(json['total']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'item': serializer.toJson<String>(item),
      'quantity': serializer.toJson<int>(quantity),
      'total': serializer.toJson<double>(total),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
    };
  }

  SoldItemsReportTableData copyWith({
    String? id,
    String? item,
    int? quantity,
    double? total,
    int? receiptBeginning,
    int? receiptEnding,
  }) => SoldItemsReportTableData(
    id: id ?? this.id,
    item: item ?? this.item,
    quantity: quantity ?? this.quantity,
    total: total ?? this.total,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
  );
  SoldItemsReportTableData copyWithCompanion(
    SoldItemsReportTableCompanion data,
  ) {
    return SoldItemsReportTableData(
      id: data.id.present ? data.id.value : this.id,
      item: data.item.present ? data.item.value : this.item,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      total: data.total.present ? data.total.value : this.total,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoldItemsReportTableData(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, item, quantity, total, receiptBeginning, receiptEnding);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoldItemsReportTableData &&
          other.id == this.id &&
          other.item == this.item &&
          other.quantity == this.quantity &&
          other.total == this.total &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding);
}

class SoldItemsReportTableCompanion
    extends UpdateCompanion<SoldItemsReportTableData> {
  final Value<String> id;
  final Value<String> item;
  final Value<int> quantity;
  final Value<double> total;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<int> rowid;
  const SoldItemsReportTableCompanion({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoldItemsReportTableCompanion.insert({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<SoldItemsReportTableData> custom({
    Expression<String>? id,
    Expression<String>? item,
    Expression<int>? quantity,
    Expression<double>? total,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (item != null) 'item': item,
      if (quantity != null) 'quantity': quantity,
      if (total != null) 'total': total,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoldItemsReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? item,
    Value<int>? quantity,
    Value<double>? total,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<int>? rowid,
  }) {
    return SoldItemsReportTableCompanion(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoldItemsReportTableCompanion(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentSummaryReportTableTable extends PaymentSummaryReportTable
    with
        TableInfo<
          $PaymentSummaryReportTableTable,
          PaymentSummaryReportTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentSummaryReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentType,
    total,
    receiptBeginning,
    receiptEnding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_summary_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentSummaryReportTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentSummaryReportTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentSummaryReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
    );
  }

  @override
  $PaymentSummaryReportTableTable createAlias(String alias) {
    return $PaymentSummaryReportTableTable(attachedDatabase, alias);
  }
}

class PaymentSummaryReportTableData extends DataClass
    implements Insertable<PaymentSummaryReportTableData> {
  final String id;
  final String paymentType;
  final double total;

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's payments.
  final int receiptBeginning;
  final int receiptEnding;
  const PaymentSummaryReportTableData({
    required this.id,
    required this.paymentType,
    required this.total,
    required this.receiptBeginning,
    required this.receiptEnding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payment_type'] = Variable<String>(paymentType);
    map['total'] = Variable<double>(total);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    return map;
  }

  PaymentSummaryReportTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentSummaryReportTableCompanion(
      id: Value(id),
      paymentType: Value(paymentType),
      total: Value(total),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
    );
  }

  factory PaymentSummaryReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentSummaryReportTableData(
      id: serializer.fromJson<String>(json['id']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      total: serializer.fromJson<double>(json['total']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentType': serializer.toJson<String>(paymentType),
      'total': serializer.toJson<double>(total),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
    };
  }

  PaymentSummaryReportTableData copyWith({
    String? id,
    String? paymentType,
    double? total,
    int? receiptBeginning,
    int? receiptEnding,
  }) => PaymentSummaryReportTableData(
    id: id ?? this.id,
    paymentType: paymentType ?? this.paymentType,
    total: total ?? this.total,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
  );
  PaymentSummaryReportTableData copyWithCompanion(
    PaymentSummaryReportTableCompanion data,
  ) {
    return PaymentSummaryReportTableData(
      id: data.id.present ? data.id.value : this.id,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      total: data.total.present ? data.total.value : this.total,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentSummaryReportTableData(')
          ..write('id: $id, ')
          ..write('paymentType: $paymentType, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, paymentType, total, receiptBeginning, receiptEnding);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentSummaryReportTableData &&
          other.id == this.id &&
          other.paymentType == this.paymentType &&
          other.total == this.total &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding);
}

class PaymentSummaryReportTableCompanion
    extends UpdateCompanion<PaymentSummaryReportTableData> {
  final Value<String> id;
  final Value<String> paymentType;
  final Value<double> total;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<int> rowid;
  const PaymentSummaryReportTableCompanion({
    this.id = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentSummaryReportTableCompanion.insert({
    this.id = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PaymentSummaryReportTableData> custom({
    Expression<String>? id,
    Expression<String>? paymentType,
    Expression<double>? total,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentType != null) 'payment_type': paymentType,
      if (total != null) 'total': total,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentSummaryReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? paymentType,
    Value<double>? total,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<int>? rowid,
  }) {
    return PaymentSummaryReportTableCompanion(
      id: id ?? this.id,
      paymentType: paymentType ?? this.paymentType,
      total: total ?? this.total,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentSummaryReportTableCompanion(')
          ..write('id: $id, ')
          ..write('paymentType: $paymentType, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StaffSalesReportTableTable extends StaffSalesReportTable
    with TableInfo<$StaffSalesReportTableTable, StaffSalesReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffSalesReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _salesStaffMeta = const VerificationMeta(
    'salesStaff',
  );
  @override
  late final GeneratedColumn<String> salesStaff = GeneratedColumn<String>(
    'sales_staff',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    salesStaff,
    total,
    receiptBeginning,
    receiptEnding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_sales_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StaffSalesReportTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sales_staff')) {
      context.handle(
        _salesStaffMeta,
        salesStaff.isAcceptableOrUnknown(data['sales_staff']!, _salesStaffMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffSalesReportTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffSalesReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      salesStaff: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sales_staff'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
    );
  }

  @override
  $StaffSalesReportTableTable createAlias(String alias) {
    return $StaffSalesReportTableTable(attachedDatabase, alias);
  }
}

class StaffSalesReportTableData extends DataClass
    implements Insertable<StaffSalesReportTableData> {
  final String id;
  final String salesStaff;
  final double total;

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's staff sales.
  final int receiptBeginning;
  final int receiptEnding;
  const StaffSalesReportTableData({
    required this.id,
    required this.salesStaff,
    required this.total,
    required this.receiptBeginning,
    required this.receiptEnding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sales_staff'] = Variable<String>(salesStaff);
    map['total'] = Variable<double>(total);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    return map;
  }

  StaffSalesReportTableCompanion toCompanion(bool nullToAbsent) {
    return StaffSalesReportTableCompanion(
      id: Value(id),
      salesStaff: Value(salesStaff),
      total: Value(total),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
    );
  }

  factory StaffSalesReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffSalesReportTableData(
      id: serializer.fromJson<String>(json['id']),
      salesStaff: serializer.fromJson<String>(json['salesStaff']),
      total: serializer.fromJson<double>(json['total']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'salesStaff': serializer.toJson<String>(salesStaff),
      'total': serializer.toJson<double>(total),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
    };
  }

  StaffSalesReportTableData copyWith({
    String? id,
    String? salesStaff,
    double? total,
    int? receiptBeginning,
    int? receiptEnding,
  }) => StaffSalesReportTableData(
    id: id ?? this.id,
    salesStaff: salesStaff ?? this.salesStaff,
    total: total ?? this.total,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
  );
  StaffSalesReportTableData copyWithCompanion(
    StaffSalesReportTableCompanion data,
  ) {
    return StaffSalesReportTableData(
      id: data.id.present ? data.id.value : this.id,
      salesStaff: data.salesStaff.present
          ? data.salesStaff.value
          : this.salesStaff,
      total: data.total.present ? data.total.value : this.total,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffSalesReportTableData(')
          ..write('id: $id, ')
          ..write('salesStaff: $salesStaff, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, salesStaff, total, receiptBeginning, receiptEnding);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffSalesReportTableData &&
          other.id == this.id &&
          other.salesStaff == this.salesStaff &&
          other.total == this.total &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding);
}

class StaffSalesReportTableCompanion
    extends UpdateCompanion<StaffSalesReportTableData> {
  final Value<String> id;
  final Value<String> salesStaff;
  final Value<double> total;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<int> rowid;
  const StaffSalesReportTableCompanion({
    this.id = const Value.absent(),
    this.salesStaff = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StaffSalesReportTableCompanion.insert({
    this.id = const Value.absent(),
    this.salesStaff = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<StaffSalesReportTableData> custom({
    Expression<String>? id,
    Expression<String>? salesStaff,
    Expression<double>? total,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (salesStaff != null) 'sales_staff': salesStaff,
      if (total != null) 'total': total,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StaffSalesReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? salesStaff,
    Value<double>? total,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<int>? rowid,
  }) {
    return StaffSalesReportTableCompanion(
      id: id ?? this.id,
      salesStaff: salesStaff ?? this.salesStaff,
      total: total ?? this.total,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (salesStaff.present) {
      map['sales_staff'] = Variable<String>(salesStaff.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffSalesReportTableCompanion(')
          ..write('id: $id, ')
          ..write('salesStaff: $salesStaff, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoldServicesReportTableTable extends SoldServicesReportTable
    with TableInfo<$SoldServicesReportTableTable, SoldServicesReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoldServicesReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
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
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    item,
    quantity,
    total,
    receiptBeginning,
    receiptEnding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sold_services_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoldServicesReportTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoldServicesReportTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoldServicesReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
    );
  }

  @override
  $SoldServicesReportTableTable createAlias(String alias) {
    return $SoldServicesReportTableTable(attachedDatabase, alias);
  }
}

class SoldServicesReportTableData extends DataClass
    implements Insertable<SoldServicesReportTableData> {
  final String id;
  final String item;
  final int quantity;
  final double total;

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's services.
  final int receiptBeginning;
  final int receiptEnding;
  const SoldServicesReportTableData({
    required this.id,
    required this.item,
    required this.quantity,
    required this.total,
    required this.receiptBeginning,
    required this.receiptEnding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item'] = Variable<String>(item);
    map['quantity'] = Variable<int>(quantity);
    map['total'] = Variable<double>(total);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    return map;
  }

  SoldServicesReportTableCompanion toCompanion(bool nullToAbsent) {
    return SoldServicesReportTableCompanion(
      id: Value(id),
      item: Value(item),
      quantity: Value(quantity),
      total: Value(total),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
    );
  }

  factory SoldServicesReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoldServicesReportTableData(
      id: serializer.fromJson<String>(json['id']),
      item: serializer.fromJson<String>(json['item']),
      quantity: serializer.fromJson<int>(json['quantity']),
      total: serializer.fromJson<double>(json['total']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'item': serializer.toJson<String>(item),
      'quantity': serializer.toJson<int>(quantity),
      'total': serializer.toJson<double>(total),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
    };
  }

  SoldServicesReportTableData copyWith({
    String? id,
    String? item,
    int? quantity,
    double? total,
    int? receiptBeginning,
    int? receiptEnding,
  }) => SoldServicesReportTableData(
    id: id ?? this.id,
    item: item ?? this.item,
    quantity: quantity ?? this.quantity,
    total: total ?? this.total,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
  );
  SoldServicesReportTableData copyWithCompanion(
    SoldServicesReportTableCompanion data,
  ) {
    return SoldServicesReportTableData(
      id: data.id.present ? data.id.value : this.id,
      item: data.item.present ? data.item.value : this.item,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      total: data.total.present ? data.total.value : this.total,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoldServicesReportTableData(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, item, quantity, total, receiptBeginning, receiptEnding);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoldServicesReportTableData &&
          other.id == this.id &&
          other.item == this.item &&
          other.quantity == this.quantity &&
          other.total == this.total &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding);
}

class SoldServicesReportTableCompanion
    extends UpdateCompanion<SoldServicesReportTableData> {
  final Value<String> id;
  final Value<String> item;
  final Value<int> quantity;
  final Value<double> total;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<int> rowid;
  const SoldServicesReportTableCompanion({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoldServicesReportTableCompanion.insert({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<SoldServicesReportTableData> custom({
    Expression<String>? id,
    Expression<String>? item,
    Expression<int>? quantity,
    Expression<double>? total,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (item != null) 'item': item,
      if (quantity != null) 'quantity': quantity,
      if (total != null) 'total': total,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoldServicesReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? item,
    Value<int>? quantity,
    Value<double>? total,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<int>? rowid,
  }) {
    return SoldServicesReportTableCompanion(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoldServicesReportTableCompanion(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoldPackagesReportTableTable extends SoldPackagesReportTable
    with TableInfo<$SoldPackagesReportTableTable, SoldPackagesReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoldPackagesReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNREGISTERED'),
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
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    item,
    quantity,
    total,
    receiptBeginning,
    receiptEnding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sold_packages_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoldPackagesReportTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoldPackagesReportTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoldPackagesReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
    );
  }

  @override
  $SoldPackagesReportTableTable createAlias(String alias) {
    return $SoldPackagesReportTableTable(attachedDatabase, alias);
  }
}

class SoldPackagesReportTableData extends DataClass
    implements Insertable<SoldPackagesReportTableData> {
  final String id;
  final String item;
  final int quantity;
  final double total;

  /// The receipt range these rows belong to. Together they identify the shift,
  /// so a reprint can never pick up another shift's packages.
  final int receiptBeginning;
  final int receiptEnding;
  const SoldPackagesReportTableData({
    required this.id,
    required this.item,
    required this.quantity,
    required this.total,
    required this.receiptBeginning,
    required this.receiptEnding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item'] = Variable<String>(item);
    map['quantity'] = Variable<int>(quantity);
    map['total'] = Variable<double>(total);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    return map;
  }

  SoldPackagesReportTableCompanion toCompanion(bool nullToAbsent) {
    return SoldPackagesReportTableCompanion(
      id: Value(id),
      item: Value(item),
      quantity: Value(quantity),
      total: Value(total),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
    );
  }

  factory SoldPackagesReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoldPackagesReportTableData(
      id: serializer.fromJson<String>(json['id']),
      item: serializer.fromJson<String>(json['item']),
      quantity: serializer.fromJson<int>(json['quantity']),
      total: serializer.fromJson<double>(json['total']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'item': serializer.toJson<String>(item),
      'quantity': serializer.toJson<int>(quantity),
      'total': serializer.toJson<double>(total),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
    };
  }

  SoldPackagesReportTableData copyWith({
    String? id,
    String? item,
    int? quantity,
    double? total,
    int? receiptBeginning,
    int? receiptEnding,
  }) => SoldPackagesReportTableData(
    id: id ?? this.id,
    item: item ?? this.item,
    quantity: quantity ?? this.quantity,
    total: total ?? this.total,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
  );
  SoldPackagesReportTableData copyWithCompanion(
    SoldPackagesReportTableCompanion data,
  ) {
    return SoldPackagesReportTableData(
      id: data.id.present ? data.id.value : this.id,
      item: data.item.present ? data.item.value : this.item,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      total: data.total.present ? data.total.value : this.total,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoldPackagesReportTableData(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, item, quantity, total, receiptBeginning, receiptEnding);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoldPackagesReportTableData &&
          other.id == this.id &&
          other.item == this.item &&
          other.quantity == this.quantity &&
          other.total == this.total &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding);
}

class SoldPackagesReportTableCompanion
    extends UpdateCompanion<SoldPackagesReportTableData> {
  final Value<String> id;
  final Value<String> item;
  final Value<int> quantity;
  final Value<double> total;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<int> rowid;
  const SoldPackagesReportTableCompanion({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoldPackagesReportTableCompanion.insert({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.total = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<SoldPackagesReportTableData> custom({
    Expression<String>? id,
    Expression<String>? item,
    Expression<int>? quantity,
    Expression<double>? total,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (item != null) 'item': item,
      if (quantity != null) 'quantity': quantity,
      if (total != null) 'total': total,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoldPackagesReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? item,
    Value<int>? quantity,
    Value<double>? total,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<int>? rowid,
  }) {
    return SoldPackagesReportTableCompanion(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoldPackagesReportTableCompanion(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('total: $total, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceTableTable extends ServiceTable
    with TableInfo<$ServiceTableTable, ServiceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
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
    defaultValue: const Constant(''),
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
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    price,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceTableData> instance, {
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
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
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
  ServiceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
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
  $ServiceTableTable createAlias(String alias) {
    return $ServiceTableTable(attachedDatabase, alias);
  }
}

class ServiceTableData extends DataClass
    implements Insertable<ServiceTableData> {
  /// The server's own service id (not a local UUID), so the same service always
  /// maps to the same row.
  final int id;
  final String name;
  final double price;
  final String status;
  final String createdBy;

  /// Kept exactly as the server sends it, e.g. "2026-08-24 11:01".
  final String createdDate;
  const ServiceTableData({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  ServiceTableCompanion toCompanion(bool nullToAbsent) {
    return ServiceTableCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory ServiceTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
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
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  ServiceTableData copyWith({
    int? id,
    String? name,
    double? price,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => ServiceTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  ServiceTableData copyWithCompanion(ServiceTableCompanion data) {
    return ServiceTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, price, status, createdBy, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class ServiceTableCompanion extends UpdateCompanion<ServiceTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  const ServiceTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  ServiceTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<ServiceTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  ServiceTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? price,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
  }) {
    return ServiceTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
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
    return (StringBuffer('ServiceTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $ServicePackageTableTable extends ServicePackageTable
    with TableInfo<$ServicePackageTableTable, ServicePackageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicePackageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
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
  List<GeneratedColumn> get $columns => [id, name, price, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_package_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServicePackageTableData> instance, {
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
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServicePackageTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServicePackageTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $ServicePackageTableTable createAlias(String alias) {
    return $ServicePackageTableTable(attachedDatabase, alias);
  }
}

class ServicePackageTableData extends DataClass
    implements Insertable<ServicePackageTableData> {
  /// The server's own package id (not a local UUID), so the same package
  /// always maps to the same row.
  final int id;
  final String name;
  final double price;
  final int quantity;
  const ServicePackageTableData({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  ServicePackageTableCompanion toCompanion(bool nullToAbsent) {
    return ServicePackageTableCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      quantity: Value(quantity),
    );
  }

  factory ServicePackageTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServicePackageTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  ServicePackageTableData copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
  }) => ServicePackageTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
  );
  ServicePackageTableData copyWithCompanion(ServicePackageTableCompanion data) {
    return ServicePackageTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServicePackageTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, price, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServicePackageTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.quantity == this.quantity);
}

class ServicePackageTableCompanion
    extends UpdateCompanion<ServicePackageTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<int> quantity;
  const ServicePackageTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  ServicePackageTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  static Insertable<ServicePackageTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
    });
  }

  ServicePackageTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? price,
    Value<int>? quantity,
  }) {
    return ServicePackageTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicePackageTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $AddonTableTable extends AddonTable
    with TableInfo<$AddonTableTable, AddonTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddonTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addonTypeMeta = const VerificationMeta(
    'addonType',
  );
  @override
  late final GeneratedColumn<String> addonType = GeneratedColumn<String>(
    'addon_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isProductMeta = const VerificationMeta(
    'isProduct',
  );
  @override
  late final GeneratedColumn<bool> isProduct = GeneratedColumn<bool>(
    'is_product',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_product" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
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
    defaultValue: const Constant(''),
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
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    addonType,
    price,
    isProduct,
    status,
    createdBy,
    createdDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'addon_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AddonTableData> instance, {
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
    if (data.containsKey('addon_type')) {
      context.handle(
        _addonTypeMeta,
        addonType.isAcceptableOrUnknown(data['addon_type']!, _addonTypeMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('is_product')) {
      context.handle(
        _isProductMeta,
        isProduct.isAcceptableOrUnknown(data['is_product']!, _isProductMeta),
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
  AddonTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AddonTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      addonType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addon_type'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      isProduct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_product'],
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
  $AddonTableTable createAlias(String alias) {
    return $AddonTableTable(attachedDatabase, alias);
  }
}

class AddonTableData extends DataClass implements Insertable<AddonTableData> {
  /// The server's own addon id (not a local UUID), so the same addon always
  /// maps to the same row.
  final int id;
  final String name;

  /// The addon type's name, e.g. what the server joins from `addon_type`.
  final String addonType;
  final double price;
  final bool isProduct;
  final String status;
  final String createdBy;

  /// Kept exactly as the server sends it.
  final String createdDate;
  const AddonTableData({
    required this.id,
    required this.name,
    required this.addonType,
    required this.price,
    required this.isProduct,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['addon_type'] = Variable<String>(addonType);
    map['price'] = Variable<double>(price);
    map['is_product'] = Variable<bool>(isProduct);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_date'] = Variable<String>(createdDate);
    return map;
  }

  AddonTableCompanion toCompanion(bool nullToAbsent) {
    return AddonTableCompanion(
      id: Value(id),
      name: Value(name),
      addonType: Value(addonType),
      price: Value(price),
      isProduct: Value(isProduct),
      status: Value(status),
      createdBy: Value(createdBy),
      createdDate: Value(createdDate),
    );
  }

  factory AddonTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AddonTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      addonType: serializer.fromJson<String>(json['addonType']),
      price: serializer.fromJson<double>(json['price']),
      isProduct: serializer.fromJson<bool>(json['isProduct']),
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
      'name': serializer.toJson<String>(name),
      'addonType': serializer.toJson<String>(addonType),
      'price': serializer.toJson<double>(price),
      'isProduct': serializer.toJson<bool>(isProduct),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdDate': serializer.toJson<String>(createdDate),
    };
  }

  AddonTableData copyWith({
    int? id,
    String? name,
    String? addonType,
    double? price,
    bool? isProduct,
    String? status,
    String? createdBy,
    String? createdDate,
  }) => AddonTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    addonType: addonType ?? this.addonType,
    price: price ?? this.price,
    isProduct: isProduct ?? this.isProduct,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    createdDate: createdDate ?? this.createdDate,
  );
  AddonTableData copyWithCompanion(AddonTableCompanion data) {
    return AddonTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      addonType: data.addonType.present ? data.addonType.value : this.addonType,
      price: data.price.present ? data.price.value : this.price,
      isProduct: data.isProduct.present ? data.isProduct.value : this.isProduct,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdDate: data.createdDate.present
          ? data.createdDate.value
          : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AddonTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('addonType: $addonType, ')
          ..write('price: $price, ')
          ..write('isProduct: $isProduct, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    addonType,
    price,
    isProduct,
    status,
    createdBy,
    createdDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddonTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.addonType == this.addonType &&
          other.price == this.price &&
          other.isProduct == this.isProduct &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdDate == this.createdDate);
}

class AddonTableCompanion extends UpdateCompanion<AddonTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> addonType;
  final Value<double> price;
  final Value<bool> isProduct;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<String> createdDate;
  const AddonTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.addonType = const Value.absent(),
    this.price = const Value.absent(),
    this.isProduct = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  AddonTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.addonType = const Value.absent(),
    this.price = const Value.absent(),
    this.isProduct = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<AddonTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? addonType,
    Expression<double>? price,
    Expression<bool>? isProduct,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<String>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (addonType != null) 'addon_type': addonType,
      if (price != null) 'price': price,
      if (isProduct != null) 'is_product': isProduct,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  AddonTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? addonType,
    Value<double>? price,
    Value<bool>? isProduct,
    Value<String>? status,
    Value<String>? createdBy,
    Value<String>? createdDate,
  }) {
    return AddonTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      addonType: addonType ?? this.addonType,
      price: price ?? this.price,
      isProduct: isProduct ?? this.isProduct,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (addonType.present) {
      map['addon_type'] = Variable<String>(addonType.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (isProduct.present) {
      map['is_product'] = Variable<bool>(isProduct.value);
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
    return (StringBuffer('AddonTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('addonType: $addonType, ')
          ..write('price: $price, ')
          ..write('isProduct: $isProduct, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $ShiftReportTableTable extends ShiftReportTable
    with TableInfo<$ShiftReportTableTable, ShiftReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<int> pos = GeneratedColumn<int>(
    'pos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<int> shift = GeneratedColumn<int>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashierMeta = const VerificationMeta(
    'cashier',
  );
  @override
  late final GeneratedColumn<String> cashier = GeneratedColumn<String>(
    'cashier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _floatingMeta = const VerificationMeta(
    'floating',
  );
  @override
  late final GeneratedColumn<String> floating = GeneratedColumn<String>(
    'floating',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashFloatMeta = const VerificationMeta(
    'cashFloat',
  );
  @override
  late final GeneratedColumn<double> cashFloat = GeneratedColumn<double>(
    'cash_float',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salesBeginningMeta = const VerificationMeta(
    'salesBeginning',
  );
  @override
  late final GeneratedColumn<double> salesBeginning = GeneratedColumn<double>(
    'sales_beginning',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _salesEndingMeta = const VerificationMeta(
    'salesEnding',
  );
  @override
  late final GeneratedColumn<double> salesEnding = GeneratedColumn<double>(
    'sales_ending',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalSalesMeta = const VerificationMeta(
    'totalSales',
  );
  @override
  late final GeneratedColumn<double> totalSales = GeneratedColumn<double>(
    'total_sales',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _receiptBeginningMeta = const VerificationMeta(
    'receiptBeginning',
  );
  @override
  late final GeneratedColumn<int> receiptBeginning = GeneratedColumn<int>(
    'receipt_beginning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptEndingMeta = const VerificationMeta(
    'receiptEnding',
  );
  @override
  late final GeneratedColumn<int> receiptEnding = GeneratedColumn<int>(
    'receipt_ending',
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
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedDateMeta = const VerificationMeta(
    'approvedDate',
  );
  @override
  late final GeneratedColumn<String> approvedDate = GeneratedColumn<String>(
    'approved_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    pos,
    shift,
    cashier,
    floating,
    cashFloat,
    salesBeginning,
    salesEnding,
    totalSales,
    receiptBeginning,
    receiptEnding,
    status,
    approvedBy,
    approvedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftReportTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    } else if (isInserting) {
      context.missing(_posMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('cashier')) {
      context.handle(
        _cashierMeta,
        cashier.isAcceptableOrUnknown(data['cashier']!, _cashierMeta),
      );
    }
    if (data.containsKey('floating')) {
      context.handle(
        _floatingMeta,
        floating.isAcceptableOrUnknown(data['floating']!, _floatingMeta),
      );
    }
    if (data.containsKey('cash_float')) {
      context.handle(
        _cashFloatMeta,
        cashFloat.isAcceptableOrUnknown(data['cash_float']!, _cashFloatMeta),
      );
    }
    if (data.containsKey('sales_beginning')) {
      context.handle(
        _salesBeginningMeta,
        salesBeginning.isAcceptableOrUnknown(
          data['sales_beginning']!,
          _salesBeginningMeta,
        ),
      );
    }
    if (data.containsKey('sales_ending')) {
      context.handle(
        _salesEndingMeta,
        salesEnding.isAcceptableOrUnknown(
          data['sales_ending']!,
          _salesEndingMeta,
        ),
      );
    }
    if (data.containsKey('total_sales')) {
      context.handle(
        _totalSalesMeta,
        totalSales.isAcceptableOrUnknown(data['total_sales']!, _totalSalesMeta),
      );
    }
    if (data.containsKey('receipt_beginning')) {
      context.handle(
        _receiptBeginningMeta,
        receiptBeginning.isAcceptableOrUnknown(
          data['receipt_beginning']!,
          _receiptBeginningMeta,
        ),
      );
    }
    if (data.containsKey('receipt_ending')) {
      context.handle(
        _receiptEndingMeta,
        receiptEnding.isAcceptableOrUnknown(
          data['receipt_ending']!,
          _receiptEndingMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('approved_date')) {
      context.handle(
        _approvedDateMeta,
        approvedDate.isAcceptableOrUnknown(
          data['approved_date']!,
          _approvedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date, pos, shift},
  ];
  @override
  ShiftReportTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pos'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift'],
      )!,
      cashier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier'],
      )!,
      floating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}floating'],
      ),
      cashFloat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cash_float'],
      ),
      salesBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sales_beginning'],
      )!,
      salesEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sales_ending'],
      )!,
      totalSales: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_sales'],
      )!,
      receiptBeginning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_beginning'],
      )!,
      receiptEnding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_ending'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      approvedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_date'],
      ),
    );
  }

  @override
  $ShiftReportTableTable createAlias(String alias) {
    return $ShiftReportTableTable(attachedDatabase, alias);
  }
}

class ShiftReportTableData extends DataClass
    implements Insertable<ShiftReportTableData> {
  final String id;

  /// `yyyy-MM-dd`.
  final String date;
  final int pos;
  final int shift;
  final String cashier;

  /// Kept as raw text because the server sends null here and its type isn't
  /// pinned down.
  final String? floating;
  final double? cashFloat;
  final double salesBeginning;
  final double salesEnding;
  final double totalSales;
  final int receiptBeginning;
  final int receiptEnding;
  final String status;
  final String? approvedBy;
  final String? approvedDate;
  const ShiftReportTableData({
    required this.id,
    required this.date,
    required this.pos,
    required this.shift,
    required this.cashier,
    this.floating,
    this.cashFloat,
    required this.salesBeginning,
    required this.salesEnding,
    required this.totalSales,
    required this.receiptBeginning,
    required this.receiptEnding,
    required this.status,
    this.approvedBy,
    this.approvedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['pos'] = Variable<int>(pos);
    map['shift'] = Variable<int>(shift);
    map['cashier'] = Variable<String>(cashier);
    if (!nullToAbsent || floating != null) {
      map['floating'] = Variable<String>(floating);
    }
    if (!nullToAbsent || cashFloat != null) {
      map['cash_float'] = Variable<double>(cashFloat);
    }
    map['sales_beginning'] = Variable<double>(salesBeginning);
    map['sales_ending'] = Variable<double>(salesEnding);
    map['total_sales'] = Variable<double>(totalSales);
    map['receipt_beginning'] = Variable<int>(receiptBeginning);
    map['receipt_ending'] = Variable<int>(receiptEnding);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || approvedDate != null) {
      map['approved_date'] = Variable<String>(approvedDate);
    }
    return map;
  }

  ShiftReportTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftReportTableCompanion(
      id: Value(id),
      date: Value(date),
      pos: Value(pos),
      shift: Value(shift),
      cashier: Value(cashier),
      floating: floating == null && nullToAbsent
          ? const Value.absent()
          : Value(floating),
      cashFloat: cashFloat == null && nullToAbsent
          ? const Value.absent()
          : Value(cashFloat),
      salesBeginning: Value(salesBeginning),
      salesEnding: Value(salesEnding),
      totalSales: Value(totalSales),
      receiptBeginning: Value(receiptBeginning),
      receiptEnding: Value(receiptEnding),
      status: Value(status),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedDate: approvedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedDate),
    );
  }

  factory ShiftReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftReportTableData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      pos: serializer.fromJson<int>(json['pos']),
      shift: serializer.fromJson<int>(json['shift']),
      cashier: serializer.fromJson<String>(json['cashier']),
      floating: serializer.fromJson<String?>(json['floating']),
      cashFloat: serializer.fromJson<double?>(json['cashFloat']),
      salesBeginning: serializer.fromJson<double>(json['salesBeginning']),
      salesEnding: serializer.fromJson<double>(json['salesEnding']),
      totalSales: serializer.fromJson<double>(json['totalSales']),
      receiptBeginning: serializer.fromJson<int>(json['receiptBeginning']),
      receiptEnding: serializer.fromJson<int>(json['receiptEnding']),
      status: serializer.fromJson<String>(json['status']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      approvedDate: serializer.fromJson<String?>(json['approvedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'pos': serializer.toJson<int>(pos),
      'shift': serializer.toJson<int>(shift),
      'cashier': serializer.toJson<String>(cashier),
      'floating': serializer.toJson<String?>(floating),
      'cashFloat': serializer.toJson<double?>(cashFloat),
      'salesBeginning': serializer.toJson<double>(salesBeginning),
      'salesEnding': serializer.toJson<double>(salesEnding),
      'totalSales': serializer.toJson<double>(totalSales),
      'receiptBeginning': serializer.toJson<int>(receiptBeginning),
      'receiptEnding': serializer.toJson<int>(receiptEnding),
      'status': serializer.toJson<String>(status),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'approvedDate': serializer.toJson<String?>(approvedDate),
    };
  }

  ShiftReportTableData copyWith({
    String? id,
    String? date,
    int? pos,
    int? shift,
    String? cashier,
    Value<String?> floating = const Value.absent(),
    Value<double?> cashFloat = const Value.absent(),
    double? salesBeginning,
    double? salesEnding,
    double? totalSales,
    int? receiptBeginning,
    int? receiptEnding,
    String? status,
    Value<String?> approvedBy = const Value.absent(),
    Value<String?> approvedDate = const Value.absent(),
  }) => ShiftReportTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    pos: pos ?? this.pos,
    shift: shift ?? this.shift,
    cashier: cashier ?? this.cashier,
    floating: floating.present ? floating.value : this.floating,
    cashFloat: cashFloat.present ? cashFloat.value : this.cashFloat,
    salesBeginning: salesBeginning ?? this.salesBeginning,
    salesEnding: salesEnding ?? this.salesEnding,
    totalSales: totalSales ?? this.totalSales,
    receiptBeginning: receiptBeginning ?? this.receiptBeginning,
    receiptEnding: receiptEnding ?? this.receiptEnding,
    status: status ?? this.status,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    approvedDate: approvedDate.present ? approvedDate.value : this.approvedDate,
  );
  ShiftReportTableData copyWithCompanion(ShiftReportTableCompanion data) {
    return ShiftReportTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      pos: data.pos.present ? data.pos.value : this.pos,
      shift: data.shift.present ? data.shift.value : this.shift,
      cashier: data.cashier.present ? data.cashier.value : this.cashier,
      floating: data.floating.present ? data.floating.value : this.floating,
      cashFloat: data.cashFloat.present ? data.cashFloat.value : this.cashFloat,
      salesBeginning: data.salesBeginning.present
          ? data.salesBeginning.value
          : this.salesBeginning,
      salesEnding: data.salesEnding.present
          ? data.salesEnding.value
          : this.salesEnding,
      totalSales: data.totalSales.present
          ? data.totalSales.value
          : this.totalSales,
      receiptBeginning: data.receiptBeginning.present
          ? data.receiptBeginning.value
          : this.receiptBeginning,
      receiptEnding: data.receiptEnding.present
          ? data.receiptEnding.value
          : this.receiptEnding,
      status: data.status.present ? data.status.value : this.status,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      approvedDate: data.approvedDate.present
          ? data.approvedDate.value
          : this.approvedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftReportTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('pos: $pos, ')
          ..write('shift: $shift, ')
          ..write('cashier: $cashier, ')
          ..write('floating: $floating, ')
          ..write('cashFloat: $cashFloat, ')
          ..write('salesBeginning: $salesBeginning, ')
          ..write('salesEnding: $salesEnding, ')
          ..write('totalSales: $totalSales, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedDate: $approvedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    pos,
    shift,
    cashier,
    floating,
    cashFloat,
    salesBeginning,
    salesEnding,
    totalSales,
    receiptBeginning,
    receiptEnding,
    status,
    approvedBy,
    approvedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftReportTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.pos == this.pos &&
          other.shift == this.shift &&
          other.cashier == this.cashier &&
          other.floating == this.floating &&
          other.cashFloat == this.cashFloat &&
          other.salesBeginning == this.salesBeginning &&
          other.salesEnding == this.salesEnding &&
          other.totalSales == this.totalSales &&
          other.receiptBeginning == this.receiptBeginning &&
          other.receiptEnding == this.receiptEnding &&
          other.status == this.status &&
          other.approvedBy == this.approvedBy &&
          other.approvedDate == this.approvedDate);
}

class ShiftReportTableCompanion extends UpdateCompanion<ShiftReportTableData> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> pos;
  final Value<int> shift;
  final Value<String> cashier;
  final Value<String?> floating;
  final Value<double?> cashFloat;
  final Value<double> salesBeginning;
  final Value<double> salesEnding;
  final Value<double> totalSales;
  final Value<int> receiptBeginning;
  final Value<int> receiptEnding;
  final Value<String> status;
  final Value<String?> approvedBy;
  final Value<String?> approvedDate;
  final Value<int> rowid;
  const ShiftReportTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.pos = const Value.absent(),
    this.shift = const Value.absent(),
    this.cashier = const Value.absent(),
    this.floating = const Value.absent(),
    this.cashFloat = const Value.absent(),
    this.salesBeginning = const Value.absent(),
    this.salesEnding = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftReportTableCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int pos,
    required int shift,
    this.cashier = const Value.absent(),
    this.floating = const Value.absent(),
    this.cashFloat = const Value.absent(),
    this.salesBeginning = const Value.absent(),
    this.salesEnding = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.receiptBeginning = const Value.absent(),
    this.receiptEnding = const Value.absent(),
    this.status = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       pos = Value(pos),
       shift = Value(shift);
  static Insertable<ShiftReportTableData> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? pos,
    Expression<int>? shift,
    Expression<String>? cashier,
    Expression<String>? floating,
    Expression<double>? cashFloat,
    Expression<double>? salesBeginning,
    Expression<double>? salesEnding,
    Expression<double>? totalSales,
    Expression<int>? receiptBeginning,
    Expression<int>? receiptEnding,
    Expression<String>? status,
    Expression<String>? approvedBy,
    Expression<String>? approvedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (pos != null) 'pos': pos,
      if (shift != null) 'shift': shift,
      if (cashier != null) 'cashier': cashier,
      if (floating != null) 'floating': floating,
      if (cashFloat != null) 'cash_float': cashFloat,
      if (salesBeginning != null) 'sales_beginning': salesBeginning,
      if (salesEnding != null) 'sales_ending': salesEnding,
      if (totalSales != null) 'total_sales': totalSales,
      if (receiptBeginning != null) 'receipt_beginning': receiptBeginning,
      if (receiptEnding != null) 'receipt_ending': receiptEnding,
      if (status != null) 'status': status,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedDate != null) 'approved_date': approvedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? pos,
    Value<int>? shift,
    Value<String>? cashier,
    Value<String?>? floating,
    Value<double?>? cashFloat,
    Value<double>? salesBeginning,
    Value<double>? salesEnding,
    Value<double>? totalSales,
    Value<int>? receiptBeginning,
    Value<int>? receiptEnding,
    Value<String>? status,
    Value<String?>? approvedBy,
    Value<String?>? approvedDate,
    Value<int>? rowid,
  }) {
    return ShiftReportTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      pos: pos ?? this.pos,
      shift: shift ?? this.shift,
      cashier: cashier ?? this.cashier,
      floating: floating ?? this.floating,
      cashFloat: cashFloat ?? this.cashFloat,
      salesBeginning: salesBeginning ?? this.salesBeginning,
      salesEnding: salesEnding ?? this.salesEnding,
      totalSales: totalSales ?? this.totalSales,
      receiptBeginning: receiptBeginning ?? this.receiptBeginning,
      receiptEnding: receiptEnding ?? this.receiptEnding,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (pos.present) {
      map['pos'] = Variable<int>(pos.value);
    }
    if (shift.present) {
      map['shift'] = Variable<int>(shift.value);
    }
    if (cashier.present) {
      map['cashier'] = Variable<String>(cashier.value);
    }
    if (floating.present) {
      map['floating'] = Variable<String>(floating.value);
    }
    if (cashFloat.present) {
      map['cash_float'] = Variable<double>(cashFloat.value);
    }
    if (salesBeginning.present) {
      map['sales_beginning'] = Variable<double>(salesBeginning.value);
    }
    if (salesEnding.present) {
      map['sales_ending'] = Variable<double>(salesEnding.value);
    }
    if (totalSales.present) {
      map['total_sales'] = Variable<double>(totalSales.value);
    }
    if (receiptBeginning.present) {
      map['receipt_beginning'] = Variable<int>(receiptBeginning.value);
    }
    if (receiptEnding.present) {
      map['receipt_ending'] = Variable<int>(receiptEnding.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (approvedDate.present) {
      map['approved_date'] = Variable<String>(approvedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftReportTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('pos: $pos, ')
          ..write('shift: $shift, ')
          ..write('cashier: $cashier, ')
          ..write('floating: $floating, ')
          ..write('cashFloat: $cashFloat, ')
          ..write('salesBeginning: $salesBeginning, ')
          ..write('salesEnding: $salesEnding, ')
          ..write('totalSales: $totalSales, ')
          ..write('receiptBeginning: $receiptBeginning, ')
          ..write('receiptEnding: $receiptEnding, ')
          ..write('status: $status, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedDate: $approvedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceiptHistoryTableTable extends ReceiptHistoryTable
    with TableInfo<$ReceiptHistoryTableTable, ReceiptHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _detailIdMeta = const VerificationMeta(
    'detailId',
  );
  @override
  late final GeneratedColumn<String> detailId = GeneratedColumn<String>(
    'detail_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<int> posId = GeneratedColumn<int>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<int> shift = GeneratedColumn<int>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptDateMeta = const VerificationMeta(
    'receiptDate',
  );
  @override
  late final GeneratedColumn<String> receiptDate = GeneratedColumn<String>(
    'receipt_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cashierMeta = const VerificationMeta(
    'cashier',
  );
  @override
  late final GeneratedColumn<String> cashier = GeneratedColumn<String>(
    'cashier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ePaymentTypeMeta = const VerificationMeta(
    'ePaymentType',
  );
  @override
  late final GeneratedColumn<String> ePaymentType = GeneratedColumn<String>(
    'e_payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tendersJsonMeta = const VerificationMeta(
    'tendersJson',
  );
  @override
  late final GeneratedColumn<String> tendersJson = GeneratedColumn<String>(
    'tenders_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    detailId,
    posId,
    shift,
    receiptDate,
    createdAt,
    paymentType,
    description,
    total,
    cashier,
    status,
    ePaymentType,
    referenceId,
    tendersJson,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipt_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceiptHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('detail_id')) {
      context.handle(
        _detailIdMeta,
        detailId.isAcceptableOrUnknown(data['detail_id']!, _detailIdMeta),
      );
    } else if (isInserting) {
      context.missing(_detailIdMeta);
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    } else if (isInserting) {
      context.missing(_posIdMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    }
    if (data.containsKey('receipt_date')) {
      context.handle(
        _receiptDateMeta,
        receiptDate.isAcceptableOrUnknown(
          data['receipt_date']!,
          _receiptDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
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
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('cashier')) {
      context.handle(
        _cashierMeta,
        cashier.isAcceptableOrUnknown(data['cashier']!, _cashierMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('e_payment_type')) {
      context.handle(
        _ePaymentTypeMeta,
        ePaymentType.isAcceptableOrUnknown(
          data['e_payment_type']!,
          _ePaymentTypeMeta,
        ),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('tenders_json')) {
      context.handle(
        _tendersJsonMeta,
        tendersJson.isAcceptableOrUnknown(
          data['tenders_json']!,
          _tendersJsonMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {detailId, posId},
  ];
  @override
  ReceiptHistoryTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      detailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pos_id'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift'],
      )!,
      receiptDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      cashier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      ePaymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}e_payment_type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      tendersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenders_json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $ReceiptHistoryTableTable createAlias(String alias) {
    return $ReceiptHistoryTableTable(attachedDatabase, alias);
  }
}

class ReceiptHistoryTableData extends DataClass
    implements Insertable<ReceiptHistoryTableData> {
  final String id;
  final String detailId;
  final int posId;
  final int shift;

  /// `yyyy-MM-dd`, for looking a day up directly.
  final String receiptDate;
  final DateTime createdAt;
  final String paymentType;

  /// Raw JSON array of the receipt's items.
  final String description;
  final double total;
  final String cashier;
  final String status;
  final String ePaymentType;
  final String referenceId;

  /// JSON array of `{type, amount}`, one per payment taken.
  final String tendersJson;

  /// When this copy was pulled; the cache is pruned by this.
  final DateTime fetchedAt;
  const ReceiptHistoryTableData({
    required this.id,
    required this.detailId,
    required this.posId,
    required this.shift,
    required this.receiptDate,
    required this.createdAt,
    required this.paymentType,
    required this.description,
    required this.total,
    required this.cashier,
    required this.status,
    required this.ePaymentType,
    required this.referenceId,
    required this.tendersJson,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['detail_id'] = Variable<String>(detailId);
    map['pos_id'] = Variable<int>(posId);
    map['shift'] = Variable<int>(shift);
    map['receipt_date'] = Variable<String>(receiptDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['payment_type'] = Variable<String>(paymentType);
    map['description'] = Variable<String>(description);
    map['total'] = Variable<double>(total);
    map['cashier'] = Variable<String>(cashier);
    map['status'] = Variable<String>(status);
    map['e_payment_type'] = Variable<String>(ePaymentType);
    map['reference_id'] = Variable<String>(referenceId);
    map['tenders_json'] = Variable<String>(tendersJson);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  ReceiptHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return ReceiptHistoryTableCompanion(
      id: Value(id),
      detailId: Value(detailId),
      posId: Value(posId),
      shift: Value(shift),
      receiptDate: Value(receiptDate),
      createdAt: Value(createdAt),
      paymentType: Value(paymentType),
      description: Value(description),
      total: Value(total),
      cashier: Value(cashier),
      status: Value(status),
      ePaymentType: Value(ePaymentType),
      referenceId: Value(referenceId),
      tendersJson: Value(tendersJson),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory ReceiptHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      detailId: serializer.fromJson<String>(json['detailId']),
      posId: serializer.fromJson<int>(json['posId']),
      shift: serializer.fromJson<int>(json['shift']),
      receiptDate: serializer.fromJson<String>(json['receiptDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      description: serializer.fromJson<String>(json['description']),
      total: serializer.fromJson<double>(json['total']),
      cashier: serializer.fromJson<String>(json['cashier']),
      status: serializer.fromJson<String>(json['status']),
      ePaymentType: serializer.fromJson<String>(json['ePaymentType']),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      tendersJson: serializer.fromJson<String>(json['tendersJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'detailId': serializer.toJson<String>(detailId),
      'posId': serializer.toJson<int>(posId),
      'shift': serializer.toJson<int>(shift),
      'receiptDate': serializer.toJson<String>(receiptDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paymentType': serializer.toJson<String>(paymentType),
      'description': serializer.toJson<String>(description),
      'total': serializer.toJson<double>(total),
      'cashier': serializer.toJson<String>(cashier),
      'status': serializer.toJson<String>(status),
      'ePaymentType': serializer.toJson<String>(ePaymentType),
      'referenceId': serializer.toJson<String>(referenceId),
      'tendersJson': serializer.toJson<String>(tendersJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  ReceiptHistoryTableData copyWith({
    String? id,
    String? detailId,
    int? posId,
    int? shift,
    String? receiptDate,
    DateTime? createdAt,
    String? paymentType,
    String? description,
    double? total,
    String? cashier,
    String? status,
    String? ePaymentType,
    String? referenceId,
    String? tendersJson,
    DateTime? fetchedAt,
  }) => ReceiptHistoryTableData(
    id: id ?? this.id,
    detailId: detailId ?? this.detailId,
    posId: posId ?? this.posId,
    shift: shift ?? this.shift,
    receiptDate: receiptDate ?? this.receiptDate,
    createdAt: createdAt ?? this.createdAt,
    paymentType: paymentType ?? this.paymentType,
    description: description ?? this.description,
    total: total ?? this.total,
    cashier: cashier ?? this.cashier,
    status: status ?? this.status,
    ePaymentType: ePaymentType ?? this.ePaymentType,
    referenceId: referenceId ?? this.referenceId,
    tendersJson: tendersJson ?? this.tendersJson,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  ReceiptHistoryTableData copyWithCompanion(ReceiptHistoryTableCompanion data) {
    return ReceiptHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      detailId: data.detailId.present ? data.detailId.value : this.detailId,
      posId: data.posId.present ? data.posId.value : this.posId,
      shift: data.shift.present ? data.shift.value : this.shift,
      receiptDate: data.receiptDate.present
          ? data.receiptDate.value
          : this.receiptDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      description: data.description.present
          ? data.description.value
          : this.description,
      total: data.total.present ? data.total.value : this.total,
      cashier: data.cashier.present ? data.cashier.value : this.cashier,
      status: data.status.present ? data.status.value : this.status,
      ePaymentType: data.ePaymentType.present
          ? data.ePaymentType.value
          : this.ePaymentType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      tendersJson: data.tendersJson.present
          ? data.tendersJson.value
          : this.tendersJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptHistoryTableData(')
          ..write('id: $id, ')
          ..write('detailId: $detailId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('receiptDate: $receiptDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('paymentType: $paymentType, ')
          ..write('description: $description, ')
          ..write('total: $total, ')
          ..write('cashier: $cashier, ')
          ..write('status: $status, ')
          ..write('ePaymentType: $ePaymentType, ')
          ..write('referenceId: $referenceId, ')
          ..write('tendersJson: $tendersJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    detailId,
    posId,
    shift,
    receiptDate,
    createdAt,
    paymentType,
    description,
    total,
    cashier,
    status,
    ePaymentType,
    referenceId,
    tendersJson,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptHistoryTableData &&
          other.id == this.id &&
          other.detailId == this.detailId &&
          other.posId == this.posId &&
          other.shift == this.shift &&
          other.receiptDate == this.receiptDate &&
          other.createdAt == this.createdAt &&
          other.paymentType == this.paymentType &&
          other.description == this.description &&
          other.total == this.total &&
          other.cashier == this.cashier &&
          other.status == this.status &&
          other.ePaymentType == this.ePaymentType &&
          other.referenceId == this.referenceId &&
          other.tendersJson == this.tendersJson &&
          other.fetchedAt == this.fetchedAt);
}

class ReceiptHistoryTableCompanion
    extends UpdateCompanion<ReceiptHistoryTableData> {
  final Value<String> id;
  final Value<String> detailId;
  final Value<int> posId;
  final Value<int> shift;
  final Value<String> receiptDate;
  final Value<DateTime> createdAt;
  final Value<String> paymentType;
  final Value<String> description;
  final Value<double> total;
  final Value<String> cashier;
  final Value<String> status;
  final Value<String> ePaymentType;
  final Value<String> referenceId;
  final Value<String> tendersJson;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const ReceiptHistoryTableCompanion({
    this.id = const Value.absent(),
    this.detailId = const Value.absent(),
    this.posId = const Value.absent(),
    this.shift = const Value.absent(),
    this.receiptDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.description = const Value.absent(),
    this.total = const Value.absent(),
    this.cashier = const Value.absent(),
    this.status = const Value.absent(),
    this.ePaymentType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.tendersJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String detailId,
    required int posId,
    this.shift = const Value.absent(),
    required String receiptDate,
    required DateTime createdAt,
    this.paymentType = const Value.absent(),
    this.description = const Value.absent(),
    this.total = const Value.absent(),
    this.cashier = const Value.absent(),
    this.status = const Value.absent(),
    this.ePaymentType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.tendersJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : detailId = Value(detailId),
       posId = Value(posId),
       receiptDate = Value(receiptDate),
       createdAt = Value(createdAt);
  static Insertable<ReceiptHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? detailId,
    Expression<int>? posId,
    Expression<int>? shift,
    Expression<String>? receiptDate,
    Expression<DateTime>? createdAt,
    Expression<String>? paymentType,
    Expression<String>? description,
    Expression<double>? total,
    Expression<String>? cashier,
    Expression<String>? status,
    Expression<String>? ePaymentType,
    Expression<String>? referenceId,
    Expression<String>? tendersJson,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detailId != null) 'detail_id': detailId,
      if (posId != null) 'pos_id': posId,
      if (shift != null) 'shift': shift,
      if (receiptDate != null) 'receipt_date': receiptDate,
      if (createdAt != null) 'created_at': createdAt,
      if (paymentType != null) 'payment_type': paymentType,
      if (description != null) 'description': description,
      if (total != null) 'total': total,
      if (cashier != null) 'cashier': cashier,
      if (status != null) 'status': status,
      if (ePaymentType != null) 'e_payment_type': ePaymentType,
      if (referenceId != null) 'reference_id': referenceId,
      if (tendersJson != null) 'tenders_json': tendersJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? detailId,
    Value<int>? posId,
    Value<int>? shift,
    Value<String>? receiptDate,
    Value<DateTime>? createdAt,
    Value<String>? paymentType,
    Value<String>? description,
    Value<double>? total,
    Value<String>? cashier,
    Value<String>? status,
    Value<String>? ePaymentType,
    Value<String>? referenceId,
    Value<String>? tendersJson,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return ReceiptHistoryTableCompanion(
      id: id ?? this.id,
      detailId: detailId ?? this.detailId,
      posId: posId ?? this.posId,
      shift: shift ?? this.shift,
      receiptDate: receiptDate ?? this.receiptDate,
      createdAt: createdAt ?? this.createdAt,
      paymentType: paymentType ?? this.paymentType,
      description: description ?? this.description,
      total: total ?? this.total,
      cashier: cashier ?? this.cashier,
      status: status ?? this.status,
      ePaymentType: ePaymentType ?? this.ePaymentType,
      referenceId: referenceId ?? this.referenceId,
      tendersJson: tendersJson ?? this.tendersJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (detailId.present) {
      map['detail_id'] = Variable<String>(detailId.value);
    }
    if (posId.present) {
      map['pos_id'] = Variable<int>(posId.value);
    }
    if (shift.present) {
      map['shift'] = Variable<int>(shift.value);
    }
    if (receiptDate.present) {
      map['receipt_date'] = Variable<String>(receiptDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (cashier.present) {
      map['cashier'] = Variable<String>(cashier.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (ePaymentType.present) {
      map['e_payment_type'] = Variable<String>(ePaymentType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (tendersJson.present) {
      map['tenders_json'] = Variable<String>(tendersJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('detailId: $detailId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('receiptDate: $receiptDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('paymentType: $paymentType, ')
          ..write('description: $description, ')
          ..write('total: $total, ')
          ..write('cashier: $cashier, ')
          ..write('status: $status, ')
          ..write('ePaymentType: $ePaymentType, ')
          ..write('referenceId: $referenceId, ')
          ..write('tendersJson: $tendersJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashDropTableTable extends CashDropTable
    with TableInfo<$CashDropTableTable, CashDropTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashDropTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<String> posId = GeneratedColumn<String>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<String> shift = GeneratedColumn<String>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftDateMeta = const VerificationMeta(
    'shiftDate',
  );
  @override
  late final GeneratedColumn<String> shiftDate = GeneratedColumn<String>(
    'shift_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashierNameMeta = const VerificationMeta(
    'cashierName',
  );
  @override
  late final GeneratedColumn<String> cashierName = GeneratedColumn<String>(
    'cashier_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linesJsonMeta = const VerificationMeta(
    'linesJson',
  );
  @override
  late final GeneratedColumn<String> linesJson = GeneratedColumn<String>(
    'lines_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    posId,
    shift,
    shiftDate,
    cashierId,
    cashierName,
    amount,
    linesJson,
    createdAt,
    syncStatus,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_drop_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashDropTableData> instance, {
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
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    } else if (isInserting) {
      context.missing(_posIdMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('shift_date')) {
      context.handle(
        _shiftDateMeta,
        shiftDate.isAcceptableOrUnknown(data['shift_date']!, _shiftDateMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftDateMeta);
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('cashier_name')) {
      context.handle(
        _cashierNameMeta,
        cashierName.isAcceptableOrUnknown(
          data['cashier_name']!,
          _cashierNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cashierNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('lines_json')) {
      context.handle(
        _linesJsonMeta,
        linesJson.isAcceptableOrUnknown(data['lines_json']!, _linesJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashDropTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashDropTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_id'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      shiftDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_date'],
      )!,
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      )!,
      cashierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      linesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lines_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CashDropTableTable createAlias(String alias) {
    return $CashDropTableTable(attachedDatabase, alias);
  }
}

class CashDropTableData extends DataClass
    implements Insertable<CashDropTableData> {
  /// Generated here, so the same drop can later be sent to the server safely.
  final String id;
  final String branchId;
  final String posId;
  final String shift;

  /// The shift's business date, `yyyy-MM-dd`.
  final String shiftDate;

  /// Employee id of the cashier (what the server keys on).
  final String cashierId;
  final String cashierName;
  final double amount;

  /// JSON array of `{id, label, value, quantity}`, only the denominations that
  /// were actually dropped.
  final String linesJson;
  final DateTime createdAt;

  /// PENDING until the server has acknowledged it, then SYNCED.
  final String syncStatus;
  final DateTime? syncedAt;
  const CashDropTableData({
    required this.id,
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.cashierId,
    required this.cashierName,
    required this.amount,
    required this.linesJson,
    required this.createdAt,
    required this.syncStatus,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['pos_id'] = Variable<String>(posId);
    map['shift'] = Variable<String>(shift);
    map['shift_date'] = Variable<String>(shiftDate);
    map['cashier_id'] = Variable<String>(cashierId);
    map['cashier_name'] = Variable<String>(cashierName);
    map['amount'] = Variable<double>(amount);
    map['lines_json'] = Variable<String>(linesJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CashDropTableCompanion toCompanion(bool nullToAbsent) {
    return CashDropTableCompanion(
      id: Value(id),
      branchId: Value(branchId),
      posId: Value(posId),
      shift: Value(shift),
      shiftDate: Value(shiftDate),
      cashierId: Value(cashierId),
      cashierName: Value(cashierName),
      amount: Value(amount),
      linesJson: Value(linesJson),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CashDropTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashDropTableData(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      posId: serializer.fromJson<String>(json['posId']),
      shift: serializer.fromJson<String>(json['shift']),
      shiftDate: serializer.fromJson<String>(json['shiftDate']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      cashierName: serializer.fromJson<String>(json['cashierName']),
      amount: serializer.fromJson<double>(json['amount']),
      linesJson: serializer.fromJson<String>(json['linesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'posId': serializer.toJson<String>(posId),
      'shift': serializer.toJson<String>(shift),
      'shiftDate': serializer.toJson<String>(shiftDate),
      'cashierId': serializer.toJson<String>(cashierId),
      'cashierName': serializer.toJson<String>(cashierName),
      'amount': serializer.toJson<double>(amount),
      'linesJson': serializer.toJson<String>(linesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CashDropTableData copyWith({
    String? id,
    String? branchId,
    String? posId,
    String? shift,
    String? shiftDate,
    String? cashierId,
    String? cashierName,
    double? amount,
    String? linesJson,
    DateTime? createdAt,
    String? syncStatus,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CashDropTableData(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    posId: posId ?? this.posId,
    shift: shift ?? this.shift,
    shiftDate: shiftDate ?? this.shiftDate,
    cashierId: cashierId ?? this.cashierId,
    cashierName: cashierName ?? this.cashierName,
    amount: amount ?? this.amount,
    linesJson: linesJson ?? this.linesJson,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CashDropTableData copyWithCompanion(CashDropTableCompanion data) {
    return CashDropTableData(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      posId: data.posId.present ? data.posId.value : this.posId,
      shift: data.shift.present ? data.shift.value : this.shift,
      shiftDate: data.shiftDate.present ? data.shiftDate.value : this.shiftDate,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      cashierName: data.cashierName.present
          ? data.cashierName.value
          : this.cashierName,
      amount: data.amount.present ? data.amount.value : this.amount,
      linesJson: data.linesJson.present ? data.linesJson.value : this.linesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashDropTableData(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('cashierId: $cashierId, ')
          ..write('cashierName: $cashierName, ')
          ..write('amount: $amount, ')
          ..write('linesJson: $linesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    posId,
    shift,
    shiftDate,
    cashierId,
    cashierName,
    amount,
    linesJson,
    createdAt,
    syncStatus,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashDropTableData &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.posId == this.posId &&
          other.shift == this.shift &&
          other.shiftDate == this.shiftDate &&
          other.cashierId == this.cashierId &&
          other.cashierName == this.cashierName &&
          other.amount == this.amount &&
          other.linesJson == this.linesJson &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class CashDropTableCompanion extends UpdateCompanion<CashDropTableData> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> posId;
  final Value<String> shift;
  final Value<String> shiftDate;
  final Value<String> cashierId;
  final Value<String> cashierName;
  final Value<double> amount;
  final Value<String> linesJson;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CashDropTableCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.posId = const Value.absent(),
    this.shift = const Value.absent(),
    this.shiftDate = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.cashierName = const Value.absent(),
    this.amount = const Value.absent(),
    this.linesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashDropTableCompanion.insert({
    this.id = const Value.absent(),
    required String branchId,
    required String posId,
    required String shift,
    required String shiftDate,
    required String cashierId,
    required String cashierName,
    required double amount,
    this.linesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : branchId = Value(branchId),
       posId = Value(posId),
       shift = Value(shift),
       shiftDate = Value(shiftDate),
       cashierId = Value(cashierId),
       cashierName = Value(cashierName),
       amount = Value(amount);
  static Insertable<CashDropTableData> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? posId,
    Expression<String>? shift,
    Expression<String>? shiftDate,
    Expression<String>? cashierId,
    Expression<String>? cashierName,
    Expression<double>? amount,
    Expression<String>? linesJson,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (posId != null) 'pos_id': posId,
      if (shift != null) 'shift': shift,
      if (shiftDate != null) 'shift_date': shiftDate,
      if (cashierId != null) 'cashier_id': cashierId,
      if (cashierName != null) 'cashier_name': cashierName,
      if (amount != null) 'amount': amount,
      if (linesJson != null) 'lines_json': linesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashDropTableCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? posId,
    Value<String>? shift,
    Value<String>? shiftDate,
    Value<String>? cashierId,
    Value<String>? cashierName,
    Value<double>? amount,
    Value<String>? linesJson,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CashDropTableCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      posId: posId ?? this.posId,
      shift: shift ?? this.shift,
      shiftDate: shiftDate ?? this.shiftDate,
      cashierId: cashierId ?? this.cashierId,
      cashierName: cashierName ?? this.cashierName,
      amount: amount ?? this.amount,
      linesJson: linesJson ?? this.linesJson,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
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
    if (posId.present) {
      map['pos_id'] = Variable<String>(posId.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (shiftDate.present) {
      map['shift_date'] = Variable<String>(shiftDate.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (cashierName.present) {
      map['cashier_name'] = Variable<String>(cashierName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (linesJson.present) {
      map['lines_json'] = Variable<String>(linesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashDropTableCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('cashierId: $cashierId, ')
          ..write('cashierName: $cashierName, ')
          ..write('amount: $amount, ')
          ..write('linesJson: $linesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SendCashReportTableTable extends SendCashReportTable
    with TableInfo<$SendCashReportTableTable, SendCashReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SendCashReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<String> posId = GeneratedColumn<String>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<String> shift = GeneratedColumn<String>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftDateMeta = const VerificationMeta(
    'shiftDate',
  );
  @override
  late final GeneratedColumn<String> shiftDate = GeneratedColumn<String>(
    'shift_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linesJsonMeta = const VerificationMeta(
    'linesJson',
  );
  @override
  late final GeneratedColumn<String> linesJson = GeneratedColumn<String>(
    'lines_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    posId,
    shift,
    shiftDate,
    cashierId,
    amount,
    linesJson,
    createdAt,
    syncStatus,
    syncedAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'send_cash_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SendCashReportTableData> instance, {
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
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    } else if (isInserting) {
      context.missing(_posIdMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('shift_date')) {
      context.handle(
        _shiftDateMeta,
        shiftDate.isAcceptableOrUnknown(data['shift_date']!, _shiftDateMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftDateMeta);
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('lines_json')) {
      context.handle(
        _linesJsonMeta,
        linesJson.isAcceptableOrUnknown(data['lines_json']!, _linesJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {branchId, posId, shiftDate, shift},
  ];
  @override
  SendCashReportTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SendCashReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_id'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      shiftDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_date'],
      )!,
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      linesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lines_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SendCashReportTableTable createAlias(String alias) {
    return $SendCashReportTableTable(attachedDatabase, alias);
  }
}

class SendCashReportTableData extends DataClass
    implements Insertable<SendCashReportTableData> {
  final String id;
  final String branchId;
  final String posId;
  final String shift;

  /// `yyyy-MM-dd`.
  final String shiftDate;

  /// Employee id of the cashier (what the server expects as `cashier`).
  final String cashierId;
  final double amount;

  /// JSON array of `{id, value, quantity}` for every active denomination,
  /// including ones counted as zero.
  final String linesJson;
  final DateTime createdAt;

  /// PENDING until the server has accepted it, then SYNCED.
  final String syncStatus;
  final DateTime? syncedAt;

  /// How many sends have failed, and why the last one did.
  final int attempts;
  final String? lastError;
  const SendCashReportTableData({
    required this.id,
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.cashierId,
    required this.amount,
    required this.linesJson,
    required this.createdAt,
    required this.syncStatus,
    this.syncedAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['pos_id'] = Variable<String>(posId);
    map['shift'] = Variable<String>(shift);
    map['shift_date'] = Variable<String>(shiftDate);
    map['cashier_id'] = Variable<String>(cashierId);
    map['amount'] = Variable<double>(amount);
    map['lines_json'] = Variable<String>(linesJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SendCashReportTableCompanion toCompanion(bool nullToAbsent) {
    return SendCashReportTableCompanion(
      id: Value(id),
      branchId: Value(branchId),
      posId: Value(posId),
      shift: Value(shift),
      shiftDate: Value(shiftDate),
      cashierId: Value(cashierId),
      amount: Value(amount),
      linesJson: Value(linesJson),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SendCashReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SendCashReportTableData(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      posId: serializer.fromJson<String>(json['posId']),
      shift: serializer.fromJson<String>(json['shift']),
      shiftDate: serializer.fromJson<String>(json['shiftDate']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      amount: serializer.fromJson<double>(json['amount']),
      linesJson: serializer.fromJson<String>(json['linesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'posId': serializer.toJson<String>(posId),
      'shift': serializer.toJson<String>(shift),
      'shiftDate': serializer.toJson<String>(shiftDate),
      'cashierId': serializer.toJson<String>(cashierId),
      'amount': serializer.toJson<double>(amount),
      'linesJson': serializer.toJson<String>(linesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SendCashReportTableData copyWith({
    String? id,
    String? branchId,
    String? posId,
    String? shift,
    String? shiftDate,
    String? cashierId,
    double? amount,
    String? linesJson,
    DateTime? createdAt,
    String? syncStatus,
    Value<DateTime?> syncedAt = const Value.absent(),
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => SendCashReportTableData(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    posId: posId ?? this.posId,
    shift: shift ?? this.shift,
    shiftDate: shiftDate ?? this.shiftDate,
    cashierId: cashierId ?? this.cashierId,
    amount: amount ?? this.amount,
    linesJson: linesJson ?? this.linesJson,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SendCashReportTableData copyWithCompanion(SendCashReportTableCompanion data) {
    return SendCashReportTableData(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      posId: data.posId.present ? data.posId.value : this.posId,
      shift: data.shift.present ? data.shift.value : this.shift,
      shiftDate: data.shiftDate.present ? data.shiftDate.value : this.shiftDate,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      amount: data.amount.present ? data.amount.value : this.amount,
      linesJson: data.linesJson.present ? data.linesJson.value : this.linesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SendCashReportTableData(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('cashierId: $cashierId, ')
          ..write('amount: $amount, ')
          ..write('linesJson: $linesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    posId,
    shift,
    shiftDate,
    cashierId,
    amount,
    linesJson,
    createdAt,
    syncStatus,
    syncedAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SendCashReportTableData &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.posId == this.posId &&
          other.shift == this.shift &&
          other.shiftDate == this.shiftDate &&
          other.cashierId == this.cashierId &&
          other.amount == this.amount &&
          other.linesJson == this.linesJson &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class SendCashReportTableCompanion
    extends UpdateCompanion<SendCashReportTableData> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> posId;
  final Value<String> shift;
  final Value<String> shiftDate;
  final Value<String> cashierId;
  final Value<double> amount;
  final Value<String> linesJson;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SendCashReportTableCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.posId = const Value.absent(),
    this.shift = const Value.absent(),
    this.shiftDate = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.amount = const Value.absent(),
    this.linesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SendCashReportTableCompanion.insert({
    this.id = const Value.absent(),
    required String branchId,
    required String posId,
    required String shift,
    required String shiftDate,
    required String cashierId,
    required double amount,
    this.linesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : branchId = Value(branchId),
       posId = Value(posId),
       shift = Value(shift),
       shiftDate = Value(shiftDate),
       cashierId = Value(cashierId),
       amount = Value(amount);
  static Insertable<SendCashReportTableData> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? posId,
    Expression<String>? shift,
    Expression<String>? shiftDate,
    Expression<String>? cashierId,
    Expression<double>? amount,
    Expression<String>? linesJson,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (posId != null) 'pos_id': posId,
      if (shift != null) 'shift': shift,
      if (shiftDate != null) 'shift_date': shiftDate,
      if (cashierId != null) 'cashier_id': cashierId,
      if (amount != null) 'amount': amount,
      if (linesJson != null) 'lines_json': linesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SendCashReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? posId,
    Value<String>? shift,
    Value<String>? shiftDate,
    Value<String>? cashierId,
    Value<double>? amount,
    Value<String>? linesJson,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<DateTime?>? syncedAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SendCashReportTableCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      posId: posId ?? this.posId,
      shift: shift ?? this.shift,
      shiftDate: shiftDate ?? this.shiftDate,
      cashierId: cashierId ?? this.cashierId,
      amount: amount ?? this.amount,
      linesJson: linesJson ?? this.linesJson,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
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
    if (posId.present) {
      map['pos_id'] = Variable<String>(posId.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (shiftDate.present) {
      map['shift_date'] = Variable<String>(shiftDate.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (linesJson.present) {
      map['lines_json'] = Variable<String>(linesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SendCashReportTableCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('cashierId: $cashierId, ')
          ..write('amount: $amount, ')
          ..write('linesJson: $linesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashReportTableTable extends CashReportTable
    with TableInfo<$CashReportTableTable, CashReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<String> posId = GeneratedColumn<String>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<int> shift = GeneratedColumn<int>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftDateMeta = const VerificationMeta(
    'shiftDate',
  );
  @override
  late final GeneratedColumn<String> shiftDate = GeneratedColumn<String>(
    'shift_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashFloatMeta = const VerificationMeta(
    'cashFloat',
  );
  @override
  late final GeneratedColumn<double> cashFloat = GeneratedColumn<double>(
    'cash_float',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalCashMeta = const VerificationMeta(
    'totalCash',
  );
  @override
  late final GeneratedColumn<double> totalCash = GeneratedColumn<double>(
    'total_cash',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _denominationJsonMeta = const VerificationMeta(
    'denominationJson',
  );
  @override
  late final GeneratedColumn<String> denominationJson = GeneratedColumn<String>(
    'denomination_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    posId,
    shift,
    shiftDate,
    cashFloat,
    totalCash,
    denominationJson,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_report_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashReportTableData> instance, {
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
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    } else if (isInserting) {
      context.missing(_posIdMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('shift_date')) {
      context.handle(
        _shiftDateMeta,
        shiftDate.isAcceptableOrUnknown(data['shift_date']!, _shiftDateMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftDateMeta);
    }
    if (data.containsKey('cash_float')) {
      context.handle(
        _cashFloatMeta,
        cashFloat.isAcceptableOrUnknown(data['cash_float']!, _cashFloatMeta),
      );
    }
    if (data.containsKey('total_cash')) {
      context.handle(
        _totalCashMeta,
        totalCash.isAcceptableOrUnknown(data['total_cash']!, _totalCashMeta),
      );
    }
    if (data.containsKey('denomination_json')) {
      context.handle(
        _denominationJsonMeta,
        denominationJson.isAcceptableOrUnknown(
          data['denomination_json']!,
          _denominationJsonMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {branchId, posId, shiftDate, shift},
  ];
  @override
  CashReportTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashReportTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_id'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift'],
      )!,
      shiftDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_date'],
      )!,
      cashFloat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cash_float'],
      )!,
      totalCash: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cash'],
      )!,
      denominationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}denomination_json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CashReportTableTable createAlias(String alias) {
    return $CashReportTableTable(attachedDatabase, alias);
  }
}

class CashReportTableData extends DataClass
    implements Insertable<CashReportTableData> {
  final String id;
  final String branchId;
  final String posId;
  final int shift;

  /// `yyyy-MM-dd`.
  final String shiftDate;
  final double cashFloat;
  final double totalCash;

  /// JSON array of `{id, value, quantity}` for every active denomination,
  /// including ones counted as zero.
  final String denominationJson;

  /// When this copy was pulled.
  final DateTime fetchedAt;
  const CashReportTableData({
    required this.id,
    required this.branchId,
    required this.posId,
    required this.shift,
    required this.shiftDate,
    required this.cashFloat,
    required this.totalCash,
    required this.denominationJson,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['pos_id'] = Variable<String>(posId);
    map['shift'] = Variable<int>(shift);
    map['shift_date'] = Variable<String>(shiftDate);
    map['cash_float'] = Variable<double>(cashFloat);
    map['total_cash'] = Variable<double>(totalCash);
    map['denomination_json'] = Variable<String>(denominationJson);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CashReportTableCompanion toCompanion(bool nullToAbsent) {
    return CashReportTableCompanion(
      id: Value(id),
      branchId: Value(branchId),
      posId: Value(posId),
      shift: Value(shift),
      shiftDate: Value(shiftDate),
      cashFloat: Value(cashFloat),
      totalCash: Value(totalCash),
      denominationJson: Value(denominationJson),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CashReportTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashReportTableData(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      posId: serializer.fromJson<String>(json['posId']),
      shift: serializer.fromJson<int>(json['shift']),
      shiftDate: serializer.fromJson<String>(json['shiftDate']),
      cashFloat: serializer.fromJson<double>(json['cashFloat']),
      totalCash: serializer.fromJson<double>(json['totalCash']),
      denominationJson: serializer.fromJson<String>(json['denominationJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'posId': serializer.toJson<String>(posId),
      'shift': serializer.toJson<int>(shift),
      'shiftDate': serializer.toJson<String>(shiftDate),
      'cashFloat': serializer.toJson<double>(cashFloat),
      'totalCash': serializer.toJson<double>(totalCash),
      'denominationJson': serializer.toJson<String>(denominationJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CashReportTableData copyWith({
    String? id,
    String? branchId,
    String? posId,
    int? shift,
    String? shiftDate,
    double? cashFloat,
    double? totalCash,
    String? denominationJson,
    DateTime? fetchedAt,
  }) => CashReportTableData(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    posId: posId ?? this.posId,
    shift: shift ?? this.shift,
    shiftDate: shiftDate ?? this.shiftDate,
    cashFloat: cashFloat ?? this.cashFloat,
    totalCash: totalCash ?? this.totalCash,
    denominationJson: denominationJson ?? this.denominationJson,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CashReportTableData copyWithCompanion(CashReportTableCompanion data) {
    return CashReportTableData(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      posId: data.posId.present ? data.posId.value : this.posId,
      shift: data.shift.present ? data.shift.value : this.shift,
      shiftDate: data.shiftDate.present ? data.shiftDate.value : this.shiftDate,
      cashFloat: data.cashFloat.present ? data.cashFloat.value : this.cashFloat,
      totalCash: data.totalCash.present ? data.totalCash.value : this.totalCash,
      denominationJson: data.denominationJson.present
          ? data.denominationJson.value
          : this.denominationJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashReportTableData(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('cashFloat: $cashFloat, ')
          ..write('totalCash: $totalCash, ')
          ..write('denominationJson: $denominationJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    posId,
    shift,
    shiftDate,
    cashFloat,
    totalCash,
    denominationJson,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashReportTableData &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.posId == this.posId &&
          other.shift == this.shift &&
          other.shiftDate == this.shiftDate &&
          other.cashFloat == this.cashFloat &&
          other.totalCash == this.totalCash &&
          other.denominationJson == this.denominationJson &&
          other.fetchedAt == this.fetchedAt);
}

class CashReportTableCompanion extends UpdateCompanion<CashReportTableData> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> posId;
  final Value<int> shift;
  final Value<String> shiftDate;
  final Value<double> cashFloat;
  final Value<double> totalCash;
  final Value<String> denominationJson;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CashReportTableCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.posId = const Value.absent(),
    this.shift = const Value.absent(),
    this.shiftDate = const Value.absent(),
    this.cashFloat = const Value.absent(),
    this.totalCash = const Value.absent(),
    this.denominationJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashReportTableCompanion.insert({
    this.id = const Value.absent(),
    required String branchId,
    required String posId,
    required int shift,
    required String shiftDate,
    this.cashFloat = const Value.absent(),
    this.totalCash = const Value.absent(),
    this.denominationJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : branchId = Value(branchId),
       posId = Value(posId),
       shift = Value(shift),
       shiftDate = Value(shiftDate);
  static Insertable<CashReportTableData> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? posId,
    Expression<int>? shift,
    Expression<String>? shiftDate,
    Expression<double>? cashFloat,
    Expression<double>? totalCash,
    Expression<String>? denominationJson,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (posId != null) 'pos_id': posId,
      if (shift != null) 'shift': shift,
      if (shiftDate != null) 'shift_date': shiftDate,
      if (cashFloat != null) 'cash_float': cashFloat,
      if (totalCash != null) 'total_cash': totalCash,
      if (denominationJson != null) 'denomination_json': denominationJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashReportTableCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? posId,
    Value<int>? shift,
    Value<String>? shiftDate,
    Value<double>? cashFloat,
    Value<double>? totalCash,
    Value<String>? denominationJson,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CashReportTableCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      posId: posId ?? this.posId,
      shift: shift ?? this.shift,
      shiftDate: shiftDate ?? this.shiftDate,
      cashFloat: cashFloat ?? this.cashFloat,
      totalCash: totalCash ?? this.totalCash,
      denominationJson: denominationJson ?? this.denominationJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
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
    if (posId.present) {
      map['pos_id'] = Variable<String>(posId.value);
    }
    if (shift.present) {
      map['shift'] = Variable<int>(shift.value);
    }
    if (shiftDate.present) {
      map['shift_date'] = Variable<String>(shiftDate.value);
    }
    if (cashFloat.present) {
      map['cash_float'] = Variable<double>(cashFloat.value);
    }
    if (totalCash.present) {
      map['total_cash'] = Variable<double>(totalCash.value);
    }
    if (denominationJson.present) {
      map['denomination_json'] = Variable<String>(denominationJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashReportTableCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('posId: $posId, ')
          ..write('shift: $shift, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('cashFloat: $cashFloat, ')
          ..write('totalCash: $totalCash, ')
          ..write('denominationJson: $denominationJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomerTableTable extends CustomerTable
    with TableInfo<$CustomerTableTable, CustomerTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _salesIdMeta = const VerificationMeta(
    'salesId',
  );
  @override
  late final GeneratedColumn<String> salesId = GeneratedColumn<String>(
    'sales_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posIdMeta = const VerificationMeta('posId');
  @override
  late final GeneratedColumn<String> posId = GeneratedColumn<String>(
    'pos_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _purchaseOrderMeta = const VerificationMeta(
    'purchaseOrder',
  );
  @override
  late final GeneratedColumn<String> purchaseOrder = GeneratedColumn<String>(
    'purchase_order',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    salesId,
    posId,
    type,
    company,
    fullName,
    email,
    phone,
    mobile,
    address,
    purchaseOrder,
    createdAt,
    syncStatus,
    syncedAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sales_id')) {
      context.handle(
        _salesIdMeta,
        salesId.isAcceptableOrUnknown(data['sales_id']!, _salesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_salesIdMeta);
    }
    if (data.containsKey('pos_id')) {
      context.handle(
        _posIdMeta,
        posId.isAcceptableOrUnknown(data['pos_id']!, _posIdMeta),
      );
    } else if (isInserting) {
      context.missing(_posIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('purchase_order')) {
      context.handle(
        _purchaseOrderMeta,
        purchaseOrder.isAcceptableOrUnknown(
          data['purchase_order']!,
          _purchaseOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {salesId},
  ];
  @override
  CustomerTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      salesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sales_id'],
      )!,
      posId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      purchaseOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $CustomerTableTable createAlias(String alias) {
    return $CustomerTableTable(attachedDatabase, alias);
  }
}

class CustomerTableData extends DataClass
    implements Insertable<CustomerTableData> {
  final String id;

  /// The sale's receipt (detail) id. The server links the customer to the sale
  /// with it, so a sale has at most one customer record.
  final String salesId;
  final String posId;

  /// "Individual" or "Company".
  final String type;

  /// Company name. Empty for an individual.
  final String company;

  /// The individual's full name, or the company's representative.
  final String fullName;
  final String email;
  final String phone;
  final String mobile;
  final String address;

  /// Kept on the device with the customer. The customer API has no field for
  /// it, so it is not sent.
  final String purchaseOrder;
  final DateTime createdAt;

  /// PENDING until the server has accepted it, then SYNCED.
  final String syncStatus;
  final DateTime? syncedAt;

  /// How many sends have failed, and why the last one did.
  final int attempts;
  final String? lastError;
  const CustomerTableData({
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
    required this.syncStatus,
    this.syncedAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sales_id'] = Variable<String>(salesId);
    map['pos_id'] = Variable<String>(posId);
    map['type'] = Variable<String>(type);
    map['company'] = Variable<String>(company);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['mobile'] = Variable<String>(mobile);
    map['address'] = Variable<String>(address);
    map['purchase_order'] = Variable<String>(purchaseOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  CustomerTableCompanion toCompanion(bool nullToAbsent) {
    return CustomerTableCompanion(
      id: Value(id),
      salesId: Value(salesId),
      posId: Value(posId),
      type: Value(type),
      company: Value(company),
      fullName: Value(fullName),
      email: Value(email),
      phone: Value(phone),
      mobile: Value(mobile),
      address: Value(address),
      purchaseOrder: Value(purchaseOrder),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory CustomerTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerTableData(
      id: serializer.fromJson<String>(json['id']),
      salesId: serializer.fromJson<String>(json['salesId']),
      posId: serializer.fromJson<String>(json['posId']),
      type: serializer.fromJson<String>(json['type']),
      company: serializer.fromJson<String>(json['company']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      mobile: serializer.fromJson<String>(json['mobile']),
      address: serializer.fromJson<String>(json['address']),
      purchaseOrder: serializer.fromJson<String>(json['purchaseOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'salesId': serializer.toJson<String>(salesId),
      'posId': serializer.toJson<String>(posId),
      'type': serializer.toJson<String>(type),
      'company': serializer.toJson<String>(company),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'mobile': serializer.toJson<String>(mobile),
      'address': serializer.toJson<String>(address),
      'purchaseOrder': serializer.toJson<String>(purchaseOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  CustomerTableData copyWith({
    String? id,
    String? salesId,
    String? posId,
    String? type,
    String? company,
    String? fullName,
    String? email,
    String? phone,
    String? mobile,
    String? address,
    String? purchaseOrder,
    DateTime? createdAt,
    String? syncStatus,
    Value<DateTime?> syncedAt = const Value.absent(),
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => CustomerTableData(
    id: id ?? this.id,
    salesId: salesId ?? this.salesId,
    posId: posId ?? this.posId,
    type: type ?? this.type,
    company: company ?? this.company,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    mobile: mobile ?? this.mobile,
    address: address ?? this.address,
    purchaseOrder: purchaseOrder ?? this.purchaseOrder,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  CustomerTableData copyWithCompanion(CustomerTableCompanion data) {
    return CustomerTableData(
      id: data.id.present ? data.id.value : this.id,
      salesId: data.salesId.present ? data.salesId.value : this.salesId,
      posId: data.posId.present ? data.posId.value : this.posId,
      type: data.type.present ? data.type.value : this.type,
      company: data.company.present ? data.company.value : this.company,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      address: data.address.present ? data.address.value : this.address,
      purchaseOrder: data.purchaseOrder.present
          ? data.purchaseOrder.value
          : this.purchaseOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerTableData(')
          ..write('id: $id, ')
          ..write('salesId: $salesId, ')
          ..write('posId: $posId, ')
          ..write('type: $type, ')
          ..write('company: $company, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('mobile: $mobile, ')
          ..write('address: $address, ')
          ..write('purchaseOrder: $purchaseOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    salesId,
    posId,
    type,
    company,
    fullName,
    email,
    phone,
    mobile,
    address,
    purchaseOrder,
    createdAt,
    syncStatus,
    syncedAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerTableData &&
          other.id == this.id &&
          other.salesId == this.salesId &&
          other.posId == this.posId &&
          other.type == this.type &&
          other.company == this.company &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.mobile == this.mobile &&
          other.address == this.address &&
          other.purchaseOrder == this.purchaseOrder &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class CustomerTableCompanion extends UpdateCompanion<CustomerTableData> {
  final Value<String> id;
  final Value<String> salesId;
  final Value<String> posId;
  final Value<String> type;
  final Value<String> company;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String> phone;
  final Value<String> mobile;
  final Value<String> address;
  final Value<String> purchaseOrder;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const CustomerTableCompanion({
    this.id = const Value.absent(),
    this.salesId = const Value.absent(),
    this.posId = const Value.absent(),
    this.type = const Value.absent(),
    this.company = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.mobile = const Value.absent(),
    this.address = const Value.absent(),
    this.purchaseOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomerTableCompanion.insert({
    this.id = const Value.absent(),
    required String salesId,
    required String posId,
    required String type,
    this.company = const Value.absent(),
    required String fullName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.mobile = const Value.absent(),
    this.address = const Value.absent(),
    this.purchaseOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : salesId = Value(salesId),
       posId = Value(posId),
       type = Value(type),
       fullName = Value(fullName);
  static Insertable<CustomerTableData> custom({
    Expression<String>? id,
    Expression<String>? salesId,
    Expression<String>? posId,
    Expression<String>? type,
    Expression<String>? company,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? mobile,
    Expression<String>? address,
    Expression<String>? purchaseOrder,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (salesId != null) 'sales_id': salesId,
      if (posId != null) 'pos_id': posId,
      if (type != null) 'type': type,
      if (company != null) 'company': company,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (mobile != null) 'mobile': mobile,
      if (address != null) 'address': address,
      if (purchaseOrder != null) 'purchase_order': purchaseOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomerTableCompanion copyWith({
    Value<String>? id,
    Value<String>? salesId,
    Value<String>? posId,
    Value<String>? type,
    Value<String>? company,
    Value<String>? fullName,
    Value<String>? email,
    Value<String>? phone,
    Value<String>? mobile,
    Value<String>? address,
    Value<String>? purchaseOrder,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<DateTime?>? syncedAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return CustomerTableCompanion(
      id: id ?? this.id,
      salesId: salesId ?? this.salesId,
      posId: posId ?? this.posId,
      type: type ?? this.type,
      company: company ?? this.company,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      purchaseOrder: purchaseOrder ?? this.purchaseOrder,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (salesId.present) {
      map['sales_id'] = Variable<String>(salesId.value);
    }
    if (posId.present) {
      map['pos_id'] = Variable<String>(posId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (purchaseOrder.present) {
      map['purchase_order'] = Variable<String>(purchaseOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerTableCompanion(')
          ..write('id: $id, ')
          ..write('salesId: $salesId, ')
          ..write('posId: $posId, ')
          ..write('type: $type, ')
          ..write('company: $company, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('mobile: $mobile, ')
          ..write('address: $address, ')
          ..write('purchaseOrder: $purchaseOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
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
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $SalesTableTable salesTable = $SalesTableTable(this);
  late final $EndShiftTableTable endShiftTable = $EndShiftTableTable(this);
  late final $SoldItemsTableTable soldItemsTable = $SoldItemsTableTable(this);
  late final $CashDrawerTableTable cashDrawerTable = $CashDrawerTableTable(
    this,
  );
  late final $SoldItemsReportTableTable soldItemsReportTable =
      $SoldItemsReportTableTable(this);
  late final $PaymentSummaryReportTableTable paymentSummaryReportTable =
      $PaymentSummaryReportTableTable(this);
  late final $StaffSalesReportTableTable staffSalesReportTable =
      $StaffSalesReportTableTable(this);
  late final $SoldServicesReportTableTable soldServicesReportTable =
      $SoldServicesReportTableTable(this);
  late final $SoldPackagesReportTableTable soldPackagesReportTable =
      $SoldPackagesReportTableTable(this);
  late final $ServiceTableTable serviceTable = $ServiceTableTable(this);
  late final $ServicePackageTableTable servicePackageTable =
      $ServicePackageTableTable(this);
  late final $AddonTableTable addonTable = $AddonTableTable(this);
  late final $ShiftReportTableTable shiftReportTable = $ShiftReportTableTable(
    this,
  );
  late final $ReceiptHistoryTableTable receiptHistoryTable =
      $ReceiptHistoryTableTable(this);
  late final $CashDropTableTable cashDropTable = $CashDropTableTable(this);
  late final $SendCashReportTableTable sendCashReportTable =
      $SendCashReportTableTable(this);
  late final $CashReportTableTable cashReportTable = $CashReportTableTable(
    this,
  );
  late final $CustomerTableTable customerTable = $CustomerTableTable(this);
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
    settingsTable,
    salesTable,
    endShiftTable,
    soldItemsTable,
    cashDrawerTable,
    soldItemsReportTable,
    paymentSummaryReportTable,
    staffSalesReportTable,
    soldServicesReportTable,
    soldPackagesReportTable,
    serviceTable,
    servicePackageTable,
    addonTable,
    shiftReportTable,
    receiptHistoryTable,
    cashDropTable,
    sendCashReportTable,
    cashReportTable,
    customerTable,
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
      Value<bool> isEnabled,
      Value<bool> hasCashDrawer,
      Value<int> rowid,
    });
typedef $$PrintersTableTableUpdateCompanionBuilder =
    PrintersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> connectionType,
      Value<String> address,
      Value<String> paperSize,
      Value<bool> isEnabled,
      Value<bool> hasCashDrawer,
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

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCashDrawer => $composableBuilder(
    column: $table.hasCashDrawer,
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

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCashDrawer => $composableBuilder(
    column: $table.hasCashDrawer,
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

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get hasCashDrawer => $composableBuilder(
    column: $table.hasCashDrawer,
    builder: (column) => column,
  );
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
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> hasCashDrawer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrintersTableCompanion(
                id: id,
                name: name,
                connectionType: connectionType,
                address: address,
                paperSize: paperSize,
                isEnabled: isEnabled,
                hasCashDrawer: hasCashDrawer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> connectionType = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> paperSize = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> hasCashDrawer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrintersTableCompanion.insert(
                id: id,
                name: name,
                connectionType: connectionType,
                address: address,
                paperSize: paperSize,
                isEnabled: isEnabled,
                hasCashDrawer: hasCashDrawer,
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
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<String> id,
      Value<String> mainPrinter,
      Value<String> subPrinter,
      Value<bool> showVatOnReceipt,
      Value<bool> showOfficialReceiptMessageAtTheBottom,
      Value<bool> birAccredited,
      Value<bool> showReceiptPreview,
      Value<bool> addCustomerToTransaction,
      Value<bool> addPurchaseOrderToTransaction,
      Value<String> counterDisplay,
      Value<String> companyName,
      Value<String> address,
      Value<String> accreditationNo,
      Value<String> validUntil,
      Value<String> vatReg,
      Value<String> permitToUse,
      Value<String> machineIdentificationNumber,
      Value<int> rowid,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<String> id,
      Value<String> mainPrinter,
      Value<String> subPrinter,
      Value<bool> showVatOnReceipt,
      Value<bool> showOfficialReceiptMessageAtTheBottom,
      Value<bool> birAccredited,
      Value<bool> showReceiptPreview,
      Value<bool> addCustomerToTransaction,
      Value<bool> addPurchaseOrderToTransaction,
      Value<String> counterDisplay,
      Value<String> companyName,
      Value<String> address,
      Value<String> accreditationNo,
      Value<String> validUntil,
      Value<String> vatReg,
      Value<String> permitToUse,
      Value<String> machineIdentificationNumber,
      Value<int> rowid,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<String> get mainPrinter => $composableBuilder(
    column: $table.mainPrinter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subPrinter => $composableBuilder(
    column: $table.subPrinter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showVatOnReceipt => $composableBuilder(
    column: $table.showVatOnReceipt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showOfficialReceiptMessageAtTheBottom =>
      $composableBuilder(
        column: $table.showOfficialReceiptMessageAtTheBottom,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get birAccredited => $composableBuilder(
    column: $table.birAccredited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showReceiptPreview => $composableBuilder(
    column: $table.showReceiptPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get addCustomerToTransaction => $composableBuilder(
    column: $table.addCustomerToTransaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get addPurchaseOrderToTransaction => $composableBuilder(
    column: $table.addPurchaseOrderToTransaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterDisplay => $composableBuilder(
    column: $table.counterDisplay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accreditationNo => $composableBuilder(
    column: $table.accreditationNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vatReg => $composableBuilder(
    column: $table.vatReg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permitToUse => $composableBuilder(
    column: $table.permitToUse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineIdentificationNumber => $composableBuilder(
    column: $table.machineIdentificationNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get mainPrinter => $composableBuilder(
    column: $table.mainPrinter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subPrinter => $composableBuilder(
    column: $table.subPrinter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showVatOnReceipt => $composableBuilder(
    column: $table.showVatOnReceipt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showOfficialReceiptMessageAtTheBottom =>
      $composableBuilder(
        column: $table.showOfficialReceiptMessageAtTheBottom,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get birAccredited => $composableBuilder(
    column: $table.birAccredited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showReceiptPreview => $composableBuilder(
    column: $table.showReceiptPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get addCustomerToTransaction => $composableBuilder(
    column: $table.addCustomerToTransaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get addPurchaseOrderToTransaction => $composableBuilder(
    column: $table.addPurchaseOrderToTransaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterDisplay => $composableBuilder(
    column: $table.counterDisplay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accreditationNo => $composableBuilder(
    column: $table.accreditationNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vatReg => $composableBuilder(
    column: $table.vatReg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permitToUse => $composableBuilder(
    column: $table.permitToUse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineIdentificationNumber => $composableBuilder(
    column: $table.machineIdentificationNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mainPrinter => $composableBuilder(
    column: $table.mainPrinter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subPrinter => $composableBuilder(
    column: $table.subPrinter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showVatOnReceipt => $composableBuilder(
    column: $table.showVatOnReceipt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showOfficialReceiptMessageAtTheBottom =>
      $composableBuilder(
        column: $table.showOfficialReceiptMessageAtTheBottom,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get birAccredited => $composableBuilder(
    column: $table.birAccredited,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showReceiptPreview => $composableBuilder(
    column: $table.showReceiptPreview,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get addCustomerToTransaction => $composableBuilder(
    column: $table.addCustomerToTransaction,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get addPurchaseOrderToTransaction => $composableBuilder(
    column: $table.addPurchaseOrderToTransaction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get counterDisplay => $composableBuilder(
    column: $table.counterDisplay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get accreditationNo => $composableBuilder(
    column: $table.accreditationNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vatReg =>
      $composableBuilder(column: $table.vatReg, builder: (column) => column);

  GeneratedColumn<String> get permitToUse => $composableBuilder(
    column: $table.permitToUse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get machineIdentificationNumber => $composableBuilder(
    column: $table.machineIdentificationNumber,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsTableData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SettingsTableTable,
              SettingsTableData
            >,
          ),
          SettingsTableData,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mainPrinter = const Value.absent(),
                Value<String> subPrinter = const Value.absent(),
                Value<bool> showVatOnReceipt = const Value.absent(),
                Value<bool> showOfficialReceiptMessageAtTheBottom =
                    const Value.absent(),
                Value<bool> birAccredited = const Value.absent(),
                Value<bool> showReceiptPreview = const Value.absent(),
                Value<bool> addCustomerToTransaction = const Value.absent(),
                Value<bool> addPurchaseOrderToTransaction =
                    const Value.absent(),
                Value<String> counterDisplay = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> accreditationNo = const Value.absent(),
                Value<String> validUntil = const Value.absent(),
                Value<String> vatReg = const Value.absent(),
                Value<String> permitToUse = const Value.absent(),
                Value<String> machineIdentificationNumber =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                mainPrinter: mainPrinter,
                subPrinter: subPrinter,
                showVatOnReceipt: showVatOnReceipt,
                showOfficialReceiptMessageAtTheBottom:
                    showOfficialReceiptMessageAtTheBottom,
                birAccredited: birAccredited,
                showReceiptPreview: showReceiptPreview,
                addCustomerToTransaction: addCustomerToTransaction,
                addPurchaseOrderToTransaction: addPurchaseOrderToTransaction,
                counterDisplay: counterDisplay,
                companyName: companyName,
                address: address,
                accreditationNo: accreditationNo,
                validUntil: validUntil,
                vatReg: vatReg,
                permitToUse: permitToUse,
                machineIdentificationNumber: machineIdentificationNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mainPrinter = const Value.absent(),
                Value<String> subPrinter = const Value.absent(),
                Value<bool> showVatOnReceipt = const Value.absent(),
                Value<bool> showOfficialReceiptMessageAtTheBottom =
                    const Value.absent(),
                Value<bool> birAccredited = const Value.absent(),
                Value<bool> showReceiptPreview = const Value.absent(),
                Value<bool> addCustomerToTransaction = const Value.absent(),
                Value<bool> addPurchaseOrderToTransaction =
                    const Value.absent(),
                Value<String> counterDisplay = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> accreditationNo = const Value.absent(),
                Value<String> validUntil = const Value.absent(),
                Value<String> vatReg = const Value.absent(),
                Value<String> permitToUse = const Value.absent(),
                Value<String> machineIdentificationNumber =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                id: id,
                mainPrinter: mainPrinter,
                subPrinter: subPrinter,
                showVatOnReceipt: showVatOnReceipt,
                showOfficialReceiptMessageAtTheBottom:
                    showOfficialReceiptMessageAtTheBottom,
                birAccredited: birAccredited,
                showReceiptPreview: showReceiptPreview,
                addCustomerToTransaction: addCustomerToTransaction,
                addPurchaseOrderToTransaction: addPurchaseOrderToTransaction,
                counterDisplay: counterDisplay,
                companyName: companyName,
                address: address,
                accreditationNo: accreditationNo,
                validUntil: validUntil,
                vatReg: vatReg,
                permitToUse: permitToUse,
                machineIdentificationNumber: machineIdentificationNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsTableData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsTableData,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>,
      ),
      SettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$SalesTableTableCreateCompanionBuilder =
    SalesTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<String> detailId,
      Value<String> date,
      Value<String> posid,
      Value<String> shift,
      Value<String> paymentType,
      Value<String> referenceId,
      Value<String> paymentName,
      Value<String> items,
      Value<String> total,
      Value<String> cashier,
      Value<String> cash,
      Value<String> ecash,
      Value<String> branch,
      Value<String> discountDetail,
      Value<String> isSync,
      Value<int> rowid,
    });
typedef $$SalesTableTableUpdateCompanionBuilder =
    SalesTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<String> detailId,
      Value<String> date,
      Value<String> posid,
      Value<String> shift,
      Value<String> paymentType,
      Value<String> referenceId,
      Value<String> paymentName,
      Value<String> items,
      Value<String> total,
      Value<String> cashier,
      Value<String> cash,
      Value<String> ecash,
      Value<String> branch,
      Value<String> discountDetail,
      Value<String> isSync,
      Value<int> rowid,
    });

class $$SalesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SalesTableTable> {
  $$SalesTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailId => $composableBuilder(
    column: $table.detailId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posid => $composableBuilder(
    column: $table.posid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cash => $composableBuilder(
    column: $table.cash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ecash => $composableBuilder(
    column: $table.ecash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountDetail => $composableBuilder(
    column: $table.discountDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isSync => $composableBuilder(
    column: $table.isSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTableTable> {
  $$SalesTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailId => $composableBuilder(
    column: $table.detailId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posid => $composableBuilder(
    column: $table.posid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cash => $composableBuilder(
    column: $table.cash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ecash => $composableBuilder(
    column: $table.ecash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountDetail => $composableBuilder(
    column: $table.discountDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isSync => $composableBuilder(
    column: $table.isSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTableTable> {
  $$SalesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get detailId =>
      $composableBuilder(column: $table.detailId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get posid =>
      $composableBuilder(column: $table.posid, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get items =>
      $composableBuilder(column: $table.items, builder: (column) => column);

  GeneratedColumn<String> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get cashier =>
      $composableBuilder(column: $table.cashier, builder: (column) => column);

  GeneratedColumn<String> get cash =>
      $composableBuilder(column: $table.cash, builder: (column) => column);

  GeneratedColumn<String> get ecash =>
      $composableBuilder(column: $table.ecash, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<String> get discountDetail => $composableBuilder(
    column: $table.discountDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isSync =>
      $composableBuilder(column: $table.isSync, builder: (column) => column);
}

class $$SalesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTableTable,
          SalesTableData,
          $$SalesTableTableFilterComposer,
          $$SalesTableTableOrderingComposer,
          $$SalesTableTableAnnotationComposer,
          $$SalesTableTableCreateCompanionBuilder,
          $$SalesTableTableUpdateCompanionBuilder,
          (
            SalesTableData,
            BaseReferences<_$AppDatabase, $SalesTableTable, SalesTableData>,
          ),
          SalesTableData,
          PrefetchHooks Function()
        > {
  $$SalesTableTableTableManager(_$AppDatabase db, $SalesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> detailId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> posid = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String> paymentName = const Value.absent(),
                Value<String> items = const Value.absent(),
                Value<String> total = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String> cash = const Value.absent(),
                Value<String> ecash = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<String> discountDetail = const Value.absent(),
                Value<String> isSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesTableCompanion(
                id: id,
                createdAt: createdAt,
                detailId: detailId,
                date: date,
                posid: posid,
                shift: shift,
                paymentType: paymentType,
                referenceId: referenceId,
                paymentName: paymentName,
                items: items,
                total: total,
                cashier: cashier,
                cash: cash,
                ecash: ecash,
                branch: branch,
                discountDetail: discountDetail,
                isSync: isSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> detailId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> posid = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String> paymentName = const Value.absent(),
                Value<String> items = const Value.absent(),
                Value<String> total = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String> cash = const Value.absent(),
                Value<String> ecash = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<String> discountDetail = const Value.absent(),
                Value<String> isSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                detailId: detailId,
                date: date,
                posid: posid,
                shift: shift,
                paymentType: paymentType,
                referenceId: referenceId,
                paymentName: paymentName,
                items: items,
                total: total,
                cashier: cashier,
                cash: cash,
                ecash: ecash,
                branch: branch,
                discountDetail: discountDetail,
                isSync: isSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTableTable,
      SalesTableData,
      $$SalesTableTableFilterComposer,
      $$SalesTableTableOrderingComposer,
      $$SalesTableTableAnnotationComposer,
      $$SalesTableTableCreateCompanionBuilder,
      $$SalesTableTableUpdateCompanionBuilder,
      (
        SalesTableData,
        BaseReferences<_$AppDatabase, $SalesTableTable, SalesTableData>,
      ),
      SalesTableData,
      PrefetchHooks Function()
    >;
typedef $$EndShiftTableTableCreateCompanionBuilder =
    EndShiftTableCompanion Function({
      Value<String> id,
      required String date,
      required int pos,
      required int shift,
      required String cashier,
      Value<String?> floating,
      Value<String?> cashfloat,
      required double salesBeginning,
      required double salesEnding,
      required double totalSales,
      required int receiptBeginning,
      required int receiptEnding,
      required String status,
      Value<String?> approvedBy,
      Value<String?> approvedDate,
      Value<int> rowid,
    });
typedef $$EndShiftTableTableUpdateCompanionBuilder =
    EndShiftTableCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<int> pos,
      Value<int> shift,
      Value<String> cashier,
      Value<String?> floating,
      Value<String?> cashfloat,
      Value<double> salesBeginning,
      Value<double> salesEnding,
      Value<double> totalSales,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<String> status,
      Value<String?> approvedBy,
      Value<String?> approvedDate,
      Value<int> rowid,
    });

class $$EndShiftTableTableFilterComposer
    extends Composer<_$AppDatabase, $EndShiftTableTable> {
  $$EndShiftTableTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get floating => $composableBuilder(
    column: $table.floating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashfloat => $composableBuilder(
    column: $table.cashfloat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salesBeginning => $composableBuilder(
    column: $table.salesBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salesEnding => $composableBuilder(
    column: $table.salesEnding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSales => $composableBuilder(
    column: $table.totalSales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedDate => $composableBuilder(
    column: $table.approvedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EndShiftTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EndShiftTableTable> {
  $$EndShiftTableTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get floating => $composableBuilder(
    column: $table.floating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashfloat => $composableBuilder(
    column: $table.cashfloat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salesBeginning => $composableBuilder(
    column: $table.salesBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salesEnding => $composableBuilder(
    column: $table.salesEnding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSales => $composableBuilder(
    column: $table.totalSales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedDate => $composableBuilder(
    column: $table.approvedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EndShiftTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EndShiftTableTable> {
  $$EndShiftTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<int> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get cashier =>
      $composableBuilder(column: $table.cashier, builder: (column) => column);

  GeneratedColumn<String> get floating =>
      $composableBuilder(column: $table.floating, builder: (column) => column);

  GeneratedColumn<String> get cashfloat =>
      $composableBuilder(column: $table.cashfloat, builder: (column) => column);

  GeneratedColumn<double> get salesBeginning => $composableBuilder(
    column: $table.salesBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salesEnding => $composableBuilder(
    column: $table.salesEnding,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSales => $composableBuilder(
    column: $table.totalSales,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvedDate => $composableBuilder(
    column: $table.approvedDate,
    builder: (column) => column,
  );
}

class $$EndShiftTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EndShiftTableTable,
          EndShiftTableData,
          $$EndShiftTableTableFilterComposer,
          $$EndShiftTableTableOrderingComposer,
          $$EndShiftTableTableAnnotationComposer,
          $$EndShiftTableTableCreateCompanionBuilder,
          $$EndShiftTableTableUpdateCompanionBuilder,
          (
            EndShiftTableData,
            BaseReferences<
              _$AppDatabase,
              $EndShiftTableTable,
              EndShiftTableData
            >,
          ),
          EndShiftTableData,
          PrefetchHooks Function()
        > {
  $$EndShiftTableTableTableManager(_$AppDatabase db, $EndShiftTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EndShiftTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EndShiftTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EndShiftTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> pos = const Value.absent(),
                Value<int> shift = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String?> floating = const Value.absent(),
                Value<String?> cashfloat = const Value.absent(),
                Value<double> salesBeginning = const Value.absent(),
                Value<double> salesEnding = const Value.absent(),
                Value<double> totalSales = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<String?> approvedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EndShiftTableCompanion(
                id: id,
                date: date,
                pos: pos,
                shift: shift,
                cashier: cashier,
                floating: floating,
                cashfloat: cashfloat,
                salesBeginning: salesBeginning,
                salesEnding: salesEnding,
                totalSales: totalSales,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                status: status,
                approvedBy: approvedBy,
                approvedDate: approvedDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String date,
                required int pos,
                required int shift,
                required String cashier,
                Value<String?> floating = const Value.absent(),
                Value<String?> cashfloat = const Value.absent(),
                required double salesBeginning,
                required double salesEnding,
                required double totalSales,
                required int receiptBeginning,
                required int receiptEnding,
                required String status,
                Value<String?> approvedBy = const Value.absent(),
                Value<String?> approvedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EndShiftTableCompanion.insert(
                id: id,
                date: date,
                pos: pos,
                shift: shift,
                cashier: cashier,
                floating: floating,
                cashfloat: cashfloat,
                salesBeginning: salesBeginning,
                salesEnding: salesEnding,
                totalSales: totalSales,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                status: status,
                approvedBy: approvedBy,
                approvedDate: approvedDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EndShiftTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EndShiftTableTable,
      EndShiftTableData,
      $$EndShiftTableTableFilterComposer,
      $$EndShiftTableTableOrderingComposer,
      $$EndShiftTableTableAnnotationComposer,
      $$EndShiftTableTableCreateCompanionBuilder,
      $$EndShiftTableTableUpdateCompanionBuilder,
      (
        EndShiftTableData,
        BaseReferences<_$AppDatabase, $EndShiftTableTable, EndShiftTableData>,
      ),
      EndShiftTableData,
      PrefetchHooks Function()
    >;
typedef $$SoldItemsTableTableCreateCompanionBuilder =
    SoldItemsTableCompanion Function({
      Value<String> id,
      required String dateRange,
      Value<String> categoryFilter,
      Value<String> productFilter,
      required int fetchedAt,
      Value<String> branch,
      Value<String> category,
      Value<String> name,
      Value<int> quantity,
      Value<int> rowid,
    });
typedef $$SoldItemsTableTableUpdateCompanionBuilder =
    SoldItemsTableCompanion Function({
      Value<String> id,
      Value<String> dateRange,
      Value<String> categoryFilter,
      Value<String> productFilter,
      Value<int> fetchedAt,
      Value<String> branch,
      Value<String> category,
      Value<String> name,
      Value<int> quantity,
      Value<int> rowid,
    });

class $$SoldItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SoldItemsTableTable> {
  $$SoldItemsTableTableFilterComposer({
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

  ColumnFilters<String> get dateRange => $composableBuilder(
    column: $table.dateRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryFilter => $composableBuilder(
    column: $table.categoryFilter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productFilter => $composableBuilder(
    column: $table.productFilter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SoldItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SoldItemsTableTable> {
  $$SoldItemsTableTableOrderingComposer({
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

  ColumnOrderings<String> get dateRange => $composableBuilder(
    column: $table.dateRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryFilter => $composableBuilder(
    column: $table.categoryFilter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productFilter => $composableBuilder(
    column: $table.productFilter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SoldItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoldItemsTableTable> {
  $$SoldItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateRange =>
      $composableBuilder(column: $table.dateRange, builder: (column) => column);

  GeneratedColumn<String> get categoryFilter => $composableBuilder(
    column: $table.categoryFilter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productFilter => $composableBuilder(
    column: $table.productFilter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$SoldItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SoldItemsTableTable,
          SoldItemsTableData,
          $$SoldItemsTableTableFilterComposer,
          $$SoldItemsTableTableOrderingComposer,
          $$SoldItemsTableTableAnnotationComposer,
          $$SoldItemsTableTableCreateCompanionBuilder,
          $$SoldItemsTableTableUpdateCompanionBuilder,
          (
            SoldItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $SoldItemsTableTable,
              SoldItemsTableData
            >,
          ),
          SoldItemsTableData,
          PrefetchHooks Function()
        > {
  $$SoldItemsTableTableTableManager(
    _$AppDatabase db,
    $SoldItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoldItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SoldItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SoldItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dateRange = const Value.absent(),
                Value<String> categoryFilter = const Value.absent(),
                Value<String> productFilter = const Value.absent(),
                Value<int> fetchedAt = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldItemsTableCompanion(
                id: id,
                dateRange: dateRange,
                categoryFilter: categoryFilter,
                productFilter: productFilter,
                fetchedAt: fetchedAt,
                branch: branch,
                category: category,
                name: name,
                quantity: quantity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String dateRange,
                Value<String> categoryFilter = const Value.absent(),
                Value<String> productFilter = const Value.absent(),
                required int fetchedAt,
                Value<String> branch = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldItemsTableCompanion.insert(
                id: id,
                dateRange: dateRange,
                categoryFilter: categoryFilter,
                productFilter: productFilter,
                fetchedAt: fetchedAt,
                branch: branch,
                category: category,
                name: name,
                quantity: quantity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SoldItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SoldItemsTableTable,
      SoldItemsTableData,
      $$SoldItemsTableTableFilterComposer,
      $$SoldItemsTableTableOrderingComposer,
      $$SoldItemsTableTableAnnotationComposer,
      $$SoldItemsTableTableCreateCompanionBuilder,
      $$SoldItemsTableTableUpdateCompanionBuilder,
      (
        SoldItemsTableData,
        BaseReferences<_$AppDatabase, $SoldItemsTableTable, SoldItemsTableData>,
      ),
      SoldItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$CashDrawerTableTableCreateCompanionBuilder =
    CashDrawerTableCompanion Function({
      Value<String> id,
      Value<String> shift,
      Value<String> cashier,
      Value<String> shiftDate,
      Value<String> branchId,
      Value<String> posId,
      Value<String> denomination,
      Value<String> activity,
      required int queuedAt,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$CashDrawerTableTableUpdateCompanionBuilder =
    CashDrawerTableCompanion Function({
      Value<String> id,
      Value<String> shift,
      Value<String> cashier,
      Value<String> shiftDate,
      Value<String> branchId,
      Value<String> posId,
      Value<String> denomination,
      Value<String> activity,
      Value<int> queuedAt,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$CashDrawerTableTableFilterComposer
    extends Composer<_$AppDatabase, $CashDrawerTableTable> {
  $$CashDrawerTableTableFilterComposer({
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

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get denomination => $composableBuilder(
    column: $table.denomination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashDrawerTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CashDrawerTableTable> {
  $$CashDrawerTableTableOrderingComposer({
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

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get denomination => $composableBuilder(
    column: $table.denomination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashDrawerTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashDrawerTableTable> {
  $$CashDrawerTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get cashier =>
      $composableBuilder(column: $table.cashier, builder: (column) => column);

  GeneratedColumn<String> get shiftDate =>
      $composableBuilder(column: $table.shiftDate, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<String> get denomination => $composableBuilder(
    column: $table.denomination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<int> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$CashDrawerTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashDrawerTableTable,
          CashDrawerTableData,
          $$CashDrawerTableTableFilterComposer,
          $$CashDrawerTableTableOrderingComposer,
          $$CashDrawerTableTableAnnotationComposer,
          $$CashDrawerTableTableCreateCompanionBuilder,
          $$CashDrawerTableTableUpdateCompanionBuilder,
          (
            CashDrawerTableData,
            BaseReferences<
              _$AppDatabase,
              $CashDrawerTableTable,
              CashDrawerTableData
            >,
          ),
          CashDrawerTableData,
          PrefetchHooks Function()
        > {
  $$CashDrawerTableTableTableManager(
    _$AppDatabase db,
    $CashDrawerTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashDrawerTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashDrawerTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashDrawerTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String> shiftDate = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> posId = const Value.absent(),
                Value<String> denomination = const Value.absent(),
                Value<String> activity = const Value.absent(),
                Value<int> queuedAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashDrawerTableCompanion(
                id: id,
                shift: shift,
                cashier: cashier,
                shiftDate: shiftDate,
                branchId: branchId,
                posId: posId,
                denomination: denomination,
                activity: activity,
                queuedAt: queuedAt,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String> shiftDate = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> posId = const Value.absent(),
                Value<String> denomination = const Value.absent(),
                Value<String> activity = const Value.absent(),
                required int queuedAt,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashDrawerTableCompanion.insert(
                id: id,
                shift: shift,
                cashier: cashier,
                shiftDate: shiftDate,
                branchId: branchId,
                posId: posId,
                denomination: denomination,
                activity: activity,
                queuedAt: queuedAt,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashDrawerTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashDrawerTableTable,
      CashDrawerTableData,
      $$CashDrawerTableTableFilterComposer,
      $$CashDrawerTableTableOrderingComposer,
      $$CashDrawerTableTableAnnotationComposer,
      $$CashDrawerTableTableCreateCompanionBuilder,
      $$CashDrawerTableTableUpdateCompanionBuilder,
      (
        CashDrawerTableData,
        BaseReferences<
          _$AppDatabase,
          $CashDrawerTableTable,
          CashDrawerTableData
        >,
      ),
      CashDrawerTableData,
      PrefetchHooks Function()
    >;
typedef $$SoldItemsReportTableTableCreateCompanionBuilder =
    SoldItemsReportTableCompanion Function({
      Value<String> id,
      Value<String> item,
      Value<int> quantity,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });
typedef $$SoldItemsReportTableTableUpdateCompanionBuilder =
    SoldItemsReportTableCompanion Function({
      Value<String> id,
      Value<String> item,
      Value<int> quantity,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });

class $$SoldItemsReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $SoldItemsReportTableTable> {
  $$SoldItemsReportTableTableFilterComposer({
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

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SoldItemsReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SoldItemsReportTableTable> {
  $$SoldItemsReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SoldItemsReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoldItemsReportTableTable> {
  $$SoldItemsReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );
}

class $$SoldItemsReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SoldItemsReportTableTable,
          SoldItemsReportTableData,
          $$SoldItemsReportTableTableFilterComposer,
          $$SoldItemsReportTableTableOrderingComposer,
          $$SoldItemsReportTableTableAnnotationComposer,
          $$SoldItemsReportTableTableCreateCompanionBuilder,
          $$SoldItemsReportTableTableUpdateCompanionBuilder,
          (
            SoldItemsReportTableData,
            BaseReferences<
              _$AppDatabase,
              $SoldItemsReportTableTable,
              SoldItemsReportTableData
            >,
          ),
          SoldItemsReportTableData,
          PrefetchHooks Function()
        > {
  $$SoldItemsReportTableTableTableManager(
    _$AppDatabase db,
    $SoldItemsReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoldItemsReportTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SoldItemsReportTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SoldItemsReportTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldItemsReportTableCompanion(
                id: id,
                item: item,
                quantity: quantity,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldItemsReportTableCompanion.insert(
                id: id,
                item: item,
                quantity: quantity,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SoldItemsReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SoldItemsReportTableTable,
      SoldItemsReportTableData,
      $$SoldItemsReportTableTableFilterComposer,
      $$SoldItemsReportTableTableOrderingComposer,
      $$SoldItemsReportTableTableAnnotationComposer,
      $$SoldItemsReportTableTableCreateCompanionBuilder,
      $$SoldItemsReportTableTableUpdateCompanionBuilder,
      (
        SoldItemsReportTableData,
        BaseReferences<
          _$AppDatabase,
          $SoldItemsReportTableTable,
          SoldItemsReportTableData
        >,
      ),
      SoldItemsReportTableData,
      PrefetchHooks Function()
    >;
typedef $$PaymentSummaryReportTableTableCreateCompanionBuilder =
    PaymentSummaryReportTableCompanion Function({
      Value<String> id,
      Value<String> paymentType,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });
typedef $$PaymentSummaryReportTableTableUpdateCompanionBuilder =
    PaymentSummaryReportTableCompanion Function({
      Value<String> id,
      Value<String> paymentType,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });

class $$PaymentSummaryReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentSummaryReportTableTable> {
  $$PaymentSummaryReportTableTableFilterComposer({
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

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentSummaryReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentSummaryReportTableTable> {
  $$PaymentSummaryReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentSummaryReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentSummaryReportTableTable> {
  $$PaymentSummaryReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );
}

class $$PaymentSummaryReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentSummaryReportTableTable,
          PaymentSummaryReportTableData,
          $$PaymentSummaryReportTableTableFilterComposer,
          $$PaymentSummaryReportTableTableOrderingComposer,
          $$PaymentSummaryReportTableTableAnnotationComposer,
          $$PaymentSummaryReportTableTableCreateCompanionBuilder,
          $$PaymentSummaryReportTableTableUpdateCompanionBuilder,
          (
            PaymentSummaryReportTableData,
            BaseReferences<
              _$AppDatabase,
              $PaymentSummaryReportTableTable,
              PaymentSummaryReportTableData
            >,
          ),
          PaymentSummaryReportTableData,
          PrefetchHooks Function()
        > {
  $$PaymentSummaryReportTableTableTableManager(
    _$AppDatabase db,
    $PaymentSummaryReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentSummaryReportTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PaymentSummaryReportTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaymentSummaryReportTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentSummaryReportTableCompanion(
                id: id,
                paymentType: paymentType,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentSummaryReportTableCompanion.insert(
                id: id,
                paymentType: paymentType,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentSummaryReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentSummaryReportTableTable,
      PaymentSummaryReportTableData,
      $$PaymentSummaryReportTableTableFilterComposer,
      $$PaymentSummaryReportTableTableOrderingComposer,
      $$PaymentSummaryReportTableTableAnnotationComposer,
      $$PaymentSummaryReportTableTableCreateCompanionBuilder,
      $$PaymentSummaryReportTableTableUpdateCompanionBuilder,
      (
        PaymentSummaryReportTableData,
        BaseReferences<
          _$AppDatabase,
          $PaymentSummaryReportTableTable,
          PaymentSummaryReportTableData
        >,
      ),
      PaymentSummaryReportTableData,
      PrefetchHooks Function()
    >;
typedef $$StaffSalesReportTableTableCreateCompanionBuilder =
    StaffSalesReportTableCompanion Function({
      Value<String> id,
      Value<String> salesStaff,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });
typedef $$StaffSalesReportTableTableUpdateCompanionBuilder =
    StaffSalesReportTableCompanion Function({
      Value<String> id,
      Value<String> salesStaff,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });

class $$StaffSalesReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $StaffSalesReportTableTable> {
  $$StaffSalesReportTableTableFilterComposer({
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

  ColumnFilters<String> get salesStaff => $composableBuilder(
    column: $table.salesStaff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StaffSalesReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffSalesReportTableTable> {
  $$StaffSalesReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get salesStaff => $composableBuilder(
    column: $table.salesStaff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StaffSalesReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffSalesReportTableTable> {
  $$StaffSalesReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get salesStaff => $composableBuilder(
    column: $table.salesStaff,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );
}

class $$StaffSalesReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StaffSalesReportTableTable,
          StaffSalesReportTableData,
          $$StaffSalesReportTableTableFilterComposer,
          $$StaffSalesReportTableTableOrderingComposer,
          $$StaffSalesReportTableTableAnnotationComposer,
          $$StaffSalesReportTableTableCreateCompanionBuilder,
          $$StaffSalesReportTableTableUpdateCompanionBuilder,
          (
            StaffSalesReportTableData,
            BaseReferences<
              _$AppDatabase,
              $StaffSalesReportTableTable,
              StaffSalesReportTableData
            >,
          ),
          StaffSalesReportTableData,
          PrefetchHooks Function()
        > {
  $$StaffSalesReportTableTableTableManager(
    _$AppDatabase db,
    $StaffSalesReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffSalesReportTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StaffSalesReportTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StaffSalesReportTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> salesStaff = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StaffSalesReportTableCompanion(
                id: id,
                salesStaff: salesStaff,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> salesStaff = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StaffSalesReportTableCompanion.insert(
                id: id,
                salesStaff: salesStaff,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StaffSalesReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StaffSalesReportTableTable,
      StaffSalesReportTableData,
      $$StaffSalesReportTableTableFilterComposer,
      $$StaffSalesReportTableTableOrderingComposer,
      $$StaffSalesReportTableTableAnnotationComposer,
      $$StaffSalesReportTableTableCreateCompanionBuilder,
      $$StaffSalesReportTableTableUpdateCompanionBuilder,
      (
        StaffSalesReportTableData,
        BaseReferences<
          _$AppDatabase,
          $StaffSalesReportTableTable,
          StaffSalesReportTableData
        >,
      ),
      StaffSalesReportTableData,
      PrefetchHooks Function()
    >;
typedef $$SoldServicesReportTableTableCreateCompanionBuilder =
    SoldServicesReportTableCompanion Function({
      Value<String> id,
      Value<String> item,
      Value<int> quantity,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });
typedef $$SoldServicesReportTableTableUpdateCompanionBuilder =
    SoldServicesReportTableCompanion Function({
      Value<String> id,
      Value<String> item,
      Value<int> quantity,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });

class $$SoldServicesReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $SoldServicesReportTableTable> {
  $$SoldServicesReportTableTableFilterComposer({
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

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SoldServicesReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SoldServicesReportTableTable> {
  $$SoldServicesReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SoldServicesReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoldServicesReportTableTable> {
  $$SoldServicesReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );
}

class $$SoldServicesReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SoldServicesReportTableTable,
          SoldServicesReportTableData,
          $$SoldServicesReportTableTableFilterComposer,
          $$SoldServicesReportTableTableOrderingComposer,
          $$SoldServicesReportTableTableAnnotationComposer,
          $$SoldServicesReportTableTableCreateCompanionBuilder,
          $$SoldServicesReportTableTableUpdateCompanionBuilder,
          (
            SoldServicesReportTableData,
            BaseReferences<
              _$AppDatabase,
              $SoldServicesReportTableTable,
              SoldServicesReportTableData
            >,
          ),
          SoldServicesReportTableData,
          PrefetchHooks Function()
        > {
  $$SoldServicesReportTableTableTableManager(
    _$AppDatabase db,
    $SoldServicesReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoldServicesReportTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SoldServicesReportTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SoldServicesReportTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldServicesReportTableCompanion(
                id: id,
                item: item,
                quantity: quantity,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldServicesReportTableCompanion.insert(
                id: id,
                item: item,
                quantity: quantity,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SoldServicesReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SoldServicesReportTableTable,
      SoldServicesReportTableData,
      $$SoldServicesReportTableTableFilterComposer,
      $$SoldServicesReportTableTableOrderingComposer,
      $$SoldServicesReportTableTableAnnotationComposer,
      $$SoldServicesReportTableTableCreateCompanionBuilder,
      $$SoldServicesReportTableTableUpdateCompanionBuilder,
      (
        SoldServicesReportTableData,
        BaseReferences<
          _$AppDatabase,
          $SoldServicesReportTableTable,
          SoldServicesReportTableData
        >,
      ),
      SoldServicesReportTableData,
      PrefetchHooks Function()
    >;
typedef $$SoldPackagesReportTableTableCreateCompanionBuilder =
    SoldPackagesReportTableCompanion Function({
      Value<String> id,
      Value<String> item,
      Value<int> quantity,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });
typedef $$SoldPackagesReportTableTableUpdateCompanionBuilder =
    SoldPackagesReportTableCompanion Function({
      Value<String> id,
      Value<String> item,
      Value<int> quantity,
      Value<double> total,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<int> rowid,
    });

class $$SoldPackagesReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $SoldPackagesReportTableTable> {
  $$SoldPackagesReportTableTableFilterComposer({
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

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SoldPackagesReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SoldPackagesReportTableTable> {
  $$SoldPackagesReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SoldPackagesReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoldPackagesReportTableTable> {
  $$SoldPackagesReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );
}

class $$SoldPackagesReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SoldPackagesReportTableTable,
          SoldPackagesReportTableData,
          $$SoldPackagesReportTableTableFilterComposer,
          $$SoldPackagesReportTableTableOrderingComposer,
          $$SoldPackagesReportTableTableAnnotationComposer,
          $$SoldPackagesReportTableTableCreateCompanionBuilder,
          $$SoldPackagesReportTableTableUpdateCompanionBuilder,
          (
            SoldPackagesReportTableData,
            BaseReferences<
              _$AppDatabase,
              $SoldPackagesReportTableTable,
              SoldPackagesReportTableData
            >,
          ),
          SoldPackagesReportTableData,
          PrefetchHooks Function()
        > {
  $$SoldPackagesReportTableTableTableManager(
    _$AppDatabase db,
    $SoldPackagesReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoldPackagesReportTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SoldPackagesReportTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SoldPackagesReportTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldPackagesReportTableCompanion(
                id: id,
                item: item,
                quantity: quantity,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoldPackagesReportTableCompanion.insert(
                id: id,
                item: item,
                quantity: quantity,
                total: total,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SoldPackagesReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SoldPackagesReportTableTable,
      SoldPackagesReportTableData,
      $$SoldPackagesReportTableTableFilterComposer,
      $$SoldPackagesReportTableTableOrderingComposer,
      $$SoldPackagesReportTableTableAnnotationComposer,
      $$SoldPackagesReportTableTableCreateCompanionBuilder,
      $$SoldPackagesReportTableTableUpdateCompanionBuilder,
      (
        SoldPackagesReportTableData,
        BaseReferences<
          _$AppDatabase,
          $SoldPackagesReportTableTable,
          SoldPackagesReportTableData
        >,
      ),
      SoldPackagesReportTableData,
      PrefetchHooks Function()
    >;
typedef $$ServiceTableTableCreateCompanionBuilder =
    ServiceTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> price,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });
typedef $$ServiceTableTableUpdateCompanionBuilder =
    ServiceTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> price,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });

class $$ServiceTableTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceTableTable> {
  $$ServiceTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
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

class $$ServiceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceTableTable> {
  $$ServiceTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
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

class $$ServiceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceTableTable> {
  $$ServiceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$ServiceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceTableTable,
          ServiceTableData,
          $$ServiceTableTableFilterComposer,
          $$ServiceTableTableOrderingComposer,
          $$ServiceTableTableAnnotationComposer,
          $$ServiceTableTableCreateCompanionBuilder,
          $$ServiceTableTableUpdateCompanionBuilder,
          (
            ServiceTableData,
            BaseReferences<_$AppDatabase, $ServiceTableTable, ServiceTableData>,
          ),
          ServiceTableData,
          PrefetchHooks Function()
        > {
  $$ServiceTableTableTableManager(_$AppDatabase db, $ServiceTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => ServiceTableCompanion(
                id: id,
                name: name,
                price: price,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => ServiceTableCompanion.insert(
                id: id,
                name: name,
                price: price,
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

typedef $$ServiceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceTableTable,
      ServiceTableData,
      $$ServiceTableTableFilterComposer,
      $$ServiceTableTableOrderingComposer,
      $$ServiceTableTableAnnotationComposer,
      $$ServiceTableTableCreateCompanionBuilder,
      $$ServiceTableTableUpdateCompanionBuilder,
      (
        ServiceTableData,
        BaseReferences<_$AppDatabase, $ServiceTableTable, ServiceTableData>,
      ),
      ServiceTableData,
      PrefetchHooks Function()
    >;
typedef $$ServicePackageTableTableCreateCompanionBuilder =
    ServicePackageTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> price,
      Value<int> quantity,
    });
typedef $$ServicePackageTableTableUpdateCompanionBuilder =
    ServicePackageTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> price,
      Value<int> quantity,
    });

class $$ServicePackageTableTableFilterComposer
    extends Composer<_$AppDatabase, $ServicePackageTableTable> {
  $$ServicePackageTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicePackageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicePackageTableTable> {
  $$ServicePackageTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicePackageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicePackageTableTable> {
  $$ServicePackageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$ServicePackageTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicePackageTableTable,
          ServicePackageTableData,
          $$ServicePackageTableTableFilterComposer,
          $$ServicePackageTableTableOrderingComposer,
          $$ServicePackageTableTableAnnotationComposer,
          $$ServicePackageTableTableCreateCompanionBuilder,
          $$ServicePackageTableTableUpdateCompanionBuilder,
          (
            ServicePackageTableData,
            BaseReferences<
              _$AppDatabase,
              $ServicePackageTableTable,
              ServicePackageTableData
            >,
          ),
          ServicePackageTableData,
          PrefetchHooks Function()
        > {
  $$ServicePackageTableTableTableManager(
    _$AppDatabase db,
    $ServicePackageTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicePackageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicePackageTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ServicePackageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => ServicePackageTableCompanion(
                id: id,
                name: name,
                price: price,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => ServicePackageTableCompanion.insert(
                id: id,
                name: name,
                price: price,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicePackageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicePackageTableTable,
      ServicePackageTableData,
      $$ServicePackageTableTableFilterComposer,
      $$ServicePackageTableTableOrderingComposer,
      $$ServicePackageTableTableAnnotationComposer,
      $$ServicePackageTableTableCreateCompanionBuilder,
      $$ServicePackageTableTableUpdateCompanionBuilder,
      (
        ServicePackageTableData,
        BaseReferences<
          _$AppDatabase,
          $ServicePackageTableTable,
          ServicePackageTableData
        >,
      ),
      ServicePackageTableData,
      PrefetchHooks Function()
    >;
typedef $$AddonTableTableCreateCompanionBuilder =
    AddonTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> addonType,
      Value<double> price,
      Value<bool> isProduct,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });
typedef $$AddonTableTableUpdateCompanionBuilder =
    AddonTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> addonType,
      Value<double> price,
      Value<bool> isProduct,
      Value<String> status,
      Value<String> createdBy,
      Value<String> createdDate,
    });

class $$AddonTableTableFilterComposer
    extends Composer<_$AppDatabase, $AddonTableTable> {
  $$AddonTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addonType => $composableBuilder(
    column: $table.addonType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProduct => $composableBuilder(
    column: $table.isProduct,
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

class $$AddonTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AddonTableTable> {
  $$AddonTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addonType => $composableBuilder(
    column: $table.addonType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProduct => $composableBuilder(
    column: $table.isProduct,
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

class $$AddonTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AddonTableTable> {
  $$AddonTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get addonType =>
      $composableBuilder(column: $table.addonType, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isProduct =>
      $composableBuilder(column: $table.isProduct, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdDate => $composableBuilder(
    column: $table.createdDate,
    builder: (column) => column,
  );
}

class $$AddonTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AddonTableTable,
          AddonTableData,
          $$AddonTableTableFilterComposer,
          $$AddonTableTableOrderingComposer,
          $$AddonTableTableAnnotationComposer,
          $$AddonTableTableCreateCompanionBuilder,
          $$AddonTableTableUpdateCompanionBuilder,
          (
            AddonTableData,
            BaseReferences<_$AppDatabase, $AddonTableTable, AddonTableData>,
          ),
          AddonTableData,
          PrefetchHooks Function()
        > {
  $$AddonTableTableTableManager(_$AppDatabase db, $AddonTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AddonTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AddonTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AddonTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> addonType = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<bool> isProduct = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => AddonTableCompanion(
                id: id,
                name: name,
                addonType: addonType,
                price: price,
                isProduct: isProduct,
                status: status,
                createdBy: createdBy,
                createdDate: createdDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> addonType = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<bool> isProduct = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> createdDate = const Value.absent(),
              }) => AddonTableCompanion.insert(
                id: id,
                name: name,
                addonType: addonType,
                price: price,
                isProduct: isProduct,
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

typedef $$AddonTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AddonTableTable,
      AddonTableData,
      $$AddonTableTableFilterComposer,
      $$AddonTableTableOrderingComposer,
      $$AddonTableTableAnnotationComposer,
      $$AddonTableTableCreateCompanionBuilder,
      $$AddonTableTableUpdateCompanionBuilder,
      (
        AddonTableData,
        BaseReferences<_$AppDatabase, $AddonTableTable, AddonTableData>,
      ),
      AddonTableData,
      PrefetchHooks Function()
    >;
typedef $$ShiftReportTableTableCreateCompanionBuilder =
    ShiftReportTableCompanion Function({
      Value<String> id,
      required String date,
      required int pos,
      required int shift,
      Value<String> cashier,
      Value<String?> floating,
      Value<double?> cashFloat,
      Value<double> salesBeginning,
      Value<double> salesEnding,
      Value<double> totalSales,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<String> status,
      Value<String?> approvedBy,
      Value<String?> approvedDate,
      Value<int> rowid,
    });
typedef $$ShiftReportTableTableUpdateCompanionBuilder =
    ShiftReportTableCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<int> pos,
      Value<int> shift,
      Value<String> cashier,
      Value<String?> floating,
      Value<double?> cashFloat,
      Value<double> salesBeginning,
      Value<double> salesEnding,
      Value<double> totalSales,
      Value<int> receiptBeginning,
      Value<int> receiptEnding,
      Value<String> status,
      Value<String?> approvedBy,
      Value<String?> approvedDate,
      Value<int> rowid,
    });

class $$ShiftReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftReportTableTable> {
  $$ShiftReportTableTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get floating => $composableBuilder(
    column: $table.floating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cashFloat => $composableBuilder(
    column: $table.cashFloat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salesBeginning => $composableBuilder(
    column: $table.salesBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salesEnding => $composableBuilder(
    column: $table.salesEnding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSales => $composableBuilder(
    column: $table.totalSales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedDate => $composableBuilder(
    column: $table.approvedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftReportTableTable> {
  $$ShiftReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get floating => $composableBuilder(
    column: $table.floating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cashFloat => $composableBuilder(
    column: $table.cashFloat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salesBeginning => $composableBuilder(
    column: $table.salesBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salesEnding => $composableBuilder(
    column: $table.salesEnding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSales => $composableBuilder(
    column: $table.totalSales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedDate => $composableBuilder(
    column: $table.approvedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftReportTableTable> {
  $$ShiftReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<int> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get cashier =>
      $composableBuilder(column: $table.cashier, builder: (column) => column);

  GeneratedColumn<String> get floating =>
      $composableBuilder(column: $table.floating, builder: (column) => column);

  GeneratedColumn<double> get cashFloat =>
      $composableBuilder(column: $table.cashFloat, builder: (column) => column);

  GeneratedColumn<double> get salesBeginning => $composableBuilder(
    column: $table.salesBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salesEnding => $composableBuilder(
    column: $table.salesEnding,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSales => $composableBuilder(
    column: $table.totalSales,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptBeginning => $composableBuilder(
    column: $table.receiptBeginning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptEnding => $composableBuilder(
    column: $table.receiptEnding,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvedDate => $composableBuilder(
    column: $table.approvedDate,
    builder: (column) => column,
  );
}

class $$ShiftReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftReportTableTable,
          ShiftReportTableData,
          $$ShiftReportTableTableFilterComposer,
          $$ShiftReportTableTableOrderingComposer,
          $$ShiftReportTableTableAnnotationComposer,
          $$ShiftReportTableTableCreateCompanionBuilder,
          $$ShiftReportTableTableUpdateCompanionBuilder,
          (
            ShiftReportTableData,
            BaseReferences<
              _$AppDatabase,
              $ShiftReportTableTable,
              ShiftReportTableData
            >,
          ),
          ShiftReportTableData,
          PrefetchHooks Function()
        > {
  $$ShiftReportTableTableTableManager(
    _$AppDatabase db,
    $ShiftReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftReportTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftReportTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftReportTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> pos = const Value.absent(),
                Value<int> shift = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String?> floating = const Value.absent(),
                Value<double?> cashFloat = const Value.absent(),
                Value<double> salesBeginning = const Value.absent(),
                Value<double> salesEnding = const Value.absent(),
                Value<double> totalSales = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<String?> approvedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftReportTableCompanion(
                id: id,
                date: date,
                pos: pos,
                shift: shift,
                cashier: cashier,
                floating: floating,
                cashFloat: cashFloat,
                salesBeginning: salesBeginning,
                salesEnding: salesEnding,
                totalSales: totalSales,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                status: status,
                approvedBy: approvedBy,
                approvedDate: approvedDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String date,
                required int pos,
                required int shift,
                Value<String> cashier = const Value.absent(),
                Value<String?> floating = const Value.absent(),
                Value<double?> cashFloat = const Value.absent(),
                Value<double> salesBeginning = const Value.absent(),
                Value<double> salesEnding = const Value.absent(),
                Value<double> totalSales = const Value.absent(),
                Value<int> receiptBeginning = const Value.absent(),
                Value<int> receiptEnding = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<String?> approvedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftReportTableCompanion.insert(
                id: id,
                date: date,
                pos: pos,
                shift: shift,
                cashier: cashier,
                floating: floating,
                cashFloat: cashFloat,
                salesBeginning: salesBeginning,
                salesEnding: salesEnding,
                totalSales: totalSales,
                receiptBeginning: receiptBeginning,
                receiptEnding: receiptEnding,
                status: status,
                approvedBy: approvedBy,
                approvedDate: approvedDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftReportTableTable,
      ShiftReportTableData,
      $$ShiftReportTableTableFilterComposer,
      $$ShiftReportTableTableOrderingComposer,
      $$ShiftReportTableTableAnnotationComposer,
      $$ShiftReportTableTableCreateCompanionBuilder,
      $$ShiftReportTableTableUpdateCompanionBuilder,
      (
        ShiftReportTableData,
        BaseReferences<
          _$AppDatabase,
          $ShiftReportTableTable,
          ShiftReportTableData
        >,
      ),
      ShiftReportTableData,
      PrefetchHooks Function()
    >;
typedef $$ReceiptHistoryTableTableCreateCompanionBuilder =
    ReceiptHistoryTableCompanion Function({
      Value<String> id,
      required String detailId,
      required int posId,
      Value<int> shift,
      required String receiptDate,
      required DateTime createdAt,
      Value<String> paymentType,
      Value<String> description,
      Value<double> total,
      Value<String> cashier,
      Value<String> status,
      Value<String> ePaymentType,
      Value<String> referenceId,
      Value<String> tendersJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });
typedef $$ReceiptHistoryTableTableUpdateCompanionBuilder =
    ReceiptHistoryTableCompanion Function({
      Value<String> id,
      Value<String> detailId,
      Value<int> posId,
      Value<int> shift,
      Value<String> receiptDate,
      Value<DateTime> createdAt,
      Value<String> paymentType,
      Value<String> description,
      Value<double> total,
      Value<String> cashier,
      Value<String> status,
      Value<String> ePaymentType,
      Value<String> referenceId,
      Value<String> tendersJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$ReceiptHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptHistoryTableTable> {
  $$ReceiptHistoryTableTableFilterComposer({
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

  ColumnFilters<String> get detailId => $composableBuilder(
    column: $table.detailId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptDate => $composableBuilder(
    column: $table.receiptDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ePaymentType => $composableBuilder(
    column: $table.ePaymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tendersJson => $composableBuilder(
    column: $table.tendersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReceiptHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptHistoryTableTable> {
  $$ReceiptHistoryTableTableOrderingComposer({
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

  ColumnOrderings<String> get detailId => $composableBuilder(
    column: $table.detailId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptDate => $composableBuilder(
    column: $table.receiptDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashier => $composableBuilder(
    column: $table.cashier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ePaymentType => $composableBuilder(
    column: $table.ePaymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tendersJson => $composableBuilder(
    column: $table.tendersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceiptHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptHistoryTableTable> {
  $$ReceiptHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get detailId =>
      $composableBuilder(column: $table.detailId, builder: (column) => column);

  GeneratedColumn<int> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<int> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get receiptDate => $composableBuilder(
    column: $table.receiptDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get cashier =>
      $composableBuilder(column: $table.cashier, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get ePaymentType => $composableBuilder(
    column: $table.ePaymentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tendersJson => $composableBuilder(
    column: $table.tendersJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$ReceiptHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptHistoryTableTable,
          ReceiptHistoryTableData,
          $$ReceiptHistoryTableTableFilterComposer,
          $$ReceiptHistoryTableTableOrderingComposer,
          $$ReceiptHistoryTableTableAnnotationComposer,
          $$ReceiptHistoryTableTableCreateCompanionBuilder,
          $$ReceiptHistoryTableTableUpdateCompanionBuilder,
          (
            ReceiptHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $ReceiptHistoryTableTable,
              ReceiptHistoryTableData
            >,
          ),
          ReceiptHistoryTableData,
          PrefetchHooks Function()
        > {
  $$ReceiptHistoryTableTableTableManager(
    _$AppDatabase db,
    $ReceiptHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReceiptHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> detailId = const Value.absent(),
                Value<int> posId = const Value.absent(),
                Value<int> shift = const Value.absent(),
                Value<String> receiptDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> ePaymentType = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String> tendersJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReceiptHistoryTableCompanion(
                id: id,
                detailId: detailId,
                posId: posId,
                shift: shift,
                receiptDate: receiptDate,
                createdAt: createdAt,
                paymentType: paymentType,
                description: description,
                total: total,
                cashier: cashier,
                status: status,
                ePaymentType: ePaymentType,
                referenceId: referenceId,
                tendersJson: tendersJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String detailId,
                required int posId,
                Value<int> shift = const Value.absent(),
                required String receiptDate,
                required DateTime createdAt,
                Value<String> paymentType = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> cashier = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> ePaymentType = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String> tendersJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReceiptHistoryTableCompanion.insert(
                id: id,
                detailId: detailId,
                posId: posId,
                shift: shift,
                receiptDate: receiptDate,
                createdAt: createdAt,
                paymentType: paymentType,
                description: description,
                total: total,
                cashier: cashier,
                status: status,
                ePaymentType: ePaymentType,
                referenceId: referenceId,
                tendersJson: tendersJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReceiptHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptHistoryTableTable,
      ReceiptHistoryTableData,
      $$ReceiptHistoryTableTableFilterComposer,
      $$ReceiptHistoryTableTableOrderingComposer,
      $$ReceiptHistoryTableTableAnnotationComposer,
      $$ReceiptHistoryTableTableCreateCompanionBuilder,
      $$ReceiptHistoryTableTableUpdateCompanionBuilder,
      (
        ReceiptHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $ReceiptHistoryTableTable,
          ReceiptHistoryTableData
        >,
      ),
      ReceiptHistoryTableData,
      PrefetchHooks Function()
    >;
typedef $$CashDropTableTableCreateCompanionBuilder =
    CashDropTableCompanion Function({
      Value<String> id,
      required String branchId,
      required String posId,
      required String shift,
      required String shiftDate,
      required String cashierId,
      required String cashierName,
      required double amount,
      Value<String> linesJson,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CashDropTableTableUpdateCompanionBuilder =
    CashDropTableCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> posId,
      Value<String> shift,
      Value<String> shiftDate,
      Value<String> cashierId,
      Value<String> cashierName,
      Value<double> amount,
      Value<String> linesJson,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CashDropTableTableFilterComposer
    extends Composer<_$AppDatabase, $CashDropTableTable> {
  $$CashDropTableTableFilterComposer({
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

  ColumnFilters<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierName => $composableBuilder(
    column: $table.cashierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashDropTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CashDropTableTable> {
  $$CashDropTableTableOrderingComposer({
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

  ColumnOrderings<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierName => $composableBuilder(
    column: $table.cashierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashDropTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashDropTableTable> {
  $$CashDropTableTableAnnotationComposer({
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

  GeneratedColumn<String> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get shiftDate =>
      $composableBuilder(column: $table.shiftDate, builder: (column) => column);

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get cashierName => $composableBuilder(
    column: $table.cashierName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get linesJson =>
      $composableBuilder(column: $table.linesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CashDropTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashDropTableTable,
          CashDropTableData,
          $$CashDropTableTableFilterComposer,
          $$CashDropTableTableOrderingComposer,
          $$CashDropTableTableAnnotationComposer,
          $$CashDropTableTableCreateCompanionBuilder,
          $$CashDropTableTableUpdateCompanionBuilder,
          (
            CashDropTableData,
            BaseReferences<
              _$AppDatabase,
              $CashDropTableTable,
              CashDropTableData
            >,
          ),
          CashDropTableData,
          PrefetchHooks Function()
        > {
  $$CashDropTableTableTableManager(_$AppDatabase db, $CashDropTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashDropTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashDropTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashDropTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> posId = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> shiftDate = const Value.absent(),
                Value<String> cashierId = const Value.absent(),
                Value<String> cashierName = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> linesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashDropTableCompanion(
                id: id,
                branchId: branchId,
                posId: posId,
                shift: shift,
                shiftDate: shiftDate,
                cashierId: cashierId,
                cashierName: cashierName,
                amount: amount,
                linesJson: linesJson,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String branchId,
                required String posId,
                required String shift,
                required String shiftDate,
                required String cashierId,
                required String cashierName,
                required double amount,
                Value<String> linesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashDropTableCompanion.insert(
                id: id,
                branchId: branchId,
                posId: posId,
                shift: shift,
                shiftDate: shiftDate,
                cashierId: cashierId,
                cashierName: cashierName,
                amount: amount,
                linesJson: linesJson,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashDropTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashDropTableTable,
      CashDropTableData,
      $$CashDropTableTableFilterComposer,
      $$CashDropTableTableOrderingComposer,
      $$CashDropTableTableAnnotationComposer,
      $$CashDropTableTableCreateCompanionBuilder,
      $$CashDropTableTableUpdateCompanionBuilder,
      (
        CashDropTableData,
        BaseReferences<_$AppDatabase, $CashDropTableTable, CashDropTableData>,
      ),
      CashDropTableData,
      PrefetchHooks Function()
    >;
typedef $$SendCashReportTableTableCreateCompanionBuilder =
    SendCashReportTableCompanion Function({
      Value<String> id,
      required String branchId,
      required String posId,
      required String shift,
      required String shiftDate,
      required String cashierId,
      required double amount,
      Value<String> linesJson,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SendCashReportTableTableUpdateCompanionBuilder =
    SendCashReportTableCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> posId,
      Value<String> shift,
      Value<String> shiftDate,
      Value<String> cashierId,
      Value<double> amount,
      Value<String> linesJson,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SendCashReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $SendCashReportTableTable> {
  $$SendCashReportTableTableFilterComposer({
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

  ColumnFilters<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SendCashReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SendCashReportTableTable> {
  $$SendCashReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linesJson => $composableBuilder(
    column: $table.linesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SendCashReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SendCashReportTableTable> {
  $$SendCashReportTableTableAnnotationComposer({
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

  GeneratedColumn<String> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get shiftDate =>
      $composableBuilder(column: $table.shiftDate, builder: (column) => column);

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get linesJson =>
      $composableBuilder(column: $table.linesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SendCashReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SendCashReportTableTable,
          SendCashReportTableData,
          $$SendCashReportTableTableFilterComposer,
          $$SendCashReportTableTableOrderingComposer,
          $$SendCashReportTableTableAnnotationComposer,
          $$SendCashReportTableTableCreateCompanionBuilder,
          $$SendCashReportTableTableUpdateCompanionBuilder,
          (
            SendCashReportTableData,
            BaseReferences<
              _$AppDatabase,
              $SendCashReportTableTable,
              SendCashReportTableData
            >,
          ),
          SendCashReportTableData,
          PrefetchHooks Function()
        > {
  $$SendCashReportTableTableTableManager(
    _$AppDatabase db,
    $SendCashReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SendCashReportTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SendCashReportTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SendCashReportTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> posId = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> shiftDate = const Value.absent(),
                Value<String> cashierId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> linesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SendCashReportTableCompanion(
                id: id,
                branchId: branchId,
                posId: posId,
                shift: shift,
                shiftDate: shiftDate,
                cashierId: cashierId,
                amount: amount,
                linesJson: linesJson,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String branchId,
                required String posId,
                required String shift,
                required String shiftDate,
                required String cashierId,
                required double amount,
                Value<String> linesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SendCashReportTableCompanion.insert(
                id: id,
                branchId: branchId,
                posId: posId,
                shift: shift,
                shiftDate: shiftDate,
                cashierId: cashierId,
                amount: amount,
                linesJson: linesJson,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SendCashReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SendCashReportTableTable,
      SendCashReportTableData,
      $$SendCashReportTableTableFilterComposer,
      $$SendCashReportTableTableOrderingComposer,
      $$SendCashReportTableTableAnnotationComposer,
      $$SendCashReportTableTableCreateCompanionBuilder,
      $$SendCashReportTableTableUpdateCompanionBuilder,
      (
        SendCashReportTableData,
        BaseReferences<
          _$AppDatabase,
          $SendCashReportTableTable,
          SendCashReportTableData
        >,
      ),
      SendCashReportTableData,
      PrefetchHooks Function()
    >;
typedef $$CashReportTableTableCreateCompanionBuilder =
    CashReportTableCompanion Function({
      Value<String> id,
      required String branchId,
      required String posId,
      required int shift,
      required String shiftDate,
      Value<double> cashFloat,
      Value<double> totalCash,
      Value<String> denominationJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });
typedef $$CashReportTableTableUpdateCompanionBuilder =
    CashReportTableCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> posId,
      Value<int> shift,
      Value<String> shiftDate,
      Value<double> cashFloat,
      Value<double> totalCash,
      Value<String> denominationJson,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CashReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $CashReportTableTable> {
  $$CashReportTableTableFilterComposer({
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

  ColumnFilters<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cashFloat => $composableBuilder(
    column: $table.cashFloat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCash => $composableBuilder(
    column: $table.totalCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get denominationJson => $composableBuilder(
    column: $table.denominationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CashReportTableTable> {
  $$CashReportTableTableOrderingComposer({
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

  ColumnOrderings<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cashFloat => $composableBuilder(
    column: $table.cashFloat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCash => $composableBuilder(
    column: $table.totalCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get denominationJson => $composableBuilder(
    column: $table.denominationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashReportTableTable> {
  $$CashReportTableTableAnnotationComposer({
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

  GeneratedColumn<String> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<int> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get shiftDate =>
      $composableBuilder(column: $table.shiftDate, builder: (column) => column);

  GeneratedColumn<double> get cashFloat =>
      $composableBuilder(column: $table.cashFloat, builder: (column) => column);

  GeneratedColumn<double> get totalCash =>
      $composableBuilder(column: $table.totalCash, builder: (column) => column);

  GeneratedColumn<String> get denominationJson => $composableBuilder(
    column: $table.denominationJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CashReportTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashReportTableTable,
          CashReportTableData,
          $$CashReportTableTableFilterComposer,
          $$CashReportTableTableOrderingComposer,
          $$CashReportTableTableAnnotationComposer,
          $$CashReportTableTableCreateCompanionBuilder,
          $$CashReportTableTableUpdateCompanionBuilder,
          (
            CashReportTableData,
            BaseReferences<
              _$AppDatabase,
              $CashReportTableTable,
              CashReportTableData
            >,
          ),
          CashReportTableData,
          PrefetchHooks Function()
        > {
  $$CashReportTableTableTableManager(
    _$AppDatabase db,
    $CashReportTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashReportTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashReportTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashReportTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> posId = const Value.absent(),
                Value<int> shift = const Value.absent(),
                Value<String> shiftDate = const Value.absent(),
                Value<double> cashFloat = const Value.absent(),
                Value<double> totalCash = const Value.absent(),
                Value<String> denominationJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashReportTableCompanion(
                id: id,
                branchId: branchId,
                posId: posId,
                shift: shift,
                shiftDate: shiftDate,
                cashFloat: cashFloat,
                totalCash: totalCash,
                denominationJson: denominationJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String branchId,
                required String posId,
                required int shift,
                required String shiftDate,
                Value<double> cashFloat = const Value.absent(),
                Value<double> totalCash = const Value.absent(),
                Value<String> denominationJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashReportTableCompanion.insert(
                id: id,
                branchId: branchId,
                posId: posId,
                shift: shift,
                shiftDate: shiftDate,
                cashFloat: cashFloat,
                totalCash: totalCash,
                denominationJson: denominationJson,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashReportTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashReportTableTable,
      CashReportTableData,
      $$CashReportTableTableFilterComposer,
      $$CashReportTableTableOrderingComposer,
      $$CashReportTableTableAnnotationComposer,
      $$CashReportTableTableCreateCompanionBuilder,
      $$CashReportTableTableUpdateCompanionBuilder,
      (
        CashReportTableData,
        BaseReferences<
          _$AppDatabase,
          $CashReportTableTable,
          CashReportTableData
        >,
      ),
      CashReportTableData,
      PrefetchHooks Function()
    >;
typedef $$CustomerTableTableCreateCompanionBuilder =
    CustomerTableCompanion Function({
      Value<String> id,
      required String salesId,
      required String posId,
      required String type,
      Value<String> company,
      required String fullName,
      Value<String> email,
      Value<String> phone,
      Value<String> mobile,
      Value<String> address,
      Value<String> purchaseOrder,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$CustomerTableTableUpdateCompanionBuilder =
    CustomerTableCompanion Function({
      Value<String> id,
      Value<String> salesId,
      Value<String> posId,
      Value<String> type,
      Value<String> company,
      Value<String> fullName,
      Value<String> email,
      Value<String> phone,
      Value<String> mobile,
      Value<String> address,
      Value<String> purchaseOrder,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<DateTime?> syncedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$CustomerTableTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerTableTable> {
  $$CustomerTableTableFilterComposer({
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

  ColumnFilters<String> get salesId => $composableBuilder(
    column: $table.salesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseOrder => $composableBuilder(
    column: $table.purchaseOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomerTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerTableTable> {
  $$CustomerTableTableOrderingComposer({
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

  ColumnOrderings<String> get salesId => $composableBuilder(
    column: $table.salesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posId => $composableBuilder(
    column: $table.posId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseOrder => $composableBuilder(
    column: $table.purchaseOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomerTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerTableTable> {
  $$CustomerTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get salesId =>
      $composableBuilder(column: $table.salesId, builder: (column) => column);

  GeneratedColumn<String> get posId =>
      $composableBuilder(column: $table.posId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get purchaseOrder => $composableBuilder(
    column: $table.purchaseOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$CustomerTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomerTableTable,
          CustomerTableData,
          $$CustomerTableTableFilterComposer,
          $$CustomerTableTableOrderingComposer,
          $$CustomerTableTableAnnotationComposer,
          $$CustomerTableTableCreateCompanionBuilder,
          $$CustomerTableTableUpdateCompanionBuilder,
          (
            CustomerTableData,
            BaseReferences<
              _$AppDatabase,
              $CustomerTableTable,
              CustomerTableData
            >,
          ),
          CustomerTableData,
          PrefetchHooks Function()
        > {
  $$CustomerTableTableTableManager(_$AppDatabase db, $CustomerTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> salesId = const Value.absent(),
                Value<String> posId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> mobile = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> purchaseOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerTableCompanion(
                id: id,
                salesId: salesId,
                posId: posId,
                type: type,
                company: company,
                fullName: fullName,
                email: email,
                phone: phone,
                mobile: mobile,
                address: address,
                purchaseOrder: purchaseOrder,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String salesId,
                required String posId,
                required String type,
                Value<String> company = const Value.absent(),
                required String fullName,
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> mobile = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> purchaseOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerTableCompanion.insert(
                id: id,
                salesId: salesId,
                posId: posId,
                type: type,
                company: company,
                fullName: fullName,
                email: email,
                phone: phone,
                mobile: mobile,
                address: address,
                purchaseOrder: purchaseOrder,
                createdAt: createdAt,
                syncStatus: syncStatus,
                syncedAt: syncedAt,
                attempts: attempts,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomerTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomerTableTable,
      CustomerTableData,
      $$CustomerTableTableFilterComposer,
      $$CustomerTableTableOrderingComposer,
      $$CustomerTableTableAnnotationComposer,
      $$CustomerTableTableCreateCompanionBuilder,
      $$CustomerTableTableUpdateCompanionBuilder,
      (
        CustomerTableData,
        BaseReferences<_$AppDatabase, $CustomerTableTable, CustomerTableData>,
      ),
      CustomerTableData,
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
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$SalesTableTableTableManager get salesTable =>
      $$SalesTableTableTableManager(_db, _db.salesTable);
  $$EndShiftTableTableTableManager get endShiftTable =>
      $$EndShiftTableTableTableManager(_db, _db.endShiftTable);
  $$SoldItemsTableTableTableManager get soldItemsTable =>
      $$SoldItemsTableTableTableManager(_db, _db.soldItemsTable);
  $$CashDrawerTableTableTableManager get cashDrawerTable =>
      $$CashDrawerTableTableTableManager(_db, _db.cashDrawerTable);
  $$SoldItemsReportTableTableTableManager get soldItemsReportTable =>
      $$SoldItemsReportTableTableTableManager(_db, _db.soldItemsReportTable);
  $$PaymentSummaryReportTableTableTableManager get paymentSummaryReportTable =>
      $$PaymentSummaryReportTableTableTableManager(
        _db,
        _db.paymentSummaryReportTable,
      );
  $$StaffSalesReportTableTableTableManager get staffSalesReportTable =>
      $$StaffSalesReportTableTableTableManager(_db, _db.staffSalesReportTable);
  $$SoldServicesReportTableTableTableManager get soldServicesReportTable =>
      $$SoldServicesReportTableTableTableManager(
        _db,
        _db.soldServicesReportTable,
      );
  $$SoldPackagesReportTableTableTableManager get soldPackagesReportTable =>
      $$SoldPackagesReportTableTableTableManager(
        _db,
        _db.soldPackagesReportTable,
      );
  $$ServiceTableTableTableManager get serviceTable =>
      $$ServiceTableTableTableManager(_db, _db.serviceTable);
  $$ServicePackageTableTableTableManager get servicePackageTable =>
      $$ServicePackageTableTableTableManager(_db, _db.servicePackageTable);
  $$AddonTableTableTableManager get addonTable =>
      $$AddonTableTableTableManager(_db, _db.addonTable);
  $$ShiftReportTableTableTableManager get shiftReportTable =>
      $$ShiftReportTableTableTableManager(_db, _db.shiftReportTable);
  $$ReceiptHistoryTableTableTableManager get receiptHistoryTable =>
      $$ReceiptHistoryTableTableTableManager(_db, _db.receiptHistoryTable);
  $$CashDropTableTableTableManager get cashDropTable =>
      $$CashDropTableTableTableManager(_db, _db.cashDropTable);
  $$SendCashReportTableTableTableManager get sendCashReportTable =>
      $$SendCashReportTableTableTableManager(_db, _db.sendCashReportTable);
  $$CashReportTableTableTableManager get cashReportTable =>
      $$CashReportTableTableTableManager(_db, _db.cashReportTable);
  $$CustomerTableTableTableManager get customerTable =>
      $$CustomerTableTableTableManager(_db, _db.customerTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
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
