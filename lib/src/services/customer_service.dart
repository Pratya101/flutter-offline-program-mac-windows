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
    required this.type,
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
    this.isBlacklisted = false,
  });

  final String name;
  final String type;
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
  final bool isBlacklisted;
}

class CustomerService {
  const CustomerService(this._database);

  final AppDatabase _database;

  Future<void> createCustomer(CustomerPayload payload) async {
    _validate(payload);
    await _database.createCustomer(
      name: payload.name,
      nickname: payload.nickname,
      phone: payload.phone,
      taxId: _normalizeTaxId(payload.taxId),
      companyOfficeType: payload.companyOfficeType,
      fax: payload.fax,
      address: payload.address,
      subDistrict: payload.subDistrict,
      district: payload.district,
      province: payload.province,
      zipcode: payload.zipcode,
      email: payload.email,
      lineId: payload.lineId,
      remark: payload.remark,
      type: _normalizeType(payload.type),
      isBlacklisted: payload.isBlacklisted,
    );
  }

  Future<void> updateCustomer({
    required String id,
    required CustomerPayload payload,
  }) async {
    _validate(payload);
    await _database.updateCustomer(
      id: id,
      name: payload.name,
      nickname: payload.nickname,
      phone: payload.phone,
      taxId: _normalizeTaxId(payload.taxId),
      companyOfficeType: payload.companyOfficeType,
      fax: payload.fax,
      address: payload.address,
      subDistrict: payload.subDistrict,
      district: payload.district,
      province: payload.province,
      zipcode: payload.zipcode,
      email: payload.email,
      lineId: payload.lineId,
      remark: payload.remark,
      type: _normalizeType(payload.type),
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

    final type = _normalizeType(payload.type);
    final taxId = _normalizeTaxId(payload.taxId);
    if (type == 'COMPANY' && taxId.isEmpty) {
      throw const CustomerException('นิติบุคคลต้องกรอกเลขประจำตัวผู้เสียภาษี');
    }
    if (taxId.isNotEmpty && !RegExp(r'^\d{13}$').hasMatch(taxId)) {
      throw const CustomerException(
        'เลขประจำตัวผู้เสียภาษีต้องเป็นตัวเลข 13 หลัก',
      );
    }
  }
}

String _normalizeType(String value) {
  return value.trim().toUpperCase() == 'COMPANY' ? 'COMPANY' : 'PERSONAL';
}

String _normalizeTaxId(String? value) {
  return (value ?? '').replaceAll(RegExp(r'\D'), '');
}
