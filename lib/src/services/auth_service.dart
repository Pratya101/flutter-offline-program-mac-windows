import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../database/app_database.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  const AuthService(this._database);

  static const defaultAdminFullName = 'ผู้ดูแลระบบ';
  static const defaultAdminUsername = 'admin';
  static const defaultAdminPassword = 'systemadministrator';

  final AppDatabase _database;

  Future<void> ensureDefaultAdminUser() async {
    if (await _database.hasActiveUsers()) {
      return;
    }

    await _database.transaction(() async {
      if (await _database.hasActiveUsers()) {
        return;
      }

      final salt = _createSalt();
      await _database.upsertBootstrapUser(
        fullName: defaultAdminFullName,
        username: defaultAdminUsername,
        passwordHash: _hashPassword(defaultAdminPassword, salt),
        passwordSalt: salt,
      );
      await _database.getOrCreatePrimaryShop();
    });
  }

  Future<User> register({
    required String fullName,
    required String username,
    required String password,
    String? phone,
    String? shopName,
    String? shopDescription,
    String? shopPhone,
    String? shopTaxId,
    String? shopAddress,
  }) async {
    _validateRequired(fullName, 'ชื่อ-นามสกุล');
    _validateRequired(username, 'ชื่อผู้ใช้');
    _validateRequired(password, 'รหัสผ่าน');
    await _assertUsernameAvailable(username);

    final salt = _createSalt();
    return _database.transaction(() async {
      final user = await _database.createUser(
        fullName: fullName,
        username: username,
        passwordHash: _hashPassword(password, salt),
        passwordSalt: salt,
        phone: phone,
      );

      final hasShopInput = [
        shopName,
        shopDescription,
        shopPhone,
        shopTaxId,
        shopAddress,
      ].any((value) => (value ?? '').trim().isNotEmpty);
      if (hasShopInput) {
        await _database.upsertPrimaryShop(
          name: _fallbackShopName(shopName),
          description: shopDescription,
          phone: shopPhone,
          taxId: shopTaxId,
          address: shopAddress,
        );
      } else {
        await _database.getOrCreatePrimaryShop();
      }

      return user;
    });
  }

  Future<User> login({
    required String username,
    required String password,
  }) async {
    _validateRequired(username, 'ชื่อผู้ใช้');
    _validateRequired(password, 'รหัสผ่าน');
    await ensureDefaultAdminUser();

    final user = await _database.findActiveUserByUsername(username);
    if (user == null) {
      throw const AuthException('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    }

    final hash = _hashPassword(password, user.passwordSalt);
    if (hash != user.passwordHash) {
      throw const AuthException('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    }

    return user;
  }

  Future<User> getProfile(String userId) async {
    final user = await _database.findActiveUserById(userId);
    if (user == null) {
      throw const AuthException('ไม่พบโปรไฟล์ผู้ใช้');
    }

    return user;
  }

  Future<Shop> getPrimaryShop() {
    return _database.getOrCreatePrimaryShop();
  }

  Future<Shop> updatePrimaryShop({
    required String name,
    String? description,
    String? phone,
    String? taxId,
    String? address,
  }) {
    _validateRequired(name, 'ชื่อร้าน');
    return _database.upsertPrimaryShop(
      name: name,
      description: description,
      phone: phone,
      taxId: taxId,
      address: address,
    );
  }

  Future<void> updateUser({
    required String id,
    required String fullName,
    required String username,
    String? password,
    String? phone,
  }) async {
    _validateRequired(fullName, 'ชื่อ-นามสกุล');
    _validateRequired(username, 'ชื่อผู้ใช้');

    final existing = await _database.findActiveUserByUsername(username);
    if (existing != null && existing.id != id) {
      throw const AuthException('ชื่อผู้ใช้นี้ถูกใช้แล้ว');
    }

    String? passwordHash;
    String? passwordSalt;
    if (password != null && password.trim().isNotEmpty) {
      passwordSalt = _createSalt();
      passwordHash = _hashPassword(password, passwordSalt);
    }

    await _database.updateUser(
      id: id,
      fullName: fullName,
      username: username,
      phone: phone,
      passwordHash: passwordHash,
      passwordSalt: passwordSalt,
    );
  }

  Future<void> deleteUser(String id) {
    return _database.softDeleteUser(id);
  }

  Future<void> _assertUsernameAvailable(String username) async {
    final existing = await _database.findActiveUserByUsername(username);
    if (existing != null) {
      throw const AuthException('ชื่อผู้ใช้นี้ถูกใช้แล้ว');
    }
  }

  void _validateRequired(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw AuthException('กรุณากรอก$fieldName');
    }
  }
}

String _fallbackShopName(String? value) {
  final name = value?.trim();
  if (name == null || name.isEmpty) {
    return 'ร้านของฉัน';
  }
  return name;
}

String _createSalt() {
  final random = Random.secure();
  final bytes = List<int>.generate(24, (_) => random.nextInt(256));
  return base64UrlEncode(bytes);
}

String _hashPassword(String password, String salt) {
  final key = utf8.encode(salt);
  final bytes = utf8.encode(password);
  return Hmac(sha256, key).convert(bytes).toString();
}
