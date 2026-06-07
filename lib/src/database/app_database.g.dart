// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxIdMeta = const VerificationMeta('taxId');
  @override
  late final GeneratedColumn<String> taxId = GeneratedColumn<String>(
    'tax_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyOfficeTypeMeta = const VerificationMeta(
    'companyOfficeType',
  );
  @override
  late final GeneratedColumn<String> companyOfficeType =
      GeneratedColumn<String>(
        'company_office_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _faxMeta = const VerificationMeta('fax');
  @override
  late final GeneratedColumn<String> fax = GeneratedColumn<String>(
    'fax',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subDistrictMeta = const VerificationMeta(
    'subDistrict',
  );
  @override
  late final GeneratedColumn<String> subDistrict = GeneratedColumn<String>(
    'sub_district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _provinceMeta = const VerificationMeta(
    'province',
  );
  @override
  late final GeneratedColumn<String> province = GeneratedColumn<String>(
    'province',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipcodeMeta = const VerificationMeta(
    'zipcode',
  );
  @override
  late final GeneratedColumn<String> zipcode = GeneratedColumn<String>(
    'zipcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
    'line_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PERSONAL'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBlacklistedMeta = const VerificationMeta(
    'isBlacklisted',
  );
  @override
  late final GeneratedColumn<bool> isBlacklisted = GeneratedColumn<bool>(
    'is_blacklisted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_blacklisted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nickname,
    phone,
    taxId,
    companyOfficeType,
    fax,
    address,
    subDistrict,
    district,
    province,
    zipcode,
    email,
    lineId,
    remark,
    type,
    note,
    createdAt,
    updatedAt,
    isBlacklisted,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('tax_id')) {
      context.handle(
        _taxIdMeta,
        taxId.isAcceptableOrUnknown(data['tax_id']!, _taxIdMeta),
      );
    }
    if (data.containsKey('company_office_type')) {
      context.handle(
        _companyOfficeTypeMeta,
        companyOfficeType.isAcceptableOrUnknown(
          data['company_office_type']!,
          _companyOfficeTypeMeta,
        ),
      );
    }
    if (data.containsKey('fax')) {
      context.handle(
        _faxMeta,
        fax.isAcceptableOrUnknown(data['fax']!, _faxMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('sub_district')) {
      context.handle(
        _subDistrictMeta,
        subDistrict.isAcceptableOrUnknown(
          data['sub_district']!,
          _subDistrictMeta,
        ),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('province')) {
      context.handle(
        _provinceMeta,
        province.isAcceptableOrUnknown(data['province']!, _provinceMeta),
      );
    }
    if (data.containsKey('zipcode')) {
      context.handle(
        _zipcodeMeta,
        zipcode.isAcceptableOrUnknown(data['zipcode']!, _zipcodeMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_blacklisted')) {
      context.handle(
        _isBlacklistedMeta,
        isBlacklisted.isAcceptableOrUnknown(
          data['is_blacklisted']!,
          _isBlacklistedMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      taxId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_id'],
      ),
      companyOfficeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_office_type'],
      ),
      fax: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fax'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      subDistrict: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_district'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      province: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province'],
      ),
      zipcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zipcode'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_id'],
      ),
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isBlacklisted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_blacklisted'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String name;
  final String? nickname;
  final String? phone;
  final String? taxId;
  final String? companyOfficeType;
  final String? fax;
  final String? address;
  final String? subDistrict;
  final String? district;
  final String? province;
  final String? zipcode;
  final String? email;
  final String? lineId;
  final String? remark;
  final String type;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isBlacklisted;
  final bool isDeleted;
  const Customer({
    required this.id,
    required this.name,
    this.nickname,
    this.phone,
    this.taxId,
    this.companyOfficeType,
    this.fax,
    this.address,
    this.subDistrict,
    this.district,
    this.province,
    this.zipcode,
    this.email,
    this.lineId,
    this.remark,
    required this.type,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.isBlacklisted,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || taxId != null) {
      map['tax_id'] = Variable<String>(taxId);
    }
    if (!nullToAbsent || companyOfficeType != null) {
      map['company_office_type'] = Variable<String>(companyOfficeType);
    }
    if (!nullToAbsent || fax != null) {
      map['fax'] = Variable<String>(fax);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || subDistrict != null) {
      map['sub_district'] = Variable<String>(subDistrict);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || province != null) {
      map['province'] = Variable<String>(province);
    }
    if (!nullToAbsent || zipcode != null) {
      map['zipcode'] = Variable<String>(zipcode);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || lineId != null) {
      map['line_id'] = Variable<String>(lineId);
    }
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_blacklisted'] = Variable<bool>(isBlacklisted);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      taxId: taxId == null && nullToAbsent
          ? const Value.absent()
          : Value(taxId),
      companyOfficeType: companyOfficeType == null && nullToAbsent
          ? const Value.absent()
          : Value(companyOfficeType),
      fax: fax == null && nullToAbsent ? const Value.absent() : Value(fax),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      subDistrict: subDistrict == null && nullToAbsent
          ? const Value.absent()
          : Value(subDistrict),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      province: province == null && nullToAbsent
          ? const Value.absent()
          : Value(province),
      zipcode: zipcode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipcode),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      lineId: lineId == null && nullToAbsent
          ? const Value.absent()
          : Value(lineId),
      remark: remark == null && nullToAbsent
          ? const Value.absent()
          : Value(remark),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isBlacklisted: Value(isBlacklisted),
      isDeleted: Value(isDeleted),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      phone: serializer.fromJson<String?>(json['phone']),
      taxId: serializer.fromJson<String?>(json['taxId']),
      companyOfficeType: serializer.fromJson<String?>(
        json['companyOfficeType'],
      ),
      fax: serializer.fromJson<String?>(json['fax']),
      address: serializer.fromJson<String?>(json['address']),
      subDistrict: serializer.fromJson<String?>(json['subDistrict']),
      district: serializer.fromJson<String?>(json['district']),
      province: serializer.fromJson<String?>(json['province']),
      zipcode: serializer.fromJson<String?>(json['zipcode']),
      email: serializer.fromJson<String?>(json['email']),
      lineId: serializer.fromJson<String?>(json['lineId']),
      remark: serializer.fromJson<String?>(json['remark']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isBlacklisted: serializer.fromJson<bool>(json['isBlacklisted']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nickname': serializer.toJson<String?>(nickname),
      'phone': serializer.toJson<String?>(phone),
      'taxId': serializer.toJson<String?>(taxId),
      'companyOfficeType': serializer.toJson<String?>(companyOfficeType),
      'fax': serializer.toJson<String?>(fax),
      'address': serializer.toJson<String?>(address),
      'subDistrict': serializer.toJson<String?>(subDistrict),
      'district': serializer.toJson<String?>(district),
      'province': serializer.toJson<String?>(province),
      'zipcode': serializer.toJson<String?>(zipcode),
      'email': serializer.toJson<String?>(email),
      'lineId': serializer.toJson<String?>(lineId),
      'remark': serializer.toJson<String?>(remark),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isBlacklisted': serializer.toJson<bool>(isBlacklisted),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    Value<String?> nickname = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> taxId = const Value.absent(),
    Value<String?> companyOfficeType = const Value.absent(),
    Value<String?> fax = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> subDistrict = const Value.absent(),
    Value<String?> district = const Value.absent(),
    Value<String?> province = const Value.absent(),
    Value<String?> zipcode = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> lineId = const Value.absent(),
    Value<String?> remark = const Value.absent(),
    String? type,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isBlacklisted,
    bool? isDeleted,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    nickname: nickname.present ? nickname.value : this.nickname,
    phone: phone.present ? phone.value : this.phone,
    taxId: taxId.present ? taxId.value : this.taxId,
    companyOfficeType: companyOfficeType.present
        ? companyOfficeType.value
        : this.companyOfficeType,
    fax: fax.present ? fax.value : this.fax,
    address: address.present ? address.value : this.address,
    subDistrict: subDistrict.present ? subDistrict.value : this.subDistrict,
    district: district.present ? district.value : this.district,
    province: province.present ? province.value : this.province,
    zipcode: zipcode.present ? zipcode.value : this.zipcode,
    email: email.present ? email.value : this.email,
    lineId: lineId.present ? lineId.value : this.lineId,
    remark: remark.present ? remark.value : this.remark,
    type: type ?? this.type,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isBlacklisted: isBlacklisted ?? this.isBlacklisted,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      phone: data.phone.present ? data.phone.value : this.phone,
      taxId: data.taxId.present ? data.taxId.value : this.taxId,
      companyOfficeType: data.companyOfficeType.present
          ? data.companyOfficeType.value
          : this.companyOfficeType,
      fax: data.fax.present ? data.fax.value : this.fax,
      address: data.address.present ? data.address.value : this.address,
      subDistrict: data.subDistrict.present
          ? data.subDistrict.value
          : this.subDistrict,
      district: data.district.present ? data.district.value : this.district,
      province: data.province.present ? data.province.value : this.province,
      zipcode: data.zipcode.present ? data.zipcode.value : this.zipcode,
      email: data.email.present ? data.email.value : this.email,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      remark: data.remark.present ? data.remark.value : this.remark,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isBlacklisted: data.isBlacklisted.present
          ? data.isBlacklisted.value
          : this.isBlacklisted,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nickname: $nickname, ')
          ..write('phone: $phone, ')
          ..write('taxId: $taxId, ')
          ..write('companyOfficeType: $companyOfficeType, ')
          ..write('fax: $fax, ')
          ..write('address: $address, ')
          ..write('subDistrict: $subDistrict, ')
          ..write('district: $district, ')
          ..write('province: $province, ')
          ..write('zipcode: $zipcode, ')
          ..write('email: $email, ')
          ..write('lineId: $lineId, ')
          ..write('remark: $remark, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isBlacklisted: $isBlacklisted, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    nickname,
    phone,
    taxId,
    companyOfficeType,
    fax,
    address,
    subDistrict,
    district,
    province,
    zipcode,
    email,
    lineId,
    remark,
    type,
    note,
    createdAt,
    updatedAt,
    isBlacklisted,
    isDeleted,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.nickname == this.nickname &&
          other.phone == this.phone &&
          other.taxId == this.taxId &&
          other.companyOfficeType == this.companyOfficeType &&
          other.fax == this.fax &&
          other.address == this.address &&
          other.subDistrict == this.subDistrict &&
          other.district == this.district &&
          other.province == this.province &&
          other.zipcode == this.zipcode &&
          other.email == this.email &&
          other.lineId == this.lineId &&
          other.remark == this.remark &&
          other.type == this.type &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isBlacklisted == this.isBlacklisted &&
          other.isDeleted == this.isDeleted);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nickname;
  final Value<String?> phone;
  final Value<String?> taxId;
  final Value<String?> companyOfficeType;
  final Value<String?> fax;
  final Value<String?> address;
  final Value<String?> subDistrict;
  final Value<String?> district;
  final Value<String?> province;
  final Value<String?> zipcode;
  final Value<String?> email;
  final Value<String?> lineId;
  final Value<String?> remark;
  final Value<String> type;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isBlacklisted;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nickname = const Value.absent(),
    this.phone = const Value.absent(),
    this.taxId = const Value.absent(),
    this.companyOfficeType = const Value.absent(),
    this.fax = const Value.absent(),
    this.address = const Value.absent(),
    this.subDistrict = const Value.absent(),
    this.district = const Value.absent(),
    this.province = const Value.absent(),
    this.zipcode = const Value.absent(),
    this.email = const Value.absent(),
    this.lineId = const Value.absent(),
    this.remark = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isBlacklisted = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String name,
    this.nickname = const Value.absent(),
    this.phone = const Value.absent(),
    this.taxId = const Value.absent(),
    this.companyOfficeType = const Value.absent(),
    this.fax = const Value.absent(),
    this.address = const Value.absent(),
    this.subDistrict = const Value.absent(),
    this.district = const Value.absent(),
    this.province = const Value.absent(),
    this.zipcode = const Value.absent(),
    this.email = const Value.absent(),
    this.lineId = const Value.absent(),
    this.remark = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isBlacklisted = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nickname,
    Expression<String>? phone,
    Expression<String>? taxId,
    Expression<String>? companyOfficeType,
    Expression<String>? fax,
    Expression<String>? address,
    Expression<String>? subDistrict,
    Expression<String>? district,
    Expression<String>? province,
    Expression<String>? zipcode,
    Expression<String>? email,
    Expression<String>? lineId,
    Expression<String>? remark,
    Expression<String>? type,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isBlacklisted,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nickname != null) 'nickname': nickname,
      if (phone != null) 'phone': phone,
      if (taxId != null) 'tax_id': taxId,
      if (companyOfficeType != null) 'company_office_type': companyOfficeType,
      if (fax != null) 'fax': fax,
      if (address != null) 'address': address,
      if (subDistrict != null) 'sub_district': subDistrict,
      if (district != null) 'district': district,
      if (province != null) 'province': province,
      if (zipcode != null) 'zipcode': zipcode,
      if (email != null) 'email': email,
      if (lineId != null) 'line_id': lineId,
      if (remark != null) 'remark': remark,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isBlacklisted != null) 'is_blacklisted': isBlacklisted,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nickname,
    Value<String?>? phone,
    Value<String?>? taxId,
    Value<String?>? companyOfficeType,
    Value<String?>? fax,
    Value<String?>? address,
    Value<String?>? subDistrict,
    Value<String?>? district,
    Value<String?>? province,
    Value<String?>? zipcode,
    Value<String?>? email,
    Value<String?>? lineId,
    Value<String?>? remark,
    Value<String>? type,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isBlacklisted,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      taxId: taxId ?? this.taxId,
      companyOfficeType: companyOfficeType ?? this.companyOfficeType,
      fax: fax ?? this.fax,
      address: address ?? this.address,
      subDistrict: subDistrict ?? this.subDistrict,
      district: district ?? this.district,
      province: province ?? this.province,
      zipcode: zipcode ?? this.zipcode,
      email: email ?? this.email,
      lineId: lineId ?? this.lineId,
      remark: remark ?? this.remark,
      type: type ?? this.type,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBlacklisted: isBlacklisted ?? this.isBlacklisted,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (taxId.present) {
      map['tax_id'] = Variable<String>(taxId.value);
    }
    if (companyOfficeType.present) {
      map['company_office_type'] = Variable<String>(companyOfficeType.value);
    }
    if (fax.present) {
      map['fax'] = Variable<String>(fax.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (subDistrict.present) {
      map['sub_district'] = Variable<String>(subDistrict.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (province.present) {
      map['province'] = Variable<String>(province.value);
    }
    if (zipcode.present) {
      map['zipcode'] = Variable<String>(zipcode.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isBlacklisted.present) {
      map['is_blacklisted'] = Variable<bool>(isBlacklisted.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nickname: $nickname, ')
          ..write('phone: $phone, ')
          ..write('taxId: $taxId, ')
          ..write('companyOfficeType: $companyOfficeType, ')
          ..write('fax: $fax, ')
          ..write('address: $address, ')
          ..write('subDistrict: $subDistrict, ')
          ..write('district: $district, ')
          ..write('province: $province, ')
          ..write('zipcode: $zipcode, ')
          ..write('email: $email, ')
          ..write('lineId: $lineId, ')
          ..write('remark: $remark, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isBlacklisted: $isBlacklisted, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordSaltMeta = const VerificationMeta(
    'passwordSalt',
  );
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
    'password_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    username,
    passwordHash,
    passwordSalt,
    phone,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
        _passwordSaltMeta,
        passwordSalt.isAcceptableOrUnknown(
          data['password_salt']!,
          _passwordSaltMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      passwordSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_salt'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String fullName;
  final String username;
  final String passwordHash;
  final String passwordSalt;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.passwordHash,
    required this.passwordSalt,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['password_salt'] = Variable<String>(passwordSalt);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      username: Value(username),
      passwordHash: Value(passwordHash),
      passwordSalt: Value(passwordSalt),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      phone: serializer.fromJson<String?>(json['phone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'phone': serializer.toJson<String?>(phone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? passwordHash,
    String? passwordSalt,
    Value<String?> phone = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => User(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    passwordSalt: passwordSalt ?? this.passwordSalt,
    phone: phone.present ? phone.value : this.phone,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      phone: data.phone.present ? data.phone.value : this.phone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    username,
    passwordHash,
    passwordSalt,
    phone,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.passwordSalt == this.passwordSalt &&
          other.phone == this.phone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> passwordSalt;
  final Value<String?> phone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String fullName,
    required String username,
    required String passwordHash,
    required String passwordSalt,
    this.phone = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       username = Value(username),
       passwordHash = Value(passwordHash),
       passwordSalt = Value(passwordSalt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? passwordSalt,
    Expression<String>? phone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (phone != null) 'phone': phone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String>? passwordSalt,
    Value<String?>? phone,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    salePrice,
    remark,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String code;
  final String name;
  final double salePrice;
  final String? remark;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.salePrice,
    this.remark,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['sale_price'] = Variable<double>(salePrice);
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      salePrice: Value(salePrice),
      remark: remark == null && nullToAbsent
          ? const Value.absent()
          : Value(remark),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      remark: serializer.fromJson<String?>(json['remark']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'salePrice': serializer.toJson<double>(salePrice),
      'remark': serializer.toJson<String?>(remark),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Product copyWith({
    String? id,
    String? code,
    String? name,
    double? salePrice,
    Value<String?> remark = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => Product(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    salePrice: salePrice ?? this.salePrice,
    remark: remark.present ? remark.value : this.remark,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      remark: data.remark.present ? data.remark.value : this.remark,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('salePrice: $salePrice, ')
          ..write('remark: $remark, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    salePrice,
    remark,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.salePrice == this.salePrice &&
          other.remark == this.remark &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<double> salePrice;
  final Value<String?> remark;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.remark = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String code,
    required String name,
    required double salePrice,
    this.remark = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       salePrice = Value(salePrice),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<double>? salePrice,
    Expression<String>? remark,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (salePrice != null) 'sale_price': salePrice,
      if (remark != null) 'remark': remark,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<double>? salePrice,
    Value<String?>? remark,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      salePrice: salePrice ?? this.salePrice,
      remark: remark ?? this.remark,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('salePrice: $salePrice, ')
          ..write('remark: $remark, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleNumberMeta = const VerificationMeta(
    'saleNumber',
  );
  @override
  late final GeneratedColumn<String> saleNumber = GeneratedColumn<String>(
    'sale_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatOptionMeta = const VerificationMeta(
    'vatOption',
  );
  @override
  late final GeneratedColumn<String> vatOption = GeneratedColumn<String>(
    'vat_option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatRateMeta = const VerificationMeta(
    'vatRate',
  );
  @override
  late final GeneratedColumn<double> vatRate = GeneratedColumn<double>(
    'vat_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatAmountMeta = const VerificationMeta(
    'vatAmount',
  );
  @override
  late final GeneratedColumn<double> vatAmount = GeneratedColumn<double>(
    'vat_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downPaymentPercentMeta =
      const VerificationMeta('downPaymentPercent');
  @override
  late final GeneratedColumn<double> downPaymentPercent =
      GeneratedColumn<double>(
        'down_payment_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _downPaymentAmountMeta = const VerificationMeta(
    'downPaymentAmount',
  );
  @override
  late final GeneratedColumn<double> downPaymentAmount =
      GeneratedColumn<double>(
        'down_payment_amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _remainingAmountMeta = const VerificationMeta(
    'remainingAmount',
  );
  @override
  late final GeneratedColumn<double> remainingAmount = GeneratedColumn<double>(
    'remaining_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentCountMeta = const VerificationMeta(
    'installmentCount',
  );
  @override
  late final GeneratedColumn<int> installmentCount = GeneratedColumn<int>(
    'installment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _installmentAmountMeta = const VerificationMeta(
    'installmentAmount',
  );
  @override
  late final GeneratedColumn<double> installmentAmount =
      GeneratedColumn<double>(
        'installment_amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleNumber,
    customerId,
    customerName,
    vatOption,
    vatRate,
    subtotal,
    vatAmount,
    grandTotal,
    downPaymentPercent,
    downPaymentAmount,
    remainingAmount,
    installmentCount,
    installmentAmount,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_number')) {
      context.handle(
        _saleNumberMeta,
        saleNumber.isAcceptableOrUnknown(data['sale_number']!, _saleNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_saleNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('vat_option')) {
      context.handle(
        _vatOptionMeta,
        vatOption.isAcceptableOrUnknown(data['vat_option']!, _vatOptionMeta),
      );
    } else if (isInserting) {
      context.missing(_vatOptionMeta);
    }
    if (data.containsKey('vat_rate')) {
      context.handle(
        _vatRateMeta,
        vatRate.isAcceptableOrUnknown(data['vat_rate']!, _vatRateMeta),
      );
    } else if (isInserting) {
      context.missing(_vatRateMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('vat_amount')) {
      context.handle(
        _vatAmountMeta,
        vatAmount.isAcceptableOrUnknown(data['vat_amount']!, _vatAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_vatAmountMeta);
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('down_payment_percent')) {
      context.handle(
        _downPaymentPercentMeta,
        downPaymentPercent.isAcceptableOrUnknown(
          data['down_payment_percent']!,
          _downPaymentPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downPaymentPercentMeta);
    }
    if (data.containsKey('down_payment_amount')) {
      context.handle(
        _downPaymentAmountMeta,
        downPaymentAmount.isAcceptableOrUnknown(
          data['down_payment_amount']!,
          _downPaymentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downPaymentAmountMeta);
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
        _remainingAmountMeta,
        remainingAmount.isAcceptableOrUnknown(
          data['remaining_amount']!,
          _remainingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingAmountMeta);
    }
    if (data.containsKey('installment_count')) {
      context.handle(
        _installmentCountMeta,
        installmentCount.isAcceptableOrUnknown(
          data['installment_count']!,
          _installmentCountMeta,
        ),
      );
    }
    if (data.containsKey('installment_amount')) {
      context.handle(
        _installmentAmountMeta,
        installmentAmount.isAcceptableOrUnknown(
          data['installment_amount']!,
          _installmentAmountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_number'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      vatOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_option'],
      )!,
      vatRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vat_rate'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      vatAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vat_amount'],
      )!,
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grand_total'],
      )!,
      downPaymentPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}down_payment_percent'],
      )!,
      downPaymentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}down_payment_amount'],
      )!,
      remainingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_amount'],
      )!,
      installmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_count'],
      )!,
      installmentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}installment_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String saleNumber;
  final String customerId;
  final String customerName;
  final String vatOption;
  final double vatRate;
  final double subtotal;
  final double vatAmount;
  final double grandTotal;
  final double downPaymentPercent;
  final double downPaymentAmount;
  final double remainingAmount;
  final int installmentCount;
  final double installmentAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const Sale({
    required this.id,
    required this.saleNumber,
    required this.customerId,
    required this.customerName,
    required this.vatOption,
    required this.vatRate,
    required this.subtotal,
    required this.vatAmount,
    required this.grandTotal,
    required this.downPaymentPercent,
    required this.downPaymentAmount,
    required this.remainingAmount,
    required this.installmentCount,
    required this.installmentAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_number'] = Variable<String>(saleNumber);
    map['customer_id'] = Variable<String>(customerId);
    map['customer_name'] = Variable<String>(customerName);
    map['vat_option'] = Variable<String>(vatOption);
    map['vat_rate'] = Variable<double>(vatRate);
    map['subtotal'] = Variable<double>(subtotal);
    map['vat_amount'] = Variable<double>(vatAmount);
    map['grand_total'] = Variable<double>(grandTotal);
    map['down_payment_percent'] = Variable<double>(downPaymentPercent);
    map['down_payment_amount'] = Variable<double>(downPaymentAmount);
    map['remaining_amount'] = Variable<double>(remainingAmount);
    map['installment_count'] = Variable<int>(installmentCount);
    map['installment_amount'] = Variable<double>(installmentAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      saleNumber: Value(saleNumber),
      customerId: Value(customerId),
      customerName: Value(customerName),
      vatOption: Value(vatOption),
      vatRate: Value(vatRate),
      subtotal: Value(subtotal),
      vatAmount: Value(vatAmount),
      grandTotal: Value(grandTotal),
      downPaymentPercent: Value(downPaymentPercent),
      downPaymentAmount: Value(downPaymentAmount),
      remainingAmount: Value(remainingAmount),
      installmentCount: Value(installmentCount),
      installmentAmount: Value(installmentAmount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      saleNumber: serializer.fromJson<String>(json['saleNumber']),
      customerId: serializer.fromJson<String>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      vatOption: serializer.fromJson<String>(json['vatOption']),
      vatRate: serializer.fromJson<double>(json['vatRate']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      vatAmount: serializer.fromJson<double>(json['vatAmount']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      downPaymentPercent: serializer.fromJson<double>(
        json['downPaymentPercent'],
      ),
      downPaymentAmount: serializer.fromJson<double>(json['downPaymentAmount']),
      remainingAmount: serializer.fromJson<double>(json['remainingAmount']),
      installmentCount: serializer.fromJson<int>(json['installmentCount']),
      installmentAmount: serializer.fromJson<double>(json['installmentAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleNumber': serializer.toJson<String>(saleNumber),
      'customerId': serializer.toJson<String>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'vatOption': serializer.toJson<String>(vatOption),
      'vatRate': serializer.toJson<double>(vatRate),
      'subtotal': serializer.toJson<double>(subtotal),
      'vatAmount': serializer.toJson<double>(vatAmount),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'downPaymentPercent': serializer.toJson<double>(downPaymentPercent),
      'downPaymentAmount': serializer.toJson<double>(downPaymentAmount),
      'remainingAmount': serializer.toJson<double>(remainingAmount),
      'installmentCount': serializer.toJson<int>(installmentCount),
      'installmentAmount': serializer.toJson<double>(installmentAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Sale copyWith({
    String? id,
    String? saleNumber,
    String? customerId,
    String? customerName,
    String? vatOption,
    double? vatRate,
    double? subtotal,
    double? vatAmount,
    double? grandTotal,
    double? downPaymentPercent,
    double? downPaymentAmount,
    double? remainingAmount,
    int? installmentCount,
    double? installmentAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => Sale(
    id: id ?? this.id,
    saleNumber: saleNumber ?? this.saleNumber,
    customerId: customerId ?? this.customerId,
    customerName: customerName ?? this.customerName,
    vatOption: vatOption ?? this.vatOption,
    vatRate: vatRate ?? this.vatRate,
    subtotal: subtotal ?? this.subtotal,
    vatAmount: vatAmount ?? this.vatAmount,
    grandTotal: grandTotal ?? this.grandTotal,
    downPaymentPercent: downPaymentPercent ?? this.downPaymentPercent,
    downPaymentAmount: downPaymentAmount ?? this.downPaymentAmount,
    remainingAmount: remainingAmount ?? this.remainingAmount,
    installmentCount: installmentCount ?? this.installmentCount,
    installmentAmount: installmentAmount ?? this.installmentAmount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      saleNumber: data.saleNumber.present
          ? data.saleNumber.value
          : this.saleNumber,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      vatOption: data.vatOption.present ? data.vatOption.value : this.vatOption,
      vatRate: data.vatRate.present ? data.vatRate.value : this.vatRate,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      vatAmount: data.vatAmount.present ? data.vatAmount.value : this.vatAmount,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      downPaymentPercent: data.downPaymentPercent.present
          ? data.downPaymentPercent.value
          : this.downPaymentPercent,
      downPaymentAmount: data.downPaymentAmount.present
          ? data.downPaymentAmount.value
          : this.downPaymentAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      installmentCount: data.installmentCount.present
          ? data.installmentCount.value
          : this.installmentCount,
      installmentAmount: data.installmentAmount.present
          ? data.installmentAmount.value
          : this.installmentAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('saleNumber: $saleNumber, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('vatOption: $vatOption, ')
          ..write('vatRate: $vatRate, ')
          ..write('subtotal: $subtotal, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('downPaymentPercent: $downPaymentPercent, ')
          ..write('downPaymentAmount: $downPaymentAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('installmentCount: $installmentCount, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleNumber,
    customerId,
    customerName,
    vatOption,
    vatRate,
    subtotal,
    vatAmount,
    grandTotal,
    downPaymentPercent,
    downPaymentAmount,
    remainingAmount,
    installmentCount,
    installmentAmount,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.saleNumber == this.saleNumber &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.vatOption == this.vatOption &&
          other.vatRate == this.vatRate &&
          other.subtotal == this.subtotal &&
          other.vatAmount == this.vatAmount &&
          other.grandTotal == this.grandTotal &&
          other.downPaymentPercent == this.downPaymentPercent &&
          other.downPaymentAmount == this.downPaymentAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.installmentCount == this.installmentCount &&
          other.installmentAmount == this.installmentAmount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String> saleNumber;
  final Value<String> customerId;
  final Value<String> customerName;
  final Value<String> vatOption;
  final Value<double> vatRate;
  final Value<double> subtotal;
  final Value<double> vatAmount;
  final Value<double> grandTotal;
  final Value<double> downPaymentPercent;
  final Value<double> downPaymentAmount;
  final Value<double> remainingAmount;
  final Value<int> installmentCount;
  final Value<double> installmentAmount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.saleNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.vatOption = const Value.absent(),
    this.vatRate = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.vatAmount = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.downPaymentPercent = const Value.absent(),
    this.downPaymentAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.installmentCount = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String saleNumber,
    required String customerId,
    required String customerName,
    required String vatOption,
    required double vatRate,
    required double subtotal,
    required double vatAmount,
    required double grandTotal,
    required double downPaymentPercent,
    required double downPaymentAmount,
    required double remainingAmount,
    this.installmentCount = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleNumber = Value(saleNumber),
       customerId = Value(customerId),
       customerName = Value(customerName),
       vatOption = Value(vatOption),
       vatRate = Value(vatRate),
       subtotal = Value(subtotal),
       vatAmount = Value(vatAmount),
       grandTotal = Value(grandTotal),
       downPaymentPercent = Value(downPaymentPercent),
       downPaymentAmount = Value(downPaymentAmount),
       remainingAmount = Value(remainingAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? saleNumber,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? vatOption,
    Expression<double>? vatRate,
    Expression<double>? subtotal,
    Expression<double>? vatAmount,
    Expression<double>? grandTotal,
    Expression<double>? downPaymentPercent,
    Expression<double>? downPaymentAmount,
    Expression<double>? remainingAmount,
    Expression<int>? installmentCount,
    Expression<double>? installmentAmount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleNumber != null) 'sale_number': saleNumber,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (vatOption != null) 'vat_option': vatOption,
      if (vatRate != null) 'vat_rate': vatRate,
      if (subtotal != null) 'subtotal': subtotal,
      if (vatAmount != null) 'vat_amount': vatAmount,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (downPaymentPercent != null)
        'down_payment_percent': downPaymentPercent,
      if (downPaymentAmount != null) 'down_payment_amount': downPaymentAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (installmentCount != null) 'installment_count': installmentCount,
      if (installmentAmount != null) 'installment_amount': installmentAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? saleNumber,
    Value<String>? customerId,
    Value<String>? customerName,
    Value<String>? vatOption,
    Value<double>? vatRate,
    Value<double>? subtotal,
    Value<double>? vatAmount,
    Value<double>? grandTotal,
    Value<double>? downPaymentPercent,
    Value<double>? downPaymentAmount,
    Value<double>? remainingAmount,
    Value<int>? installmentCount,
    Value<double>? installmentAmount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      saleNumber: saleNumber ?? this.saleNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      vatOption: vatOption ?? this.vatOption,
      vatRate: vatRate ?? this.vatRate,
      subtotal: subtotal ?? this.subtotal,
      vatAmount: vatAmount ?? this.vatAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      downPaymentPercent: downPaymentPercent ?? this.downPaymentPercent,
      downPaymentAmount: downPaymentAmount ?? this.downPaymentAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      installmentCount: installmentCount ?? this.installmentCount,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleNumber.present) {
      map['sale_number'] = Variable<String>(saleNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (vatOption.present) {
      map['vat_option'] = Variable<String>(vatOption.value);
    }
    if (vatRate.present) {
      map['vat_rate'] = Variable<double>(vatRate.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (vatAmount.present) {
      map['vat_amount'] = Variable<double>(vatAmount.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (downPaymentPercent.present) {
      map['down_payment_percent'] = Variable<double>(downPaymentPercent.value);
    }
    if (downPaymentAmount.present) {
      map['down_payment_amount'] = Variable<double>(downPaymentAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<double>(remainingAmount.value);
    }
    if (installmentCount.present) {
      map['installment_count'] = Variable<int>(installmentCount.value);
    }
    if (installmentAmount.present) {
      map['installment_amount'] = Variable<double>(installmentAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('saleNumber: $saleNumber, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('vatOption: $vatOption, ')
          ..write('vatRate: $vatRate, ')
          ..write('subtotal: $subtotal, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('downPaymentPercent: $downPaymentPercent, ')
          ..write('downPaymentAmount: $downPaymentAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('installmentCount: $installmentCount, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCodeMeta = const VerificationMeta(
    'productCode',
  );
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
    'product_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    productCode,
    productName,
    quantity,
    unitPrice,
    lineTotal,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_code')) {
      context.handle(
        _productCodeMeta,
        productCode.isAcceptableOrUnknown(
          data['product_code']!,
          _productCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCodeMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_code'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_total'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final String id;
  final String saleId;
  final String productId;
  final String productCode;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double lineTotal;
  final DateTime createdAt;
  const SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['product_code'] = Variable<String>(productCode);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['line_total'] = Variable<double>(lineTotal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      productCode: Value(productCode),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
      createdAt: Value(createdAt),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      productCode: serializer.fromJson<String>(json['productCode']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'productCode': serializer.toJson<String>(productCode),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SaleItem copyWith({
    String? id,
    String? saleId,
    String? productId,
    String? productCode,
    String? productName,
    double? quantity,
    double? unitPrice,
    double? lineTotal,
    DateTime? createdAt,
  }) => SaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    productCode: productCode ?? this.productCode,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    lineTotal: lineTotal ?? this.lineTotal,
    createdAt: createdAt ?? this.createdAt,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productCode: data.productCode.present
          ? data.productCode.value
          : this.productCode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    productCode,
    productName,
    quantity,
    unitPrice,
    lineTotal,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal &&
          other.createdAt == this.createdAt);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> productCode;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> lineTotal;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required String productCode,
    required String productName,
    required double quantity,
    required double unitPrice,
    required double lineTotal,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       productCode = Value(productCode),
       productName = Value(productName),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal),
       createdAt = Value(createdAt);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? lineTotal,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<String>? productCode,
    Value<String>? productName,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<double>? lineTotal,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleInstallmentsTable extends SaleInstallments
    with TableInfo<$SaleInstallmentsTable, SaleInstallment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleInstallmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentNumberMeta = const VerificationMeta(
    'installmentNumber',
  );
  @override
  late final GeneratedColumn<int> installmentNumber = GeneratedColumn<int>(
    'installment_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAmountMeta = const VerificationMeta(
    'dueAmount',
  );
  @override
  late final GeneratedColumn<double> dueAmount = GeneratedColumn<double>(
    'due_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    installmentNumber,
    dueDate,
    dueAmount,
    paidAmount,
    paidAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_installments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleInstallment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('installment_number')) {
      context.handle(
        _installmentNumberMeta,
        installmentNumber.isAcceptableOrUnknown(
          data['installment_number']!,
          _installmentNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentNumberMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('due_amount')) {
      context.handle(
        _dueAmountMeta,
        dueAmount.isAcceptableOrUnknown(data['due_amount']!, _dueAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAmountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleInstallment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleInstallment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      installmentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_number'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      dueAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}due_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SaleInstallmentsTable createAlias(String alias) {
    return $SaleInstallmentsTable(attachedDatabase, alias);
  }
}

class SaleInstallment extends DataClass implements Insertable<SaleInstallment> {
  final String id;
  final String saleId;
  final int installmentNumber;
  final DateTime dueDate;
  final double dueAmount;
  final double paidAmount;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SaleInstallment({
    required this.id,
    required this.saleId,
    required this.installmentNumber,
    required this.dueDate,
    required this.dueAmount,
    required this.paidAmount,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['installment_number'] = Variable<int>(installmentNumber);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['due_amount'] = Variable<double>(dueAmount);
    map['paid_amount'] = Variable<double>(paidAmount);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SaleInstallmentsCompanion toCompanion(bool nullToAbsent) {
    return SaleInstallmentsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      installmentNumber: Value(installmentNumber),
      dueDate: Value(dueDate),
      dueAmount: Value(dueAmount),
      paidAmount: Value(paidAmount),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SaleInstallment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleInstallment(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      installmentNumber: serializer.fromJson<int>(json['installmentNumber']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      dueAmount: serializer.fromJson<double>(json['dueAmount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'installmentNumber': serializer.toJson<int>(installmentNumber),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'dueAmount': serializer.toJson<double>(dueAmount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SaleInstallment copyWith({
    String? id,
    String? saleId,
    int? installmentNumber,
    DateTime? dueDate,
    double? dueAmount,
    double? paidAmount,
    Value<DateTime?> paidAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SaleInstallment(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    installmentNumber: installmentNumber ?? this.installmentNumber,
    dueDate: dueDate ?? this.dueDate,
    dueAmount: dueAmount ?? this.dueAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SaleInstallment copyWithCompanion(SaleInstallmentsCompanion data) {
    return SaleInstallment(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      installmentNumber: data.installmentNumber.present
          ? data.installmentNumber.value
          : this.installmentNumber,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueAmount: data.dueAmount.present ? data.dueAmount.value : this.dueAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleInstallment(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueAmount: $dueAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    installmentNumber,
    dueDate,
    dueAmount,
    paidAmount,
    paidAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleInstallment &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.installmentNumber == this.installmentNumber &&
          other.dueDate == this.dueDate &&
          other.dueAmount == this.dueAmount &&
          other.paidAmount == this.paidAmount &&
          other.paidAt == this.paidAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SaleInstallmentsCompanion extends UpdateCompanion<SaleInstallment> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<int> installmentNumber;
  final Value<DateTime> dueDate;
  final Value<double> dueAmount;
  final Value<double> paidAmount;
  final Value<DateTime?> paidAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SaleInstallmentsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.installmentNumber = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleInstallmentsCompanion.insert({
    required String id,
    required String saleId,
    required int installmentNumber,
    required DateTime dueDate,
    required double dueAmount,
    this.paidAmount = const Value.absent(),
    this.paidAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       installmentNumber = Value(installmentNumber),
       dueDate = Value(dueDate),
       dueAmount = Value(dueAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SaleInstallment> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<int>? installmentNumber,
    Expression<DateTime>? dueDate,
    Expression<double>? dueAmount,
    Expression<double>? paidAmount,
    Expression<DateTime>? paidAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (installmentNumber != null) 'installment_number': installmentNumber,
      if (dueDate != null) 'due_date': dueDate,
      if (dueAmount != null) 'due_amount': dueAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (paidAt != null) 'paid_at': paidAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleInstallmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<int>? installmentNumber,
    Value<DateTime>? dueDate,
    Value<double>? dueAmount,
    Value<double>? paidAmount,
    Value<DateTime?>? paidAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SaleInstallmentsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      dueAmount: dueAmount ?? this.dueAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (installmentNumber.present) {
      map['installment_number'] = Variable<int>(installmentNumber.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueAmount.present) {
      map['due_amount'] = Variable<double>(dueAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleInstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueAmount: $dueAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalePaymentLogsTable extends SalePaymentLogs
    with TableInfo<$SalePaymentLogsTable, SalePaymentLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalePaymentLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentIdMeta = const VerificationMeta(
    'installmentId',
  );
  @override
  late final GeneratedColumn<String> installmentId = GeneratedColumn<String>(
    'installment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentNumberMeta = const VerificationMeta(
    'installmentNumber',
  );
  @override
  late final GeneratedColumn<int> installmentNumber = GeneratedColumn<int>(
    'installment_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverNameMeta = const VerificationMeta(
    'receiverName',
  );
  @override
  late final GeneratedColumn<String> receiverName = GeneratedColumn<String>(
    'receiver_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ระบบ'),
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    installmentId,
    installmentNumber,
    paidAmount,
    receiverName,
    paidAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_payment_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalePaymentLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('installment_id')) {
      context.handle(
        _installmentIdMeta,
        installmentId.isAcceptableOrUnknown(
          data['installment_id']!,
          _installmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentIdMeta);
    }
    if (data.containsKey('installment_number')) {
      context.handle(
        _installmentNumberMeta,
        installmentNumber.isAcceptableOrUnknown(
          data['installment_number']!,
          _installmentNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentNumberMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAmountMeta);
    }
    if (data.containsKey('receiver_name')) {
      context.handle(
        _receiverNameMeta,
        receiverName.isAcceptableOrUnknown(
          data['receiver_name']!,
          _receiverNameMeta,
        ),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalePaymentLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalePaymentLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      installmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installment_id'],
      )!,
      installmentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_number'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      receiverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receiver_name'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SalePaymentLogsTable createAlias(String alias) {
    return $SalePaymentLogsTable(attachedDatabase, alias);
  }
}

class SalePaymentLog extends DataClass implements Insertable<SalePaymentLog> {
  final String id;
  final String saleId;
  final String installmentId;
  final int installmentNumber;
  final double paidAmount;
  final String receiverName;
  final DateTime paidAt;
  final DateTime createdAt;
  const SalePaymentLog({
    required this.id,
    required this.saleId,
    required this.installmentId,
    required this.installmentNumber,
    required this.paidAmount,
    required this.receiverName,
    required this.paidAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['installment_id'] = Variable<String>(installmentId);
    map['installment_number'] = Variable<int>(installmentNumber);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['receiver_name'] = Variable<String>(receiverName);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalePaymentLogsCompanion toCompanion(bool nullToAbsent) {
    return SalePaymentLogsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      installmentId: Value(installmentId),
      installmentNumber: Value(installmentNumber),
      paidAmount: Value(paidAmount),
      receiverName: Value(receiverName),
      paidAt: Value(paidAt),
      createdAt: Value(createdAt),
    );
  }

  factory SalePaymentLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalePaymentLog(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      installmentId: serializer.fromJson<String>(json['installmentId']),
      installmentNumber: serializer.fromJson<int>(json['installmentNumber']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      receiverName: serializer.fromJson<String>(json['receiverName']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'installmentId': serializer.toJson<String>(installmentId),
      'installmentNumber': serializer.toJson<int>(installmentNumber),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'receiverName': serializer.toJson<String>(receiverName),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SalePaymentLog copyWith({
    String? id,
    String? saleId,
    String? installmentId,
    int? installmentNumber,
    double? paidAmount,
    String? receiverName,
    DateTime? paidAt,
    DateTime? createdAt,
  }) => SalePaymentLog(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    installmentId: installmentId ?? this.installmentId,
    installmentNumber: installmentNumber ?? this.installmentNumber,
    paidAmount: paidAmount ?? this.paidAmount,
    receiverName: receiverName ?? this.receiverName,
    paidAt: paidAt ?? this.paidAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SalePaymentLog copyWithCompanion(SalePaymentLogsCompanion data) {
    return SalePaymentLog(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      installmentId: data.installmentId.present
          ? data.installmentId.value
          : this.installmentId,
      installmentNumber: data.installmentNumber.present
          ? data.installmentNumber.value
          : this.installmentNumber,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      receiverName: data.receiverName.present
          ? data.receiverName.value
          : this.receiverName,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalePaymentLog(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('installmentId: $installmentId, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('receiverName: $receiverName, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    installmentId,
    installmentNumber,
    paidAmount,
    receiverName,
    paidAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalePaymentLog &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.installmentId == this.installmentId &&
          other.installmentNumber == this.installmentNumber &&
          other.paidAmount == this.paidAmount &&
          other.receiverName == this.receiverName &&
          other.paidAt == this.paidAt &&
          other.createdAt == this.createdAt);
}

class SalePaymentLogsCompanion extends UpdateCompanion<SalePaymentLog> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> installmentId;
  final Value<int> installmentNumber;
  final Value<double> paidAmount;
  final Value<String> receiverName;
  final Value<DateTime> paidAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SalePaymentLogsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.installmentId = const Value.absent(),
    this.installmentNumber = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.receiverName = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalePaymentLogsCompanion.insert({
    required String id,
    required String saleId,
    required String installmentId,
    required int installmentNumber,
    required double paidAmount,
    this.receiverName = const Value.absent(),
    required DateTime paidAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       installmentId = Value(installmentId),
       installmentNumber = Value(installmentNumber),
       paidAmount = Value(paidAmount),
       paidAt = Value(paidAt),
       createdAt = Value(createdAt);
  static Insertable<SalePaymentLog> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? installmentId,
    Expression<int>? installmentNumber,
    Expression<double>? paidAmount,
    Expression<String>? receiverName,
    Expression<DateTime>? paidAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (installmentId != null) 'installment_id': installmentId,
      if (installmentNumber != null) 'installment_number': installmentNumber,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (receiverName != null) 'receiver_name': receiverName,
      if (paidAt != null) 'paid_at': paidAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalePaymentLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? installmentId,
    Value<int>? installmentNumber,
    Value<double>? paidAmount,
    Value<String>? receiverName,
    Value<DateTime>? paidAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SalePaymentLogsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      installmentId: installmentId ?? this.installmentId,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      paidAmount: paidAmount ?? this.paidAmount,
      receiverName: receiverName ?? this.receiverName,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (installmentId.present) {
      map['installment_id'] = Variable<String>(installmentId.value);
    }
    if (installmentNumber.present) {
      map['installment_number'] = Variable<int>(installmentNumber.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (receiverName.present) {
      map['receiver_name'] = Variable<String>(receiverName.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalePaymentLogsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('installmentId: $installmentId, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('receiverName: $receiverName, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $SaleInstallmentsTable saleInstallments = $SaleInstallmentsTable(
    this,
  );
  late final $SalePaymentLogsTable salePaymentLogs = $SalePaymentLogsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customers,
    users,
    products,
    sales,
    saleItems,
    saleInstallments,
    salePaymentLogs,
  ];
}

typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String name,
      Value<String?> nickname,
      Value<String?> phone,
      Value<String?> taxId,
      Value<String?> companyOfficeType,
      Value<String?> fax,
      Value<String?> address,
      Value<String?> subDistrict,
      Value<String?> district,
      Value<String?> province,
      Value<String?> zipcode,
      Value<String?> email,
      Value<String?> lineId,
      Value<String?> remark,
      Value<String> type,
      Value<String?> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isBlacklisted,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nickname,
      Value<String?> phone,
      Value<String?> taxId,
      Value<String?> companyOfficeType,
      Value<String?> fax,
      Value<String?> address,
      Value<String?> subDistrict,
      Value<String?> district,
      Value<String?> province,
      Value<String?> zipcode,
      Value<String?> email,
      Value<String?> lineId,
      Value<String?> remark,
      Value<String> type,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isBlacklisted,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxId => $composableBuilder(
    column: $table.taxId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyOfficeType => $composableBuilder(
    column: $table.companyOfficeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fax => $composableBuilder(
    column: $table.fax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subDistrict => $composableBuilder(
    column: $table.subDistrict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zipcode => $composableBuilder(
    column: $table.zipcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBlacklisted => $composableBuilder(
    column: $table.isBlacklisted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxId => $composableBuilder(
    column: $table.taxId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyOfficeType => $composableBuilder(
    column: $table.companyOfficeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fax => $composableBuilder(
    column: $table.fax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subDistrict => $composableBuilder(
    column: $table.subDistrict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zipcode => $composableBuilder(
    column: $table.zipcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBlacklisted => $composableBuilder(
    column: $table.isBlacklisted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
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

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get taxId =>
      $composableBuilder(column: $table.taxId, builder: (column) => column);

  GeneratedColumn<String> get companyOfficeType => $composableBuilder(
    column: $table.companyOfficeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fax =>
      $composableBuilder(column: $table.fax, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get subDistrict => $composableBuilder(
    column: $table.subDistrict,
    builder: (column) => column,
  );

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get province =>
      $composableBuilder(column: $table.province, builder: (column) => column);

  GeneratedColumn<String> get zipcode =>
      $composableBuilder(column: $table.zipcode, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isBlacklisted => $composableBuilder(
    column: $table.isBlacklisted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> taxId = const Value.absent(),
                Value<String?> companyOfficeType = const Value.absent(),
                Value<String?> fax = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> subDistrict = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> province = const Value.absent(),
                Value<String?> zipcode = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> lineId = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isBlacklisted = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                nickname: nickname,
                phone: phone,
                taxId: taxId,
                companyOfficeType: companyOfficeType,
                fax: fax,
                address: address,
                subDistrict: subDistrict,
                district: district,
                province: province,
                zipcode: zipcode,
                email: email,
                lineId: lineId,
                remark: remark,
                type: type,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isBlacklisted: isBlacklisted,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> nickname = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> taxId = const Value.absent(),
                Value<String?> companyOfficeType = const Value.absent(),
                Value<String?> fax = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> subDistrict = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> province = const Value.absent(),
                Value<String?> zipcode = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> lineId = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isBlacklisted = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                nickname: nickname,
                phone: phone,
                taxId: taxId,
                companyOfficeType: companyOfficeType,
                fax: fax,
                address: address,
                subDistrict: subDistrict,
                district: district,
                province: province,
                zipcode: zipcode,
                email: email,
                lineId: lineId,
                remark: remark,
                type: type,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isBlacklisted: isBlacklisted,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String fullName,
      required String username,
      required String passwordHash,
      required String passwordSalt,
      Value<String?> phone,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String> username,
      Value<String> passwordHash,
      Value<String> passwordSalt,
      Value<String?> phone,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> passwordSalt = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                fullName: fullName,
                username: username,
                passwordHash: passwordHash,
                passwordSalt: passwordSalt,
                phone: phone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String username,
                required String passwordHash,
                required String passwordSalt,
                Value<String?> phone = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                fullName: fullName,
                username: username,
                passwordHash: passwordHash,
                passwordSalt: passwordSalt,
                phone: phone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String code,
      required String name,
      required double salePrice,
      Value<String?> remark,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<double> salePrice,
      Value<String?> remark,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                code: code,
                name: name,
                salePrice: salePrice,
                remark: remark,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required double salePrice,
                Value<String?> remark = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                code: code,
                name: name,
                salePrice: salePrice,
                remark: remark,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      required String saleNumber,
      required String customerId,
      required String customerName,
      required String vatOption,
      required double vatRate,
      required double subtotal,
      required double vatAmount,
      required double grandTotal,
      required double downPaymentPercent,
      required double downPaymentAmount,
      required double remainingAmount,
      Value<int> installmentCount,
      Value<double> installmentAmount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<String> saleNumber,
      Value<String> customerId,
      Value<String> customerName,
      Value<String> vatOption,
      Value<double> vatRate,
      Value<double> subtotal,
      Value<double> vatAmount,
      Value<double> grandTotal,
      Value<double> downPaymentPercent,
      Value<double> downPaymentAmount,
      Value<double> remainingAmount,
      Value<int> installmentCount,
      Value<double> installmentAmount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
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

  ColumnFilters<String> get saleNumber => $composableBuilder(
    column: $table.saleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vatOption => $composableBuilder(
    column: $table.vatOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vatRate => $composableBuilder(
    column: $table.vatRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vatAmount => $composableBuilder(
    column: $table.vatAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get downPaymentPercent => $composableBuilder(
    column: $table.downPaymentPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get downPaymentAmount => $composableBuilder(
    column: $table.downPaymentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get installmentAmount => $composableBuilder(
    column: $table.installmentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
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

  ColumnOrderings<String> get saleNumber => $composableBuilder(
    column: $table.saleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vatOption => $composableBuilder(
    column: $table.vatOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vatRate => $composableBuilder(
    column: $table.vatRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vatAmount => $composableBuilder(
    column: $table.vatAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get downPaymentPercent => $composableBuilder(
    column: $table.downPaymentPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get downPaymentAmount => $composableBuilder(
    column: $table.downPaymentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get installmentAmount => $composableBuilder(
    column: $table.installmentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleNumber => $composableBuilder(
    column: $table.saleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vatOption =>
      $composableBuilder(column: $table.vatOption, builder: (column) => column);

  GeneratedColumn<double> get vatRate =>
      $composableBuilder(column: $table.vatRate, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get vatAmount =>
      $composableBuilder(column: $table.vatAmount, builder: (column) => column);

  GeneratedColumn<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get downPaymentPercent => $composableBuilder(
    column: $table.downPaymentPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get downPaymentAmount => $composableBuilder(
    column: $table.downPaymentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get installmentAmount => $composableBuilder(
    column: $table.installmentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
          Sale,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleNumber = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String> vatOption = const Value.absent(),
                Value<double> vatRate = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> vatAmount = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<double> downPaymentPercent = const Value.absent(),
                Value<double> downPaymentAmount = const Value.absent(),
                Value<double> remainingAmount = const Value.absent(),
                Value<int> installmentCount = const Value.absent(),
                Value<double> installmentAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                saleNumber: saleNumber,
                customerId: customerId,
                customerName: customerName,
                vatOption: vatOption,
                vatRate: vatRate,
                subtotal: subtotal,
                vatAmount: vatAmount,
                grandTotal: grandTotal,
                downPaymentPercent: downPaymentPercent,
                downPaymentAmount: downPaymentAmount,
                remainingAmount: remainingAmount,
                installmentCount: installmentCount,
                installmentAmount: installmentAmount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleNumber,
                required String customerId,
                required String customerName,
                required String vatOption,
                required double vatRate,
                required double subtotal,
                required double vatAmount,
                required double grandTotal,
                required double downPaymentPercent,
                required double downPaymentAmount,
                required double remainingAmount,
                Value<int> installmentCount = const Value.absent(),
                Value<double> installmentAmount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                saleNumber: saleNumber,
                customerId: customerId,
                customerName: customerName,
                vatOption: vatOption,
                vatRate: vatRate,
                subtotal: subtotal,
                vatAmount: vatAmount,
                grandTotal: grandTotal,
                downPaymentPercent: downPaymentPercent,
                downPaymentAmount: downPaymentAmount,
                remainingAmount: remainingAmount,
                installmentCount: installmentCount,
                installmentAmount: installmentAmount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
      Sale,
      PrefetchHooks Function()
    >;
typedef $$SaleItemsTableCreateCompanionBuilder =
    SaleItemsCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required String productCode,
      required String productName,
      required double quantity,
      required double unitPrice,
      required double lineTotal,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SaleItemsTableUpdateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<String> productCode,
      Value<String> productName,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<double> lineTotal,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
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

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
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

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
          SaleItem,
          PrefetchHooks Function()
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> lineTotal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                productCode: productCode,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required String productCode,
                required String productName,
                required double quantity,
                required double unitPrice,
                required double lineTotal,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                productCode: productCode,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
      SaleItem,
      PrefetchHooks Function()
    >;
typedef $$SaleInstallmentsTableCreateCompanionBuilder =
    SaleInstallmentsCompanion Function({
      required String id,
      required String saleId,
      required int installmentNumber,
      required DateTime dueDate,
      required double dueAmount,
      Value<double> paidAmount,
      Value<DateTime?> paidAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SaleInstallmentsTableUpdateCompanionBuilder =
    SaleInstallmentsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<int> installmentNumber,
      Value<DateTime> dueDate,
      Value<double> dueAmount,
      Value<double> paidAmount,
      Value<DateTime?> paidAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SaleInstallmentsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleInstallmentsTable> {
  $$SaleInstallmentsTableFilterComposer({
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

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dueAmount => $composableBuilder(
    column: $table.dueAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleInstallmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleInstallmentsTable> {
  $$SaleInstallmentsTableOrderingComposer({
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

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dueAmount => $composableBuilder(
    column: $table.dueAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleInstallmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleInstallmentsTable> {
  $$SaleInstallmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get dueAmount =>
      $composableBuilder(column: $table.dueAmount, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SaleInstallmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleInstallmentsTable,
          SaleInstallment,
          $$SaleInstallmentsTableFilterComposer,
          $$SaleInstallmentsTableOrderingComposer,
          $$SaleInstallmentsTableAnnotationComposer,
          $$SaleInstallmentsTableCreateCompanionBuilder,
          $$SaleInstallmentsTableUpdateCompanionBuilder,
          (
            SaleInstallment,
            BaseReferences<
              _$AppDatabase,
              $SaleInstallmentsTable,
              SaleInstallment
            >,
          ),
          SaleInstallment,
          PrefetchHooks Function()
        > {
  $$SaleInstallmentsTableTableManager(
    _$AppDatabase db,
    $SaleInstallmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleInstallmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleInstallmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleInstallmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<int> installmentNumber = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<double> dueAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleInstallmentsCompanion(
                id: id,
                saleId: saleId,
                installmentNumber: installmentNumber,
                dueDate: dueDate,
                dueAmount: dueAmount,
                paidAmount: paidAmount,
                paidAt: paidAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required int installmentNumber,
                required DateTime dueDate,
                required double dueAmount,
                Value<double> paidAmount = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SaleInstallmentsCompanion.insert(
                id: id,
                saleId: saleId,
                installmentNumber: installmentNumber,
                dueDate: dueDate,
                dueAmount: dueAmount,
                paidAmount: paidAmount,
                paidAt: paidAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleInstallmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleInstallmentsTable,
      SaleInstallment,
      $$SaleInstallmentsTableFilterComposer,
      $$SaleInstallmentsTableOrderingComposer,
      $$SaleInstallmentsTableAnnotationComposer,
      $$SaleInstallmentsTableCreateCompanionBuilder,
      $$SaleInstallmentsTableUpdateCompanionBuilder,
      (
        SaleInstallment,
        BaseReferences<_$AppDatabase, $SaleInstallmentsTable, SaleInstallment>,
      ),
      SaleInstallment,
      PrefetchHooks Function()
    >;
typedef $$SalePaymentLogsTableCreateCompanionBuilder =
    SalePaymentLogsCompanion Function({
      required String id,
      required String saleId,
      required String installmentId,
      required int installmentNumber,
      required double paidAmount,
      Value<String> receiverName,
      required DateTime paidAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SalePaymentLogsTableUpdateCompanionBuilder =
    SalePaymentLogsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> installmentId,
      Value<int> installmentNumber,
      Value<double> paidAmount,
      Value<String> receiverName,
      Value<DateTime> paidAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SalePaymentLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SalePaymentLogsTable> {
  $$SalePaymentLogsTableFilterComposer({
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

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installmentId => $composableBuilder(
    column: $table.installmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiverName => $composableBuilder(
    column: $table.receiverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalePaymentLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SalePaymentLogsTable> {
  $$SalePaymentLogsTableOrderingComposer({
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

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installmentId => $composableBuilder(
    column: $table.installmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiverName => $composableBuilder(
    column: $table.receiverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalePaymentLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalePaymentLogsTable> {
  $$SalePaymentLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get installmentId => $composableBuilder(
    column: $table.installmentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentNumber => $composableBuilder(
    column: $table.installmentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiverName => $composableBuilder(
    column: $table.receiverName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SalePaymentLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalePaymentLogsTable,
          SalePaymentLog,
          $$SalePaymentLogsTableFilterComposer,
          $$SalePaymentLogsTableOrderingComposer,
          $$SalePaymentLogsTableAnnotationComposer,
          $$SalePaymentLogsTableCreateCompanionBuilder,
          $$SalePaymentLogsTableUpdateCompanionBuilder,
          (
            SalePaymentLog,
            BaseReferences<
              _$AppDatabase,
              $SalePaymentLogsTable,
              SalePaymentLog
            >,
          ),
          SalePaymentLog,
          PrefetchHooks Function()
        > {
  $$SalePaymentLogsTableTableManager(
    _$AppDatabase db,
    $SalePaymentLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalePaymentLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalePaymentLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalePaymentLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> installmentId = const Value.absent(),
                Value<int> installmentNumber = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<String> receiverName = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalePaymentLogsCompanion(
                id: id,
                saleId: saleId,
                installmentId: installmentId,
                installmentNumber: installmentNumber,
                paidAmount: paidAmount,
                receiverName: receiverName,
                paidAt: paidAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String installmentId,
                required int installmentNumber,
                required double paidAmount,
                Value<String> receiverName = const Value.absent(),
                required DateTime paidAt,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SalePaymentLogsCompanion.insert(
                id: id,
                saleId: saleId,
                installmentId: installmentId,
                installmentNumber: installmentNumber,
                paidAmount: paidAmount,
                receiverName: receiverName,
                paidAt: paidAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalePaymentLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalePaymentLogsTable,
      SalePaymentLog,
      $$SalePaymentLogsTableFilterComposer,
      $$SalePaymentLogsTableOrderingComposer,
      $$SalePaymentLogsTableAnnotationComposer,
      $$SalePaymentLogsTableCreateCompanionBuilder,
      $$SalePaymentLogsTableUpdateCompanionBuilder,
      (
        SalePaymentLog,
        BaseReferences<_$AppDatabase, $SalePaymentLogsTable, SalePaymentLog>,
      ),
      SalePaymentLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$SaleInstallmentsTableTableManager get saleInstallments =>
      $$SaleInstallmentsTableTableManager(_db, _db.saleInstallments);
  $$SalePaymentLogsTableTableManager get salePaymentLogs =>
      $$SalePaymentLogsTableTableManager(_db, _db.salePaymentLogs);
}
