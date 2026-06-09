import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'database_connection.dart';

part 'app_database.g.dart';

class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nickname => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get taxId => text().named('tax_id').nullable()();
  DateTimeColumn get birthDate => dateTime().named('birth_date').nullable()();
  TextColumn get companyOfficeType =>
      text().named('company_office_type').nullable()();
  TextColumn get fax => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get subDistrict => text().named('sub_district').nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get province => text().nullable()();
  TextColumn get zipcode => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get lineId => text().named('line_id').nullable()();
  TextColumn get remark => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('PERSONAL'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isBlacklisted =>
      boolean().named('is_blacklisted').withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().named('full_name')();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text().named('password_hash')();
  TextColumn get passwordSalt => text().named('password_salt')();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Shops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get taxId => text().named('tax_id').nullable()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  RealColumn get salePrice => real().named('sale_price')();
  TextColumn get remark => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get saleNumber => text().named('sale_number')();
  TextColumn get customerId => text().named('customer_id')();
  TextColumn get customerName => text().named('customer_name')();
  TextColumn get vatOption => text().named('vat_option')();
  RealColumn get vatRate => real().named('vat_rate')();
  RealColumn get subtotal => real()();
  RealColumn get vatAmount => real().named('vat_amount')();
  RealColumn get grandTotal => real().named('grand_total')();
  RealColumn get downPaymentPercent => real().named('down_payment_percent')();
  RealColumn get downPaymentAmount => real().named('down_payment_amount')();
  RealColumn get remainingAmount => real().named('remaining_amount')();
  TextColumn get receiverName =>
      text().named('receiver_name').withDefault(const Constant('ระบบ'))();
  IntColumn get installmentCount =>
      integer().named('installment_count').withDefault(const Constant(1))();
  RealColumn get installmentAmount =>
      real().named('installment_amount').withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class SaleItems extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().named('sale_id')();
  TextColumn get productId => text().named('product_id')();
  TextColumn get productCode => text().named('product_code')();
  TextColumn get productName => text().named('product_name')();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real().named('unit_price')();
  RealColumn get lineTotal => real().named('line_total')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class SaleInstallments extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().named('sale_id')();
  IntColumn get installmentNumber => integer().named('installment_number')();
  DateTimeColumn get dueDate => dateTime().named('due_date')();
  RealColumn get dueAmount => real().named('due_amount')();
  RealColumn get paidAmount =>
      real().named('paid_amount').withDefault(const Constant(0))();
  DateTimeColumn get paidAt => dateTime().named('paid_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class SalePaymentLogs extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().named('sale_id')();
  TextColumn get installmentId => text().named('installment_id')();
  IntColumn get installmentNumber => integer().named('installment_number')();
  RealColumn get paidAmount => real().named('paid_amount')();
  TextColumn get receiverName =>
      text().named('receiver_name').withDefault(const Constant('ระบบ'))();
  DateTimeColumn get paidAt => dateTime().named('paid_at')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Customers,
    Users,
    Shops,
    Products,
    Sales,
    SaleItems,
    SaleInstallments,
    SalePaymentLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  static const _uuid = Uuid();

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(users);
      }
      if (from < 3) {
        await m.addColumn(customers, customers.nickname);
        await m.addColumn(customers, customers.taxId);
        await m.addColumn(customers, customers.companyOfficeType);
        await m.addColumn(customers, customers.fax);
        await m.addColumn(customers, customers.address);
        await m.addColumn(customers, customers.subDistrict);
        await m.addColumn(customers, customers.district);
        await m.addColumn(customers, customers.province);
        await m.addColumn(customers, customers.zipcode);
        await m.addColumn(customers, customers.email);
        await m.addColumn(customers, customers.lineId);
        await m.addColumn(customers, customers.remark);
        await m.addColumn(customers, customers.type);
        await customStatement(
          'UPDATE customers SET remark = note WHERE remark IS NULL AND note IS NOT NULL;',
        );
      }
      if (from < 5) {
        await m.addColumn(customers, customers.isBlacklisted);
      }
      if (from < 6) {
        await m.createTable(products);
      }
      if (from < 7) {
        await m.createTable(sales);
        await m.createTable(saleItems);
      }
      if (from < 8) {
        await m.addColumn(sales, sales.installmentCount);
        await m.addColumn(sales, sales.installmentAmount);
      }
      if (from < 9) {
        await _createSaleInstallmentsTableIfNeeded();
        await _backfillSaleInstallments();
      }
      if (from < 10) {
        await _ensureSaleInstallmentsSchema();
      }
      if (from < 11) {
        await _createSalePaymentLogsTableIfNeeded();
      }
      if (from < 12) {
        await m.createTable(shops);
      }
      if (from < 13) {
        await m.addColumn(customers, customers.birthDate);
      }
      if (from >= 12 && from < 14) {
        await m.addColumn(shops, shops.description);
      }
      if (from >= 7 && from < 15) {
        await m.addColumn(sales, sales.receiverName);
      }
    },
  );

  Stream<List<Customer>> watchActiveCustomers() {
    final query = select(customers)
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.watch();
  }

  Future<int> countActiveCustomers() {
    final countExpression = customers.id.count();
    final query = selectOnly(customers)
      ..addColumns([countExpression])
      ..where(customers.isDeleted.equals(false));

    return query
        .map((row) => row.read(countExpression) ?? 0)
        .getSingle();
  }

  Future<Customer> createCustomer({
    required String name,
    String? nickname,
    String? phone,
    String? taxId,
    DateTime? birthDate,
    String? companyOfficeType,
    String? fax,
    String? address,
    String? subDistrict,
    String? district,
    String? province,
    String? zipcode,
    String? email,
    String? lineId,
    String? remark,
    String type = 'PERSONAL',
    String? note,
    bool isBlacklisted = false,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await into(customers).insert(
      CustomersCompanion.insert(
        id: id,
        name: name.trim(),
        nickname: Value(_blankToNull(nickname)),
        phone: Value(_blankToNull(phone)),
        taxId: Value(_blankToNull(taxId)),
        birthDate: Value(_dateOnlyOrNull(birthDate)),
        companyOfficeType: Value(_blankToNull(companyOfficeType)),
        fax: Value(_blankToNull(fax)),
        address: Value(_blankToNull(address)),
        subDistrict: Value(_blankToNull(subDistrict)),
        district: Value(_blankToNull(district)),
        province: Value(_blankToNull(province)),
        zipcode: Value(_blankToNull(zipcode)),
        email: Value(_blankToNull(email)),
        lineId: Value(_blankToNull(lineId)),
        remark: Value(_blankToNull(remark ?? note)),
        type: Value(type.trim().isEmpty ? 'PERSONAL' : type.trim()),
        note: Value(_blankToNull(note)),
        createdAt: now,
        updatedAt: now,
        isBlacklisted: Value(isBlacklisted),
      ),
    );

    return (select(
      customers,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<Customer> updateCustomer({
    required String id,
    required String name,
    String? nickname,
    String? phone,
    String? taxId,
    DateTime? birthDate,
    String? companyOfficeType,
    String? fax,
    String? address,
    String? subDistrict,
    String? district,
    String? province,
    String? zipcode,
    String? email,
    String? lineId,
    String? remark,
    String type = 'PERSONAL',
    bool isBlacklisted = false,
  }) async {
    await (update(customers)..where((table) => table.id.equals(id))).write(
      CustomersCompanion(
        name: Value(name.trim()),
        nickname: Value(_blankToNull(nickname)),
        phone: Value(_blankToNull(phone)),
        taxId: Value(_blankToNull(taxId)),
        birthDate: Value(_dateOnlyOrNull(birthDate)),
        companyOfficeType: Value(_blankToNull(companyOfficeType)),
        fax: Value(_blankToNull(fax)),
        address: Value(_blankToNull(address)),
        subDistrict: Value(_blankToNull(subDistrict)),
        district: Value(_blankToNull(district)),
        province: Value(_blankToNull(province)),
        zipcode: Value(_blankToNull(zipcode)),
        email: Value(_blankToNull(email)),
        lineId: Value(_blankToNull(lineId)),
        remark: Value(_blankToNull(remark)),
        type: Value(type.trim().isEmpty ? 'PERSONAL' : type.trim()),
        updatedAt: Value(DateTime.now()),
        isBlacklisted: Value(isBlacklisted),
      ),
    );

    return (select(
      customers,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<void> softDeleteCustomer(String id) async {
    await (update(customers)..where((table) => table.id.equals(id))).write(
      CustomersCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<Product>> watchActiveProducts() {
    final query = select(products)
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.watch();
  }

  Future<List<Product>> getActiveProducts() {
    final query = select(products)
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.get();
  }

  Future<int> countActiveProducts() {
    final countExpression = products.id.count();
    final query = selectOnly(products)
      ..addColumns([countExpression])
      ..where(products.isDeleted.equals(false));

    return query
        .map((row) => row.read(countExpression) ?? 0)
        .getSingle();
  }

  Future<Product?> findActiveProductByCode(String code) {
    final query = select(products)
      ..where(
        (table) =>
            table.code.equals(_normalizeProductCode(code)) &
            table.isDeleted.equals(false),
      )
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<Product> createProduct({
    required String code,
    required String name,
    required double salePrice,
    String? remark,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await into(products).insert(
      ProductsCompanion.insert(
        id: id,
        code: _normalizeProductCode(code),
        name: name.trim(),
        salePrice: salePrice,
        remark: Value(_blankToNull(remark)),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return (select(
      products,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<Product> updateProduct({
    required String id,
    required String code,
    required String name,
    required double salePrice,
    String? remark,
  }) async {
    await (update(products)..where((table) => table.id.equals(id))).write(
      ProductsCompanion(
        code: Value(_normalizeProductCode(code)),
        name: Value(name.trim()),
        salePrice: Value(salePrice),
        remark: Value(_blankToNull(remark)),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return (select(
      products,
    )..where((table) => table.id.equals(id))).getSingle();
  }

  Future<void> softDeleteProduct(String id) async {
    await (update(products)..where((table) => table.id.equals(id))).write(
      ProductsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<Sale>> watchActiveSales() {
    final query = select(sales)
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.watch();
  }

  Future<int> countActiveSales() {
    final countExpression = sales.id.count();
    final query = selectOnly(sales)
      ..addColumns([countExpression])
      ..where(sales.isDeleted.equals(false));

    return query
        .map((row) => row.read(countExpression) ?? 0)
        .getSingle();
  }

  Stream<List<SaleListItem>> watchActiveSaleListItems() {
    final query =
        select(sales).join([
            leftOuterJoin(customers, customers.id.equalsExp(sales.customerId)),
          ])
          ..where(sales.isDeleted.equals(false))
          ..orderBy([
            OrderingTerm(expression: sales.updatedAt, mode: OrderingMode.desc),
          ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return SaleListItem(
          sale: row.readTable(sales),
          customer: row.readTableOrNull(customers),
        );
      }).toList();
    });
  }

  Future<Sale?> findActiveSaleById(String id) {
    final query = select(sales)
      ..where((table) => table.id.equals(id))
      ..where((table) => table.isDeleted.equals(false))
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<Customer?> findCustomerById(String id) {
    final query = select(customers)
      ..where((table) => table.id.equals(id))
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<Sale> createSale({
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
    String receiverName = 'ระบบ',
    required int installmentCount,
    required double installmentAmount,
    required DateTime firstDueDate,
    required List<SaleItemDraft> items,
  }) async {
    await _ensureSaleInstallmentsSchema();

    final now = DateTime.now();
    final saleId = _uuid.v4();
    final firstInstallmentDueDate = _dateOnly(firstDueDate);
    final installmentDueAmounts = _buildInstallmentDueAmounts(
      remainingAmount: remainingAmount,
      installmentCount: installmentCount,
      installmentAmount: installmentAmount,
    );

    await transaction(() async {
      await into(sales).insert(
        SalesCompanion.insert(
          id: saleId,
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
          receiverName: Value(
            receiverName.trim().isEmpty ? 'ระบบ' : receiverName.trim(),
          ),
          installmentCount: Value(installmentCount),
          installmentAmount: Value(installmentAmount),
          createdAt: now,
          updatedAt: now,
        ),
      );

      for (final item in items) {
        await into(saleItems).insert(
          SaleItemsCompanion.insert(
            id: _uuid.v4(),
            saleId: saleId,
            productId: item.productId,
            productCode: item.productCode,
            productName: item.productName,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            lineTotal: item.lineTotal,
            createdAt: now,
          ),
        );
      }

      for (var index = 0; index < installmentDueAmounts.length; index++) {
        await into(saleInstallments).insert(
          SaleInstallmentsCompanion.insert(
            id: _uuid.v4(),
            saleId: saleId,
            installmentNumber: index + 1,
            dueDate: _addMonthsClamped(firstInstallmentDueDate, index),
            dueAmount: installmentDueAmounts[index],
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    });

    return (select(
      sales,
    )..where((table) => table.id.equals(saleId))).getSingle();
  }

  Future<List<SaleItem>> getSaleItems(String saleId) {
    final query = select(saleItems)
      ..where((table) => table.saleId.equals(saleId));

    return query.get();
  }

  Future<List<SaleInstallment>> getSaleInstallments(String saleId) {
    final query = select(saleInstallments)
      ..where((table) => table.saleId.equals(saleId))
      ..orderBy([(table) => OrderingTerm(expression: table.installmentNumber)]);

    return query.get();
  }

  Future<List<SalePaymentLog>> getSalePaymentLogs(String saleId) async {
    await _ensureSalePaymentLogsSchema();
    final query = select(salePaymentLogs)
      ..where((table) => table.saleId.equals(saleId))
      ..orderBy([
        (table) => OrderingTerm(expression: table.paidAt),
        (table) => OrderingTerm(expression: table.createdAt),
      ]);

    return query.get();
  }

  Future<SaleInstallment?> findSaleInstallment({
    required String saleId,
    required String installmentId,
  }) {
    final query = select(saleInstallments)
      ..where((table) => table.saleId.equals(saleId))
      ..where((table) => table.id.equals(installmentId))
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<void> updateSaleInstallmentPayment({
    required String saleId,
    required String installmentId,
    required int installmentNumber,
    required double paidAmount,
    required double paymentAmount,
    String receiverName = 'ระบบ',
    required DateTime? paidAt,
  }) async {
    await _ensureSalePaymentLogsSchema();
    final now = DateTime.now();
    await transaction(() async {
      await (update(saleInstallments)..where(
            (table) =>
                table.saleId.equals(saleId) & table.id.equals(installmentId),
          ))
          .write(
            SaleInstallmentsCompanion(
              paidAmount: Value(paidAmount),
              paidAt: Value(paidAt),
              updatedAt: Value(now),
            ),
          );

      await into(salePaymentLogs).insert(
        SalePaymentLogsCompanion.insert(
          id: _uuid.v4(),
          saleId: saleId,
          installmentId: installmentId,
          installmentNumber: installmentNumber,
          paidAmount: paymentAmount,
          receiverName: Value(
            receiverName.trim().isEmpty ? 'ระบบ' : receiverName.trim(),
          ),
          paidAt: now,
          createdAt: now,
        ),
      );

      await (update(sales)..where((table) => table.id.equals(saleId))).write(
        SalesCompanion(updatedAt: Value(now)),
      );
    });
  }

  Future<void> softDeleteSale(String id) async {
    await (update(sales)..where((table) => table.id.equals(id))).write(
      SalesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<User>> watchActiveUsers() {
    final query = select(users)
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.watch();
  }

  Future<User?> findActiveUserByUsername(String username) {
    final query = select(users)
      ..where((table) => table.username.equals(_normalizeUsername(username)))
      ..where((table) => table.isDeleted.equals(false))
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<User?> findActiveUserById(String id) {
    final query = select(users)
      ..where((table) => table.id.equals(id))
      ..where((table) => table.isDeleted.equals(false))
      ..limit(1);

    return query.getSingleOrNull();
  }

  Future<User> createUser({
    required String fullName,
    required String username,
    required String passwordHash,
    required String passwordSalt,
    String? phone,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await into(users).insert(
      UsersCompanion.insert(
        id: id,
        fullName: fullName.trim(),
        username: _normalizeUsername(username),
        passwordHash: passwordHash,
        passwordSalt: passwordSalt,
        phone: Value(_blankToNull(phone)),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return (select(users)..where((table) => table.id.equals(id))).getSingle();
  }

  Future<Shop?> findPrimaryShop() {
    final query = select(shops)
      ..orderBy([(table) => OrderingTerm(expression: table.createdAt)])
      ..limit(1);

    return query.getSingleOrNull();
  }

  Stream<Shop?> watchPrimaryShop() {
    final query = select(shops)
      ..orderBy([(table) => OrderingTerm(expression: table.createdAt)])
      ..limit(1);

    return query.watchSingleOrNull();
  }

  Future<Shop> getOrCreatePrimaryShop({
    String? name,
    String? description,
    String? phone,
    String? taxId,
    String? address,
  }) async {
    final existing = await findPrimaryShop();
    if (existing != null) {
      return existing;
    }

    return _createPrimaryShop(
      name: _blankToNull(name) ?? 'ร้านของฉัน',
      description: description,
      phone: phone,
      taxId: taxId,
      address: address,
    );
  }

  Future<Shop> upsertPrimaryShop({
    required String name,
    String? description,
    String? phone,
    String? taxId,
    String? address,
  }) async {
    final existing = await findPrimaryShop();
    if (existing == null) {
      return _createPrimaryShop(
        name: name,
        description: description,
        phone: phone,
        taxId: taxId,
        address: address,
      );
    }

    await (update(shops)..where((table) => table.id.equals(existing.id))).write(
      ShopsCompanion(
        name: Value(name.trim()),
        description: Value(_blankToNull(description)),
        phone: Value(_blankToNull(phone)),
        taxId: Value(_blankToNull(taxId)),
        address: Value(_blankToNull(address)),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return (select(
      shops,
    )..where((table) => table.id.equals(existing.id))).getSingle();
  }

  Future<Shop> _createPrimaryShop({
    required String name,
    String? description,
    String? phone,
    String? taxId,
    String? address,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await into(shops).insert(
      ShopsCompanion.insert(
        id: id,
        name: name.trim().isEmpty ? 'ร้านของฉัน' : name.trim(),
        description: Value(_blankToNull(description)),
        phone: Value(_blankToNull(phone)),
        taxId: Value(_blankToNull(taxId)),
        address: Value(_blankToNull(address)),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return (select(shops)..where((table) => table.id.equals(id))).getSingle();
  }

  Future<void> updateUser({
    required String id,
    required String fullName,
    required String username,
    String? phone,
    String? passwordHash,
    String? passwordSalt,
  }) async {
    await (update(users)..where((table) => table.id.equals(id))).write(
      UsersCompanion(
        fullName: Value(fullName.trim()),
        username: Value(_normalizeUsername(username)),
        phone: Value(_blankToNull(phone)),
        passwordHash: Value.absentIfNull(passwordHash),
        passwordSalt: Value.absentIfNull(passwordSalt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> softDeleteUser(String id) async {
    await (update(users)..where((table) => table.id.equals(id))).write(
      UsersCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> exportSqliteFile(File target) async {
    await target.parent.create(recursive: true);
    if (await target.exists()) {
      await target.delete();
    }

    await customStatement('VACUUM INTO ${_sqliteTextLiteral(target.path)};');
  }

  Future<void> _backfillSaleInstallments() async {
    await customStatement('''
WITH RECURSIVE seq(n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 10
)
INSERT INTO sale_installments (
  id,
  sale_id,
  installment_number,
  due_date,
  due_amount,
  paid_amount,
  paid_at,
  created_at,
  updated_at
)
SELECT
  lower(hex(randomblob(16))),
  s.id,
  seq.n,
  strftime('%s', datetime(s.created_at, 'unixepoch', printf('+%d months', seq.n))),
  CASE
    WHEN seq.n = COALESCE(s.installment_count, 1)
      THEN max(COALESCE(s.remaining_amount, 0) - (COALESCE(s.installment_amount, 0) * (COALESCE(s.installment_count, 1) - 1)), 0)
    ELSE COALESCE(s.installment_amount, 0)
  END,
  0,
  NULL,
  s.created_at,
  s.updated_at
FROM sales s
JOIN seq ON seq.n <= COALESCE(s.installment_count, 1)
WHERE COALESCE(s.is_deleted, 0) = 0
  AND NOT EXISTS (
    SELECT 1
    FROM sale_installments si
    WHERE si.sale_id = s.id
  );
''');
  }

  Future<void> _ensureSaleInstallmentsSchema() async {
    await _createSaleInstallmentsTableIfNeeded();
    await _addSaleInstallmentDueDateColumnIfNeeded();
    await _backfillSaleInstallments();
    await _backfillSaleInstallmentDueDates();
  }

  Future<void> _ensureSalePaymentLogsSchema() {
    return _createSalePaymentLogsTableIfNeeded();
  }

  Future<void> _createSaleInstallmentsTableIfNeeded() {
    return customStatement('''
CREATE TABLE IF NOT EXISTS "sale_installments" (
  "id" TEXT NOT NULL,
  "sale_id" TEXT NOT NULL,
  "installment_number" INTEGER NOT NULL,
  "due_date" INTEGER NOT NULL,
  "due_amount" REAL NOT NULL,
  "paid_amount" REAL NOT NULL DEFAULT 0.0,
  "paid_at" INTEGER NULL,
  "created_at" INTEGER NOT NULL,
  "updated_at" INTEGER NOT NULL,
  PRIMARY KEY ("id")
);
''');
  }

  Future<void> _addSaleInstallmentDueDateColumnIfNeeded() async {
    final columns = await customSelect(
      "PRAGMA table_info('sale_installments');",
    ).get();
    final hasDueDate = columns.any(
      (row) => row.read<String>('name') == 'due_date',
    );
    if (!hasDueDate) {
      await customStatement(
        'ALTER TABLE sale_installments ADD COLUMN due_date INTEGER;',
      );
    }
  }

  Future<void> _backfillSaleInstallmentDueDates() {
    return customStatement('''
UPDATE sale_installments
SET due_date = (
  SELECT strftime('%s', datetime(s.created_at, 'unixepoch', printf('+%d months', sale_installments.installment_number)))
  FROM sales s
  WHERE s.id = sale_installments.sale_id
)
WHERE due_date IS NULL;
''');
  }

  Future<void> _createSalePaymentLogsTableIfNeeded() {
    return customStatement('''
CREATE TABLE IF NOT EXISTS "sale_payment_logs" (
  "id" TEXT NOT NULL,
  "sale_id" TEXT NOT NULL,
  "installment_id" TEXT NOT NULL,
  "installment_number" INTEGER NOT NULL,
  "paid_amount" REAL NOT NULL,
  "receiver_name" TEXT NOT NULL DEFAULT 'ระบบ',
  "paid_at" INTEGER NOT NULL,
  "created_at" INTEGER NOT NULL,
  PRIMARY KEY ("id")
);
''');
  }
}

class SaleListItem {
  const SaleListItem({required this.sale, required this.customer});

  final Sale sale;
  final Customer? customer;

  String get customerName => sale.customerName;
  String? get customerPhone => customer?.phone;
}

class SaleItemDraft {
  const SaleItemDraft({
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  final String productId;
  final String productCode;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double lineTotal;
}

String _normalizeUsername(String value) {
  return value.trim().toLowerCase();
}

String _normalizeProductCode(String value) {
  return value.trim().toUpperCase();
}

String? _blankToNull(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

DateTime? _dateOnlyOrNull(DateTime? value) {
  if (value == null) {
    return null;
  }
  return _dateOnly(value);
}

DateTime _dateOnly(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

String _sqliteTextLiteral(String value) {
  return "'${value.replaceAll("'", "''")}'";
}

List<double> _buildInstallmentDueAmounts({
  required double remainingAmount,
  required int installmentCount,
  required double installmentAmount,
}) {
  if (installmentCount <= 0) {
    return const [];
  }

  final amounts = <double>[];
  for (var index = 0; index < installmentCount; index++) {
    if (index == installmentCount - 1) {
      amounts.add(
        _roundDatabaseMoney(
          remainingAmount - installmentAmount * (installmentCount - 1),
        ),
      );
    } else {
      amounts.add(_roundDatabaseMoney(installmentAmount));
    }
  }
  return amounts;
}

DateTime _addMonthsClamped(DateTime value, int months) {
  final monthIndex = value.month - 1 + months;
  final year = value.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final day = value.day.clamp(1, _daysInMonth(year, month));
  return DateTime(
    year,
    month,
    day,
    value.hour,
    value.minute,
    value.second,
    value.millisecond,
    value.microsecond,
  );
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

double _roundDatabaseMoney(double value) {
  return (value * 100).roundToDouble() / 100;
}
