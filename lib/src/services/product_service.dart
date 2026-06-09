import '../database/app_database.dart';
import 'license_service.dart';

class ProductException implements Exception {
  const ProductException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProductPayload {
  const ProductPayload({
    this.code,
    required this.name,
    required this.salePrice,
    this.remark,
  });

  final String? code;
  final String name;
  final double salePrice;
  final String? remark;
}

class ProductService {
  ProductService(this._database, {LicenseService? licenseService})
    : _licenseService = licenseService ?? LicenseService.fromEnvironment();

  final AppDatabase _database;
  final LicenseService _licenseService;

  Future<Product> createProduct(ProductPayload payload) async {
    _validate(payload);
    final code = await _resolveCode(payload.code);
    try {
      await _licenseService.assertCanCreateProduct(_database);
    } on LicenseException catch (error) {
      throw ProductException(error.message);
    }
    return _database.createProduct(
      code: code,
      name: payload.name,
      salePrice: payload.salePrice,
      remark: payload.remark,
    );
  }

  Future<Product> updateProduct({
    required String id,
    required ProductPayload payload,
  }) async {
    _validate(payload);
    final code = await _resolveCode(payload.code, editingProductId: id);
    return _database.updateProduct(
      id: id,
      code: code,
      name: payload.name,
      salePrice: payload.salePrice,
      remark: payload.remark,
    );
  }

  Future<void> deleteProduct(String id) {
    return _database.softDeleteProduct(id);
  }

  void _validate(ProductPayload payload) {
    if (payload.name.trim().isEmpty) {
      throw const ProductException('กรุณากรอกชื่อสินค้า');
    }
    if (payload.salePrice.isNaN ||
        payload.salePrice.isInfinite ||
        payload.salePrice < 0) {
      throw const ProductException('ราคาขายต้องเป็นตัวเลขตั้งแต่ 0 ขึ้นไป');
    }
  }

  Future<String> _resolveCode(String? code, {String? editingProductId}) async {
    final normalized = _normalizeCode(code);
    if (normalized != null) {
      await _assertCodeAvailable(
        normalized,
        editingProductId: editingProductId,
      );
      return normalized;
    }

    for (var attempt = 0; attempt < 10; attempt += 1) {
      final generated = _generateProductCode(attempt);
      final existing = await _findActiveProductByCode(generated);
      if (existing == null ||
          (editingProductId != null && existing.id == editingProductId)) {
        return generated;
      }
    }

    throw const ProductException('ไม่สามารถสร้างรหัสสินค้าอัตโนมัติได้');
  }

  Future<void> _assertCodeAvailable(
    String code, {
    String? editingProductId,
  }) async {
    final existing = await _findActiveProductByCode(code);
    if (existing != null && existing.id != editingProductId) {
      throw const ProductException('รหัสสินค้านี้ถูกใช้แล้ว');
    }
  }

  Future<Product?> _findActiveProductByCode(String code) async {
    final normalized = _normalizeCode(code);
    if (normalized == null) {
      return null;
    }
    final activeProducts = await _database.getActiveProducts();
    for (final product in activeProducts) {
      if (_normalizeCode(product.code) == normalized) {
        return product;
      }
    }
    return null;
  }
}

String? _normalizeCode(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text.toUpperCase();
}

String _generateProductCode(int attempt) {
  final now = DateTime.now();
  final date =
      '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';
  final suffix = ((now.microsecond + attempt) % 10000).toString().padLeft(
    4,
    '0',
  );
  return 'PRD-$date-$suffix';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
