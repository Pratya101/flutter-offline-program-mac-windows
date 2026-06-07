import 'dart:ui' show FontFeature, PointerDeviceKind;

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_desktop_program/main.dart';
import 'package:offline_desktop_program/src/database/app_database.dart';
import 'package:offline_desktop_program/src/services/auth_service.dart';
import 'package:offline_desktop_program/src/services/contract_print_service.dart';
import 'package:offline_desktop_program/src/services/customer_service.dart';
import 'package:offline_desktop_program/src/services/product_service.dart';
import 'package:offline_desktop_program/src/services/sale_service.dart';
import 'package:offline_desktop_program/src/services/tracking_service.dart';
import 'package:solar_icons/solar_icons.dart';

void main() {
  testWidgets('creates first user and shows profile', (tester) async {
    final database = createInMemoryDatabaseForTests();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      OfflineProgramApp(
        database: database,
        databasePath: Future.value('memory://offline_desktop_program.sqlite'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'), findsOneWidget);

    await tester.tap(find.text('สร้างผู้ใช้แรก'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Alice Admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'alice');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
    await tester.enterText(find.byType(TextFormField).at(3), '0812345678');
    await tester.tap(find.text('สร้างบัญชีและเข้าสู่ระบบ'));
    await tester.pumpAndSettle();

    expect(find.text('ยินดีต้อนรับ, Alice Admin'), findsOneWidget);
    expect(find.text('โปรไฟล์'), findsOneWidget);
    expect(find.text('alice'), findsOneWidget);
    expect(find.text('0812345678'), findsOneWidget);

    await tester.tap(find.byIcon(SolarIconsOutline.userSpeakRounded));
    await tester.pumpAndSettle();

    expect(find.text('ลูกค้า'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'เพิ่มลูกค้า'), findsOneWidget);
    expect(find.text('ยังไม่มีลูกค้า'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'เพิ่มลูกค้า'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'บริษัท ทดสอบ จำกัด',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'ทดสอบ');
    await tester.enterText(find.byType(TextFormField).at(2), '0811111111');
    await tester.enterText(find.byType(TextFormField).at(3), '@customer');
    await tester.ensureVisible(find.text('ติดแบล็คลิสต์'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ติดแบล็คลิสต์'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('บันทึกข้อมูล'));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('บริษัท ทดสอบ จำกัด'), findsOneWidget);
    expect(find.text('ทดสอบ'), findsOneWidget);
    expect(find.text('แบล็คลิสต์'), findsWidgets);
    expect(find.text('customer@example.com'), findsNothing);

    await tester.tap(find.text('ปกติ'));
    await tester.pumpAndSettle();
    expect(find.text('บริษัท ทดสอบ จำกัด'), findsNothing);
    expect(find.text('ยังไม่มีลูกค้า'), findsOneWidget);

    await tester.tap(find.text('แบล็คลิสต์').first);
    await tester.pumpAndSettle();
    expect(find.text('บริษัท ทดสอบ จำกัด'), findsOneWidget);

    await tester.tap(find.byIcon(SolarIconsOutline.box));
    await tester.pumpAndSettle();

    expect(find.text('สินค้า'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'เพิ่มสินค้า'), findsOneWidget);
    expect(find.text('ยังไม่มีสินค้า'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'เพิ่มสินค้า'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), 'สินค้า A');
    await tester.enterText(find.byType(TextFormField).at(2), '1250.50');
    await tester.enterText(find.byType(TextFormField).at(3), 'หมายเหตุสินค้า');
    await tester.tap(find.text('บันทึกข้อมูล'));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.textContaining('PRD-'), findsWidgets);
    expect(find.text('สินค้า A'), findsOneWidget);
    expect(find.text('1,250.50'), findsOneWidget);
    expect(find.text('หมายเหตุสินค้า'), findsOneWidget);

    await tester.tap(find.byIcon(SolarIconsOutline.cartLarge));
    await tester.pumpAndSettle();

    expect(find.text('ขาย'), findsWidgets);
    expect(find.text('ค้นหาลูกค้า'), findsOneWidget);
    expect(find.text('ค้นหาสินค้า'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'เพิ่มรายการ'), findsOneWidget);
    expect(find.text('รายการสินค้า'), findsOneWidget);
    expect(find.text('ยังไม่มีรายการสินค้า'), findsWidgets);
    expect(find.textContaining('ตะกร้า'), findsNothing);
    expect(find.text('เงินดาวน์'), findsWidgets);
    expect(find.text('จำนวนงวด'), findsOneWidget);
    expect(find.text('1 งวด'), findsWidgets);
    expect(find.text('10 งวด'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sale-down-payment-amount-field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('sale-down-payment-mode-amount')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('sale-down-payment-mode-percent')),
      findsOneWidget,
    );
    final downPaymentModeCenterY = tester
        .getCenter(find.byKey(const ValueKey('sale-down-payment-mode-amount')))
        .dy;
    final downPaymentFieldCenterY = tester
        .getCenter(find.byKey(const ValueKey('sale-down-payment-amount-field')))
        .dy;
    expect(
      (downPaymentModeCenterY - downPaymentFieldCenterY).abs(),
      lessThanOrEqualTo(24),
    );
    final installmentRows = <int>{};
    for (var count = 1; count <= 10; count++) {
      installmentRows.add(
        tester
            .getTopLeft(find.byKey(ValueKey('sale-installment-$count')))
            .dy
            .round(),
      );
    }
    expect(installmentRows, hasLength(2));
    expect(find.text('ค่างวด'), findsWidgets);
    expect(find.text('เปอร์เซ็นต์เงินดาวน์'), findsNothing);
    expect(find.text('ยังไม่มีรายการขาย'), findsNothing);
    expect(find.text('เลขที่ขาย'), findsNothing);
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    final formPanel = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_SaleFormPanel',
    );
    expect(formPanel, findsOneWidget);
    expect(
      find.descendant(of: formPanel, matching: find.text('ภาษีมูลค่าเพิ่ม')),
      findsNothing,
    );
    final saveSaleButton = find.widgetWithText(FilledButton, 'บันทึกการขาย');
    expect(saveSaleButton, findsOneWidget);
    final formPanelBottom = tester.getBottomRight(formPanel).dy;
    final saveSaleButtonBottom = tester.getBottomRight(saveSaleButton).dy;
    expect(formPanelBottom - saveSaleButtonBottom, lessThanOrEqualTo(28));
    final cartPanel = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_SaleCartPanel',
    );
    expect(cartPanel, findsOneWidget);
    expect(
      find.descendant(of: cartPanel, matching: find.text('สรุปราคารวม')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: cartPanel, matching: find.text('ภาษีมูลค่าเพิ่ม')),
      findsNothing,
    );
    expect(
      find.descendant(of: cartPanel, matching: find.text('VAT 7% แยก')),
      findsOneWidget,
    );
    final summaryTitleCenterY = tester
        .getCenter(
          find.descendant(of: cartPanel, matching: find.text('สรุปราคารวม')),
        )
        .dy;
    final vatOptionCenterY = tester
        .getCenter(
          find.descendant(of: cartPanel, matching: find.text('VAT 7% แยก')),
        )
        .dy;
    expect(
      (summaryTitleCenterY - vatOptionCenterY).abs(),
      lessThanOrEqualTo(24),
    );
    expect(
      find.descendant(of: cartPanel, matching: find.text('ค้นหาสินค้า')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: cartPanel,
        matching: find.widgetWithText(FilledButton, 'เพิ่มรายการ'),
      ),
      findsOneWidget,
    );

    final downPaymentField = find.byKey(
      const ValueKey('sale-down-payment-amount-field'),
    );
    await tester.tap(find.byKey(const ValueKey('sale-installment-2')));
    await tester.pumpAndSettle();
    final downPaymentEditable = find.descendant(
      of: downPaymentField,
      matching: find.byType(EditableText),
    );
    expect(
      tester.widget<EditableText>(downPaymentEditable).focusNode.hasFocus,
      isTrue,
    );
    await tester.enterText(downPaymentField, '1234');
    await tester.pump();
    expect(tester.testTextInput.hasAnyClients, isTrue);
    expect(
      tester.widget<EditableText>(downPaymentEditable).controller.text,
      '1234',
    );

    await tester.enterText(
      find.byKey(const ValueKey('sale-customer-search-field')),
      'ทดสอบ',
    );
    await tester.pumpAndSettle();
    final customerGesture = await tester.startGesture(
      tester.getCenter(find.textContaining('บริษัท ทดสอบ จำกัด').last),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump();
    await customerGesture.up();
    await tester.pumpAndSettle();
    expect(find.text('แบล็คลิสต์'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(const ValueKey('sale-product-search-field')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('sale-product-search-field')),
      'สินค้า',
    );
    await tester.pumpAndSettle();
    final productGesture = await tester.startGesture(
      tester.getCenter(find.textContaining('สินค้า A').last),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump();
    await productGesture.up();
    await tester.pumpAndSettle();

    final quantityField = find.byKey(
      const ValueKey('sale-product-quantity-field'),
    );
    expect(tester.testTextInput.hasAnyClients, isTrue);
    final quantityEditable = find.descendant(
      of: quantityField,
      matching: find.byType(EditableText),
    );
    expect(
      tester.widget<EditableText>(quantityEditable).focusNode.hasFocus,
      isTrue,
    );

    await tester.ensureVisible(quantityField);
    await tester.pumpAndSettle();
    await tester.tap(quantityField);
    await tester.pump();
    expect(tester.testTextInput.hasAnyClients, isTrue);

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'เพิ่มรายการ'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'เพิ่มรายการ'));
    await tester.pumpAndSettle();

    expect(find.text('สรุปยอดขาย'), findsNothing);
    expect(find.text('สรุปราคารวม'), findsOneWidget);
    expect(find.text('1 รายการ'), findsNothing);
    expect(find.text('สินค้า A'), findsWidgets);
    final saleCartPanel = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_SaleCartPanel',
    );
    final cartPanelWidth = tester.getSize(saleCartPanel).width;
    final saleTableWidth = tester.getSize(find.byType(DataTable).last).width;
    expect(saleTableWidth, greaterThanOrEqualTo(cartPanelWidth - 48));
    final totalSummaryCard = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_SaleTotalSummaryCard',
    );
    final cartPanelBottom = tester.getBottomRight(saleCartPanel).dy;
    final summaryBottom = tester.getBottomRight(totalSummaryCard).dy;
    expect(cartPanelBottom - summaryBottom, lessThanOrEqualTo(28));
    final grandTotalLabelRight = tester.getTopRight(find.text('ยอดรวม')).dx;
    final grandTotalAmountLeft = tester
        .getTopLeft(
          find.byKey(const ValueKey('sale-summary-grand-total-amount')),
        )
        .dx;
    expect(grandTotalAmountLeft - grandTotalLabelRight, lessThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == '_SalePaymentMetric',
      ),
      findsNothing,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == '_SaleAccountingRow',
      ),
      findsNWidgets(6),
    );
    final grandTotalAmount = tester.widget<Text>(
      find.byKey(const ValueKey('sale-summary-grand-total-amount')),
    );
    expect(grandTotalAmount.textAlign, TextAlign.right);
    expect(
      grandTotalAmount.style?.fontFeatures,
      contains(FontFeature.tabularFigures()),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('sale-down-payment-amount-field')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('sale-down-payment-amount-field')),
      '250',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('sale-installment-10')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sale-installment-10')));
    await tester.pumpAndSettle();
    var installmentAmount = tester.widget<Text>(
      find.byKey(const ValueKey('sale-summary-installment-amount')),
    );
    expect(installmentAmount.data, '100.05');
    expect(find.text('บาท/งวด'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('sale-down-payment-mode-percent')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('sale-down-payment-amount-field')),
      '20',
    );
    await tester.pumpAndSettle();
    installmentAmount = tester.widget<Text>(
      find.byKey(const ValueKey('sale-summary-installment-amount')),
    );
    expect(installmentAmount.data, '100.04');

    await tester.enterText(
      find.byKey(const ValueKey('cart-qty-field')).first,
      '2',
    );
    await tester.pump();
    expect(find.text('2,501.00'), findsNothing);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('2,501.00'), findsWidgets);
    installmentAmount = tester.widget<Text>(
      find.byKey(const ValueKey('sale-summary-installment-amount')),
    );
    expect(installmentAmount.data, '200.08');

    await tester.tap(find.byIcon(SolarIconsOutline.usersGroupRounded));
    await tester.pumpAndSettle();

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'เพิ่มผู้ใช้'), findsOneWidget);
    expect(find.text('Alice Admin'), findsWidgets);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  test('auth service supports user CRUD lifecycle', () async {
    final database = createInMemoryDatabaseForTests();
    final authService = AuthService(database);

    final created = await authService.register(
      fullName: 'Jane Manager',
      username: 'Jane',
      password: 'first-pass',
      phone: null,
    );

    final loggedIn = await authService.login(
      username: 'jane',
      password: 'first-pass',
    );
    expect(loggedIn.id, created.id);
    expect(loggedIn.username, 'jane');

    await authService.updateUser(
      id: created.id,
      fullName: 'Jane Manager Updated',
      username: 'jane.manager',
      password: 'second-pass',
      phone: '0899999999',
    );

    final updated = await authService.getProfile(created.id);
    expect(updated.fullName, 'Jane Manager Updated');
    expect(updated.username, 'jane.manager');
    expect(updated.phone, '0899999999');

    final relogged = await authService.login(
      username: 'jane.manager',
      password: 'second-pass',
    );
    expect(relogged.id, created.id);

    await authService.deleteUser(created.id);
    expect(authService.getProfile(created.id), throwsA(isA<AuthException>()));

    await database.close();
  });

  test('customer service supports customer CRUD lifecycle', () async {
    final database = createInMemoryDatabaseForTests();
    final customerService = CustomerService(database);

    await customerService.createCustomer(
      const CustomerPayload(
        name: 'Acme Customer',
        nickname: 'Acme',
        phone: '0811111111',
        email: 'billing@acme.test',
        taxId: '1234567890123',
        type: 'COMPANY',
        companyOfficeType: 'สำนักงานใหญ่',
        address: '99 Test Road',
        province: 'กรุงเทพมหานคร',
        remark: 'ลูกค้าทดสอบ',
        isBlacklisted: true,
      ),
    );

    var customers = await database.watchActiveCustomers().first;
    expect(customers, hasLength(1));
    expect(customers.single.name, 'Acme Customer');
    expect(customers.single.type, 'COMPANY');
    expect(customers.single.taxId, '1234567890123');
    expect(customers.single.isBlacklisted, isTrue);

    await customerService.updateCustomer(
      id: customers.single.id,
      payload: const CustomerPayload(
        name: 'Acme Customer Updated',
        nickname: 'Updated',
        phone: '0822222222',
        email: 'updated@acme.test',
        type: 'PERSONAL',
        province: 'ชลบุรี',
        isBlacklisted: false,
      ),
    );

    customers = await database.watchActiveCustomers().first;
    expect(customers.single.name, 'Acme Customer Updated');
    expect(customers.single.nickname, 'Updated');
    expect(customers.single.type, 'PERSONAL');
    expect(customers.single.province, 'ชลบุรี');
    expect(customers.single.isBlacklisted, isFalse);

    await customerService.deleteCustomer(customers.single.id);
    customers = await database.watchActiveCustomers().first;
    expect(customers, isEmpty);

    expect(
      customerService.createCustomer(
        const CustomerPayload(
          name: 'Invalid Company',
          type: 'COMPANY',
          taxId: '123',
        ),
      ),
      throwsA(isA<CustomerException>()),
    );

    await database.close();
  });

  test('product service supports product CRUD lifecycle', () async {
    final database = createInMemoryDatabaseForTests();
    final productService = ProductService(database);

    final created = await productService.createProduct(
      const ProductPayload(
        name: 'Steel Sheet',
        salePrice: 1250.5,
        remark: 'Auto code product',
      ),
    );

    expect(created.code, startsWith('PRD-'));
    expect(created.name, 'Steel Sheet');
    expect(created.salePrice, 1250.5);

    await productService.updateProduct(
      id: created.id,
      payload: const ProductPayload(
        code: 'sku-001',
        name: 'Steel Sheet Updated',
        salePrice: 1300,
        remark: 'Manual code',
      ),
    );

    var products = await database.watchActiveProducts().first;
    expect(products, hasLength(1));
    expect(products.single.code, 'SKU-001');
    expect(products.single.name, 'Steel Sheet Updated');
    expect(products.single.salePrice, 1300);

    expect(
      productService.createProduct(
        const ProductPayload(code: 'SKU-001', name: 'Duplicate', salePrice: 1),
      ),
      throwsA(isA<ProductException>()),
    );

    expect(
      productService.createProduct(
        const ProductPayload(name: '', salePrice: 1),
      ),
      throwsA(isA<ProductException>()),
    );

    expect(
      productService.createProduct(
        const ProductPayload(name: 'Invalid Price', salePrice: -1),
      ),
      throwsA(isA<ProductException>()),
    );

    await productService.deleteProduct(products.single.id);
    products = await database.watchActiveProducts().first;
    expect(products, isEmpty);

    await database.close();
  });

  test('sale service calculates VAT and adjustable down payment', () async {
    final database = createInMemoryDatabaseForTests();
    final customerService = CustomerService(database);
    final productService = ProductService(database);
    final saleService = SaleService(database);

    await customerService.createCustomer(
      const CustomerPayload(name: 'ลูกค้าทดสอบ', type: 'PERSONAL'),
    );
    final customer = (await database.watchActiveCustomers().first).single;
    final product = await productService.createProduct(
      const ProductPayload(name: 'สินค้าเงินผ่อน', salePrice: 12000),
    );
    final secondProduct = await productService.createProduct(
      const ProductPayload(name: 'สินค้าเสริม', salePrice: 2500),
    );

    var totals = saleService.calculateTotals(
      items: [SaleItemPayload(product: product, quantity: 1)],
      vatOption: SaleVatOption.none,
      downPaymentAmount: 2400,
      installmentCount: 10,
    );

    expect(totals.subtotal, 12000);
    expect(totals.vatAmount, 0);
    expect(totals.grandTotal, 12000);
    expect(totals.downPaymentPercent, 20);
    expect(totals.downPaymentAmount, 2400);
    expect(totals.remainingAmount, 9600);
    expect(totals.installmentCount, 10);
    expect(totals.installmentAmount, 960);

    totals = saleService.calculateTotals(
      items: [SaleItemPayload(product: product, quantity: 1)],
      vatOption: SaleVatOption.excluded,
      downPaymentAmount: 3852,
      installmentCount: 6,
    );

    expect(totals.subtotal, 12000);
    expect(totals.vatAmount, 840);
    expect(totals.grandTotal, 12840);
    expect(totals.downPaymentPercent, 30);
    expect(totals.downPaymentAmount, 3852);
    expect(totals.remainingAmount, 8988);
    expect(totals.installmentCount, 6);
    expect(totals.installmentAmount, 1498);

    final sale = await saleService.createSale(
      SalePayload(
        customer: customer,
        items: [
          SaleItemPayload(product: product, quantity: 1),
          SaleItemPayload(product: secondProduct, quantity: 2),
        ],
        vatOption: SaleVatOption.none,
        downPaymentAmount: 3400,
        installmentCount: 10,
      ),
    );
    final saleItems = await database.getSaleItems(sale.id);

    expect(sale.saleNumber, startsWith('SALE-'));
    expect(sale.customerName, 'ลูกค้าทดสอบ');
    expect(sale.grandTotal, 17000);
    expect(sale.downPaymentPercent, 20);
    expect(sale.downPaymentAmount, 3400);
    expect(sale.installmentCount, 10);
    expect(sale.installmentAmount, 1360);
    expect(saleItems, hasLength(2));
    expect(saleItems.map((item) => item.productName), [
      'สินค้าเงินผ่อน',
      'สินค้าเสริม',
    ]);
    expect(saleItems.map((item) => item.quantity), [1, 2]);

    expect(
      saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 0)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 2400,
          installmentCount: 10,
        ),
      ),
      throwsA(isA<SaleException>()),
    );

    expect(
      saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 1)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 12001,
          installmentCount: 10,
        ),
      ),
      throwsA(isA<SaleException>()),
    );

    expect(
      saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 1)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 1200,
          installmentCount: 11,
        ),
      ),
      throwsA(isA<SaleException>()),
    );

    await database.close();
  });

  test(
    'sale service creates installments and records payments by installment',
    () async {
      final database = createInMemoryDatabaseForTests();
      final customerService = CustomerService(database);
      final productService = ProductService(database);
      final saleService = SaleService(database);

      await customerService.createCustomer(
        const CustomerPayload(
          name: 'ลูกค้างวด',
          type: 'PERSONAL',
          phone: '0890001111',
        ),
      );
      final customer = (await database.watchActiveCustomers().first).single;
      final product = await productService.createProduct(
        const ProductPayload(name: 'สินค้าแบ่งจ่าย', salePrice: 1000),
      );

      final sale = await saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 1)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 100,
          installmentCount: 3,
        ),
      );

      var detail = await saleService.getSalePaymentDetail(sale.id);
      expect(detail.totalInstallments, 3);
      expect(detail.paidInstallments, 0);
      expect(detail.installmentPaidAmount, 0);
      expect(detail.outstandingAmount, 900);
      expect(detail.totalPaidAmount, 100);
      expect(detail.installments.map((item) => item.dueAmount), [
        300,
        300,
        300,
      ]);

      await saleService.recordInstallmentPayment(
        saleId: sale.id,
        installmentId: detail.installments.first.id,
        amount: 300,
      );

      detail = await saleService.getSalePaymentDetail(sale.id);
      final paymentLogs = await database.getSalePaymentLogs(sale.id);
      expect(detail.paidInstallments, 1);
      expect(detail.installmentPaidAmount, 300);
      expect(detail.totalPaidAmount, 400);
      expect(detail.outstandingAmount, 600);
      expect(detail.installments.first.isPaid, isTrue);
      expect(paymentLogs, hasLength(1));
      expect(paymentLogs.single.installmentNumber, 1);
      expect(paymentLogs.single.paidAmount, 300);
      expect(paymentLogs.single.receiverName, 'ระบบ');

      expect(
        saleService.recordInstallmentPayment(
          saleId: sale.id,
          installmentId: detail.installments.first.id,
          amount: 1,
        ),
        throwsA(isA<SaleException>()),
      );

      await database.close();
    },
  );

  test(
    'contract document prints payment log stamps in payment table',
    () async {
      final database = createInMemoryDatabaseForTests();
      final customerService = CustomerService(database);
      final productService = ProductService(database);
      final saleService = SaleService(database);

      await customerService.createCustomer(
        const CustomerPayload(
          name: 'ลูกค้าสัญญา',
          type: 'PERSONAL',
          phone: '0891234567',
          address: '99 หมู่ 1',
          subDistrict: 'ในเมือง',
          district: 'เมือง',
          province: 'ขอนแก่น',
        ),
      );
      final customer = (await database.watchActiveCustomers().first).single;
      final product = await productService.createProduct(
        const ProductPayload(name: 'ตู้เหล็ก', salePrice: 1000),
      );
      final sale = await saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 1)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 100,
          installmentCount: 3,
        ),
      );
      final detail = await saleService.getSalePaymentDetail(sale.id);

      await saleService.recordInstallmentPayment(
        saleId: sale.id,
        installmentId: detail.installments.first.id,
        amount: 300,
      );

      final html = await SaleContractPrintService(
        database,
      ).buildContractHtml(sale.id);

      expect(html, contains('หนังสือสัญญาซื้อขาย'));
      expect(html, contains('ลูกค้าสัญญา'));
      expect(html, contains('ตู้เหล็ก'));
      expect(html, contains('ตารางการชำระเงิน'));
      expect(html, contains('วันที่จ่าย'));
      expect(html, contains('จำนวนเงิน'));
      expect(html, contains('ผู้รับเงิน'));
      expect(html, contains('งวดที่ 1'));
      expect(html, contains('300.00'));
      expect(html, contains('ระบบ'));

      await database.close();
    },
  );

  test('sale service creates monthly due dates for each installment', () async {
    final database = createInMemoryDatabaseForTests();
    final customerService = CustomerService(database);
    final productService = ProductService(database);
    final saleService = SaleService(database);

    await customerService.createCustomer(
      const CustomerPayload(name: 'ลูกค้าครบรอบ', type: 'PERSONAL'),
    );
    final customer = (await database.watchActiveCustomers().first).single;
    final product = await productService.createProduct(
      const ProductPayload(name: 'สินค้าผ่อนตามรอบ', salePrice: 900),
    );

    final sale = await saleService.createSale(
      SalePayload(
        customer: customer,
        items: [SaleItemPayload(product: product, quantity: 1)],
        vatOption: SaleVatOption.none,
        downPaymentAmount: 0,
        installmentCount: 3,
      ),
    );
    final rows = await database
        .customSelect(
          '''
SELECT installment_number, due_date
FROM sale_installments
WHERE sale_id = ?
ORDER BY installment_number
''',
          variables: [Variable<String>(sale.id)],
        )
        .get();

    expect(rows.map((row) => row.read<int>('installment_number')), [1, 2, 3]);
    expect(rows.map((row) => row.read<int>('due_date')), [
      _unixSeconds(_addMonthsClamped(sale.createdAt, 1)),
      _unixSeconds(_addMonthsClamped(sale.createdAt, 2)),
      _unixSeconds(_addMonthsClamped(sale.createdAt, 3)),
    ]);

    await database.close();
  });

  test('tracking service groups pending installments by order', () async {
    final database = createInMemoryDatabaseForTests();
    final customerService = CustomerService(database);
    final productService = ProductService(database);
    final saleService = SaleService(database);
    final trackingService = TrackingService(database);

    await customerService.createCustomer(
      const CustomerPayload(name: 'ลูกค้าใกล้ถึงกำหนด', type: 'PERSONAL'),
    );
    await customerService.createCustomer(
      const CustomerPayload(name: 'ลูกค้ากำหนดถัดไป', type: 'PERSONAL'),
    );
    await customerService.createCustomer(
      const CustomerPayload(name: 'ลูกค้าชำระแล้ว', type: 'PERSONAL'),
    );
    final customers = await database.watchActiveCustomers().first;
    final product = await productService.createProduct(
      const ProductPayload(name: 'สินค้าติดตาม', salePrice: 1000),
    );

    final laterSale = await saleService.createSale(
      SalePayload(
        customer: customers.firstWhere(
          (item) => item.name == 'ลูกค้ากำหนดถัดไป',
        ),
        items: [SaleItemPayload(product: product, quantity: 1)],
        vatOption: SaleVatOption.none,
        downPaymentAmount: 0,
        installmentCount: 1,
      ),
    );
    final nearestSale = await saleService.createSale(
      SalePayload(
        customer: customers.firstWhere(
          (item) => item.name == 'ลูกค้าใกล้ถึงกำหนด',
        ),
        items: [SaleItemPayload(product: product, quantity: 1)],
        vatOption: SaleVatOption.none,
        downPaymentAmount: 0,
        installmentCount: 2,
      ),
    );
    final paidSale = await saleService.createSale(
      SalePayload(
        customer: customers.firstWhere((item) => item.name == 'ลูกค้าชำระแล้ว'),
        items: [SaleItemPayload(product: product, quantity: 1)],
        vatOption: SaleVatOption.none,
        downPaymentAmount: 0,
        installmentCount: 1,
      ),
    );

    final now = DateTime.now();
    await _setSingleInstallmentDueDate(
      database: database,
      saleId: laterSale.id,
      installmentNumber: 1,
      dueDate: now.add(const Duration(days: 7)),
    );
    await _setSingleInstallmentDueDate(
      database: database,
      saleId: nearestSale.id,
      installmentNumber: 1,
      dueDate: now.add(const Duration(days: 2)),
    );
    await _setSingleInstallmentDueDate(
      database: database,
      saleId: nearestSale.id,
      installmentNumber: 2,
      dueDate: now.add(const Duration(days: 9)),
    );
    final paidInstallment = (await database.getSaleInstallments(
      paidSale.id,
    )).single;
    await saleService.recordInstallmentPayment(
      saleId: paidSale.id,
      installmentId: paidInstallment.id,
      amount: paidInstallment.dueAmount,
    );

    final groups = await trackingService.watchPendingOrders().first;

    expect(groups.map((item) => item.customerName), [
      'ลูกค้าใกล้ถึงกำหนด',
      'ลูกค้ากำหนดถัดไป',
    ]);
    expect(groups.map((item) => item.saleNumber), [
      nearestSale.saleNumber,
      laterSale.saleNumber,
    ]);
    expect(groups.first.installments.map((item) => item.installmentNumber), [
      1,
      2,
    ]);
    expect(groups.first.totalOutstandingAmount, 1000);
    expect(groups.first.nearestInstallment.installmentNumber, 1);
    expect(groups.last.installments.map((item) => item.installmentNumber), [1]);

    await database.close();
  });

  test(
    'sale service repairs missing installment table before saving sale',
    () async {
      final database = createInMemoryDatabaseForTests();
      final customerService = CustomerService(database);
      final productService = ProductService(database);
      final saleService = SaleService(database);

      await customerService.createCustomer(
        const CustomerPayload(name: 'ลูกค้าฐานข้อมูลเก่า', type: 'PERSONAL'),
      );
      final customer = (await database.watchActiveCustomers().first).single;
      final product = await productService.createProduct(
        const ProductPayload(name: 'สินค้าฐานข้อมูลเก่า', salePrice: 1200),
      );

      await database.customStatement('DROP TABLE sale_installments;');

      final sale = await saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 1)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 360,
          installmentCount: 10,
        ),
      );
      final detail = await saleService.getSalePaymentDetail(sale.id);

      expect(detail.sale.grandTotal, 1200);
      expect(detail.totalInstallments, 10);
      expect(detail.installments.map((item) => item.dueAmount), [
        84,
        84,
        84,
        84,
        84,
        84,
        84,
        84,
        84,
        84,
      ]);

      await database.close();
    },
  );

  testWidgets('sales list searches and opens detail payment capture', (
    tester,
  ) async {
    final database = createInMemoryDatabaseForTests();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 960);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final customerService = CustomerService(database);
    final saleService = SaleService(database);

    late final Sale sale;
    await tester.runAsync(() async {
      await customerService.createCustomer(
        const CustomerPayload(
          name: 'บริษัท รายการขาย จำกัด',
          type: 'COMPANY',
          taxId: '1234567890123',
          phone: '0812223333',
        ),
      );
      final customer = (await database.watchActiveCustomers().first).single;
      final now = DateTime.now();
      final product = Product(
        id: 'product-order-detail',
        code: 'SKU-ORDER',
        name: 'สินค้า Order Detail',
        salePrice: 987654321.25,
        remark: null,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      sale = await saleService.createSale(
        SalePayload(
          customer: customer,
          items: [SaleItemPayload(product: product, quantity: 1)],
          vatOption: SaleVatOption.none,
          downPaymentAmount: 12345678.9,
          installmentCount: 10,
        ),
      );
    });
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SaleListPage(database: database, saleService: saleService),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('รายการขาย'), findsWidgets);
    expect(
      find.byKey(const ValueKey('sale-list-search-field')),
      findsOneWidget,
    );
    expect(find.text(sale.saleNumber), findsOneWidget);
    expect(find.text('บริษัท รายการขาย จำกัด'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('sale-list-search-field')),
      '0812223333',
    );
    await tester.pump();
    expect(find.text(sale.saleNumber), findsOneWidget);

    final openDetailButton = find.byKey(ValueKey('sale-list-open-${sale.id}'));
    expect(
      tester.getCenter(openDetailButton).dx,
      lessThanOrEqualTo(tester.view.physicalSize.width),
    );

    await tester.tap(openDetailButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('รายละเอียด Order'), findsOneWidget);
    expect(find.text('ข้อมูลการรับชำระเงิน'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'พิมพ์สัญญา'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sale-order-document-panel')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('sale-order-payment-panel')),
      findsOneWidget,
    );
    final documentPanelWidth = tester
        .getSize(find.byKey(const ValueKey('sale-order-document-panel')))
        .width;
    final paymentPanelWidth = tester
        .getSize(find.byKey(const ValueKey('sale-order-payment-panel')))
        .width;
    final documentPanelLeft = tester
        .getTopLeft(find.byKey(const ValueKey('sale-order-document-panel')))
        .dx;
    final paymentPanelLeft = tester
        .getTopLeft(find.byKey(const ValueKey('sale-order-payment-panel')))
        .dx;
    expect(documentPanelWidth, greaterThan(paymentPanelWidth));
    expect(documentPanelLeft, lessThan(paymentPanelLeft));
    expect(find.text('0 / 10 งวด'), findsOneWidget);
    expect(find.text('ยอดคงเหลือ'), findsWidgets);
    expect(
      tester
          .getTopRight(find.byKey(const ValueKey('sale-installment-row-1')))
          .dx,
      lessThanOrEqualTo(paymentPanelLeft + paymentPanelWidth),
    );
    expect(
      tester
          .getTopRight(find.byKey(const ValueKey('sale-installment-pay-1')))
          .dx,
      lessThanOrEqualTo(paymentPanelLeft + paymentPanelWidth),
    );
    expect(
      find.widgetWithText(FilledButton, 'บันทึกรับชำระงวดนี้'),
      findsWidgets,
    );

    await tester.tap(find.byKey(const ValueKey('sale-installment-pay-1')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('บันทึกรับชำระ'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'ยืนยันรับชำระ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('1 / 10 งวด'), findsOneWidget);
    expect(find.text('รับชำระแล้ว'), findsWidgets);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(database.close);
  });
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

int _unixSeconds(DateTime value) {
  return value.millisecondsSinceEpoch ~/ 1000;
}

Future<void> _setSingleInstallmentDueDate({
  required AppDatabase database,
  required String saleId,
  required int installmentNumber,
  required DateTime dueDate,
}) {
  return database.customStatement(
    '''
UPDATE sale_installments
SET due_date = ?
WHERE sale_id = ? AND installment_number = ?;
''',
    [_unixSeconds(dueDate), saleId, installmentNumber],
  );
}
