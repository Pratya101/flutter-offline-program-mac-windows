import '../database/app_database.dart';

class CustomerException implements Exception {
  const CustomerException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CustomerPayload {
  const CustomerPayload({
    required this.name,
    this.nickname,
    this.phone,
    this.citizenId,
    this.birthDate,
    this.fax,
    this.address,
    this.subDistrict,
    this.district,
    this.province,
    this.zipcode,
    this.email,
    this.lineId,
    this.remark,
    this.isBlacklisted = false,
  });

  final String name;
  final String? nickname;
  final String? phone;
  final String? citizenId;
  final DateTime? birthDate;
  final String? fax;
  final String? address;
  final String? subDistrict;
  final String? district;
  final String? province;
  final String? zipcode;
  final String? email;
  final String? lineId;
  final String? remark;
  final bool isBlacklisted;
}

class CustomerService {
  const CustomerService(this._database);

  final AppDatabase _database;

  Future<Customer> createCustomer(CustomerPayload payload) async {
    _validate(payload);
    return _database.createCustomer(
      name: payload.name,
      nickname: payload.nickname,
      phone: payload.phone,
      taxId: _normalizeCitizenId(payload.citizenId),
      birthDate: _normalizeBirthDate(payload.birthDate),
      fax: payload.fax,
      address: payload.address,
      subDistrict: payload.subDistrict,
      district: payload.district,
      province: payload.province,
      zipcode: payload.zipcode,
      email: payload.email,
      lineId: payload.lineId,
      remark: payload.remark,
      type: 'PERSONAL',
      isBlacklisted: payload.isBlacklisted,
    );
  }

  Future<Customer> updateCustomer({
    required String id,
    required CustomerPayload payload,
  }) async {
    _validate(payload);
    return _database.updateCustomer(
      id: id,
      name: payload.name,
      nickname: payload.nickname,
      phone: payload.phone,
      taxId: _normalizeCitizenId(payload.citizenId),
      birthDate: _normalizeBirthDate(payload.birthDate),
      fax: payload.fax,
      address: payload.address,
      subDistrict: payload.subDistrict,
      district: payload.district,
      province: payload.province,
      zipcode: payload.zipcode,
      email: payload.email,
      lineId: payload.lineId,
      remark: payload.remark,
      type: 'PERSONAL',
      isBlacklisted: payload.isBlacklisted,
    );
  }

  Future<void> deleteCustomer(String id) {
    return _database.softDeleteCustomer(id);
  }

  void _validate(CustomerPayload payload) {
    if (payload.name.trim().isEmpty) {
      throw const CustomerException('กรุณากรอกชื่อ-นามสกุล');
    }

    final email = payload.email?.trim();
    if (email != null &&
        email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      throw const CustomerException('อีเมลไม่ถูกต้อง');
    }

    final citizenId = _normalizeCitizenId(payload.citizenId);
    if (citizenId.isNotEmpty && !RegExp(r'^\d{13}$').hasMatch(citizenId)) {
      throw const CustomerException('เลขบัตรประชาชนต้องเป็นตัวเลข 13 หลัก');
    }
  }
}

String _normalizeCitizenId(String? value) {
  return (value ?? '').replaceAll(RegExp(r'\D'), '');
}

DateTime? _normalizeBirthDate(DateTime? value) {
  if (value == null) {
    return null;
  }
  return DateTime(value.year, value.month, value.day);
}
