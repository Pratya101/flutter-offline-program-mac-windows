import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_desktop_program/main.dart';

void main() {
  testWidgets('sale page uses custom icon toggle controls', (tester) async {
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
    await tester.pumpAndSettle();

    await tester.tap(find.text('สร้างผู้ใช้แรก'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'admin');
    await tester.enterText(find.byType(TextFormField).at(2), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'Admin Shop');
    await tester.tap(find.text('สร้างบัญชีและเข้าสู่ระบบ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('shell-menu-ขาย')));
    await tester.pumpAndSettle();

    expect(find.byType(SegmentedButton), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('_SaleToggleGroup'),
      ),
      findsNWidgets(2),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().startsWith('_SaleToggleButton'),
      ),
      findsNWidgets(5),
    );
    expect(
      find.byKey(const ValueKey('sale-down-payment-mode-amount')),
      findsOneWidget,
    );
    expect(find.text('VAT 7% แยก'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
