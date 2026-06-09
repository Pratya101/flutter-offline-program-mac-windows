import '../database/app_database.dart';

class LicenseException implements Exception {
  const LicenseException(this.message);

  final String message;

  @override
  String toString() => message;
}

enum LicenseMode { demo, full }

class LicenseSnapshot {
  const LicenseSnapshot({
    required this.mode,
    required this.customerName,
    this.expiresAt,
    this.maxCustomers,
    this.maxProducts,
    this.maxSales,
  });

  factory LicenseSnapshot.fromEnvironment() {
    const modeText = String.fromEnvironment(
      'APP_LICENSE_MODE',
      defaultValue: 'demo',
    );
    const customerName = String.fromEnvironment(
      'APP_LICENSE_CUSTOMER',
      defaultValue: 'Demo Customer',
    );
    const expiresAtText = String.fromEnvironment(
      'APP_LICENSE_EXPIRES_AT',
      defaultValue: '',
    );
    const maxCustomers = int.fromEnvironment(
      'APP_DEMO_MAX_CUSTOMERS',
      defaultValue: 30,
    );
    const maxProducts = int.fromEnvironment(
      'APP_DEMO_MAX_PRODUCTS',
      defaultValue: 30,
    );
    const maxSales = int.fromEnvironment(
      'APP_DEMO_MAX_SALES',
      defaultValue: 20,
    );

    final mode = modeText.trim().toLowerCase() == 'full'
        ? LicenseMode.full
        : LicenseMode.demo;
    if (mode == LicenseMode.full) {
      return const LicenseSnapshot(
        mode: LicenseMode.full,
        customerName: customerName,
      );
    }

    return LicenseSnapshot(
      mode: LicenseMode.demo,
      customerName: customerName,
      expiresAt: _parseIsoDate(expiresAtText),
      maxCustomers: maxCustomers,
      maxProducts: maxProducts,
      maxSales: maxSales,
    );
  }

  final LicenseMode mode;
  final String customerName;
  final DateTime? expiresAt;
  final int? maxCustomers;
  final int? maxProducts;
  final int? maxSales;

  bool get isDemo => mode == LicenseMode.demo;

  bool get isFull => mode == LicenseMode.full;

  bool isExpired(DateTime now) {
    final expiry = expiresAt;
    if (expiry == null) {
      return false;
    }
    return _dateOnly(now).isAfter(_dateOnly(expiry));
  }
}

class LicenseService {
  LicenseService({
    required this.snapshot,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  factory LicenseService.fromEnvironment({DateTime Function()? now}) {
    return LicenseService(
      snapshot: LicenseSnapshot.fromEnvironment(),
      now: now,
    );
  }

  factory LicenseService.demo({
    required String customerName,
    DateTime? expiresAt,
    int maxCustomers = 30,
    int maxProducts = 30,
    int maxSales = 20,
    DateTime Function()? now,
  }) {
    return LicenseService(
      snapshot: LicenseSnapshot(
        mode: LicenseMode.demo,
        customerName: customerName,
        expiresAt: expiresAt,
        maxCustomers: maxCustomers,
        maxProducts: maxProducts,
        maxSales: maxSales,
      ),
      now: now,
    );
  }

  factory LicenseService.full({
    String customerName = 'Full License',
    DateTime Function()? now,
  }) {
    return LicenseService(
      snapshot: LicenseSnapshot(
        mode: LicenseMode.full,
        customerName: customerName,
      ),
      now: now,
    );
  }

  final LicenseSnapshot snapshot;
  final DateTime Function() _now;

  int? get remainingDays {
    final expiry = snapshot.expiresAt;
    if (expiry == null) {
      return null;
    }
    return _dateOnly(expiry).difference(_dateOnly(_now())).inDays;
  }

  String get statusLabel {
    if (snapshot.isFull) {
      return 'Full License';
    }
    final days = remainingDays;
    if (days == null) {
      return 'Demo';
    }
    if (days < 0) {
      return 'Demo หมดอายุ';
    }
    return 'Demo เหลือ $days วัน';
  }

  String? get documentWatermarkText {
    if (!snapshot.isDemo) {
      return null;
    }
    return 'DEMO - ใช้ทดสอบเท่านั้น';
  }

  bool get canExportBackup => snapshot.isFull;

  void assertCanUseApp() {
    if (snapshot.isExpired(_now())) {
      throw const LicenseException(
        'Demo หมดอายุแล้ว กรุณาชำระเงินส่วนที่เหลือเพื่อรับสิทธิ์ใช้งานตัวเต็ม',
      );
    }
  }

  Future<void> assertCanCreateCustomer(AppDatabase database) async {
    await _assertWithinDemoLimit(
      entityName: 'ลูกค้า',
      currentCount: await database.countActiveCustomers(),
      limit: snapshot.maxCustomers,
    );
  }

  Future<void> assertCanCreateProduct(AppDatabase database) async {
    await _assertWithinDemoLimit(
      entityName: 'สินค้า',
      currentCount: await database.countActiveProducts(),
      limit: snapshot.maxProducts,
    );
  }

  Future<void> assertCanCreateSale(AppDatabase database) async {
    await _assertWithinDemoLimit(
      entityName: 'รายการขาย',
      currentCount: await database.countActiveSales(),
      limit: snapshot.maxSales,
    );
  }

  void assertCanExportBackup() {
    assertCanUseApp();
    if (!canExportBackup) {
      throw const LicenseException(
        'Demo ไม่อนุญาตให้สำรองข้อมูล กรุณาใช้ตัวเต็มหลังชำระเงินครบ',
      );
    }
  }

  Future<void> _assertWithinDemoLimit({
    required String entityName,
    required int currentCount,
    required int? limit,
  }) async {
    assertCanUseApp();
    if (snapshot.isFull || limit == null || currentCount < limit) {
      return;
    }
    throw LicenseException(
      'Demo จำกัด$entityNameไม่เกิน $limit รายการ กรุณาใช้ตัวเต็มหลังชำระเงินครบ',
    );
  }
}

DateTime? _parseIsoDate(String value) {
  final text = value.trim();
  if (text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}

DateTime _dateOnly(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}
