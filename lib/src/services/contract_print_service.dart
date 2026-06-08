import 'dart:io';

import 'package:path/path.dart' as p;

import '../database/app_database.dart';
import '../database/database_connection.dart';

class SaleContractPrintService {
  const SaleContractPrintService(this._database);

  final AppDatabase _database;

  Future<String> buildContractHtml(String saleId) async {
    final sale = await _database.findActiveSaleById(saleId);
    if (sale == null) {
      throw const SaleContractPrintException('ไม่พบรายการขาย');
    }

    final customer = await _database.findCustomerById(sale.customerId);
    final shop = await _database.getOrCreatePrimaryShop();
    final items = await _database.getSaleItems(sale.id);
    final installments = await _database.getSaleInstallments(sale.id);
    final paymentLogs = await _database.getSalePaymentLogs(sale.id);
    final paymentRows = _buildPaymentRows(sale, paymentLogs);
    final shopDescription = _shopDocumentDescription(shop);
    final contractIntro = _contractIntroText(
      sale: sale,
      customer: customer,
      shop: shop,
    );
    final contractTerms = _contractTermsHtml(
      sale: sale,
      installments: installments,
    );

    return '''
<!doctype html>
<html lang="th">
<head>
  <meta charset="utf-8">
  <title>สัญญาซื้อขาย ${_escapeHtml(sale.saleNumber)}</title>
  <style>
    @page { size: A4; margin: 10mm; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      color: #1f2937;
      font-family: "Sarabun", "Noto Sans Thai", Tahoma, Arial, sans-serif;
      font-size: 12px;
      line-height: 1.25;
      background: #fff;
    }
    .document {
      width: 100%;
      min-height: 0;
      border: 1px solid #64748b;
      border-collapse: separate;
      border-spacing: 0;
      margin: 0;
    }
    .contract-print-header {
      display: table-header-group;
    }
    .contract-print-body {
      display: table-row-group;
    }
    .contract-print-header-cell,
    .contract-print-body-cell {
      border: 0;
      vertical-align: top;
    }
    .contract-print-header-cell {
      padding: 7mm 7mm 0;
    }
    .contract-print-body-cell {
      padding: 0 7mm 7mm;
    }
    .store-box {
      border: 1px solid #64748b;
      border-radius: 6px;
      text-align: center;
      padding: 7px 10px 8px;
      margin-bottom: 10px;
    }
    .title {
      margin: 0 0 2px;
      font-size: 18px;
      font-weight: 800;
      text-decoration: underline;
    }
    .store-name {
      margin: 0;
      color: #1d4ed8;
      font-size: 25px;
      font-weight: 900;
    }
    .store-detail {
      margin: 2px 0 0;
      font-weight: 700;
      overflow-wrap: anywhere;
    }
    .line-row {
      display: grid;
      grid-template-columns: 72px minmax(0, 1fr) 64px minmax(0, 1fr);
      gap: 8px;
      align-items: end;
      margin-bottom: 8px;
    }
    .label { font-weight: 700; color: #334155; }
    .line {
      min-height: 18px;
      border-bottom: 1px dotted #475569;
      padding: 0 4px 1px;
      font-weight: 700;
    }
    .body-text,
    .contract-intro {
      margin: 7px 0;
      text-align: justify;
      overflow-wrap: anywhere;
    }
    .contract-terms {
      margin: 6px 0 8px;
      padding-left: 18px;
    }
    .contract-terms li {
      margin: 3px 0;
      text-align: justify;
      overflow-wrap: anywhere;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 6px 0 9px;
    }
    th, td {
      border: 1px solid #64748b;
      padding: 3px 5px;
      vertical-align: top;
    }
    th {
      text-align: center;
      background: #f1f5f9;
      font-weight: 800;
    }
    .right { text-align: right; }
    .center { text-align: center; }
    .payment-signature-grid {
      display: grid;
      grid-template-columns: minmax(320px, 1fr) minmax(230px, 0.72fr);
      gap: 16px;
      align-items: start;
      margin-top: 10px;
    }
    .payment-table {
      margin: 0;
    }
    .payment-stamp {
      font-weight: 800;
      color: #047857;
    }
    .signature-section {
      margin-top: 0;
    }
    .signature-row {
      display: grid;
      grid-template-columns: 44px minmax(0, 1fr) 96px;
      column-gap: 10px;
      align-items: end;
      min-height: 32px;
    }
    .signature-row + .signature-row {
      margin-top: 12px;
    }
    .signature-label {
      font-weight: 700;
      white-space: nowrap;
    }
    .signature-fill {
      height: 18px;
      border-bottom: 2px solid #475569;
    }
    .muted { color: #64748b; }
    @media print {
      .no-print { display: none; }
      .document { border-color: #334155; }
    }
  </style>
</head>
<body>
  <table class="document">
    <thead class="contract-print-header">
      <tr>
        <td class="contract-print-header-cell">
          <section class="store-box">
            <h1 class="title">หนังสือสัญญาซื้อขาย</h1>
            <p class="store-name">${_escapeHtml(shop.name)}</p>
            <p class="store-detail">${_escapeHtml(shopDescription)}</p>
          </section>
        </td>
      </tr>
    </thead>
    <tbody class="contract-print-body">
      <tr>
        <td class="contract-print-body-cell">

    <div class="line-row">
      <span class="label">เลขที่</span>
      <span class="line">${_escapeHtml(sale.saleNumber)}</span>
      <span class="label">วันที่</span>
      <span class="line">${_formatThaiDate(sale.createdAt)}</span>
    </div>
    <div class="line-row">
      <span class="label">ข้าพเจ้า</span>
      <span class="line">${_escapeHtml(sale.customerName)}</span>
      <span class="label">โทร</span>
      <span class="line">${_escapeHtml(customer?.phone ?? '-')}</span>
    </div>
    <div class="line-row">
      <span class="label">ที่อยู่</span>
      <span class="line">${_escapeHtml(_customerAddress(customer))}</span>
      <span class="label">ผู้ขาย</span>
      <span class="line">${_escapeHtml(shop.name)}</span>
    </div>

    <p class="contract-intro">
      ${_escapeHtml(contractIntro)}
    </p>
    <ol class="contract-terms">
      $contractTerms
    </ol>

    <table>
      <thead>
        <tr>
          <th style="width: 12%">จำนวน</th>
          <th>รายการ</th>
          <th style="width: 18%">ราคา</th>
          <th style="width: 18%">จำนวนเงิน</th>
        </tr>
      </thead>
      <tbody>
        ${items.map(_itemRowHtml).join('\n')}
      </tbody>
    </table>

    <p class="body-text">
      ได้ตกลงซื้อขายสินค้าเป็นจำนวนเงิน <strong>${_money(sale.grandTotal)}</strong> บาท
      ชำระเงินดาวน์ <strong>${_money(sale.downPaymentAmount)}</strong> บาท
      ยอดคงเหลือ <strong>${_money(sale.remainingAmount)}</strong> บาท
      โดยแบ่งชำระ <strong>${installments.length}</strong> งวด
    </p>

    <table>
      <thead>
        <tr>
          <th style="width: 12%">งวด</th>
          <th style="width: 22%">วันครบกำหนด</th>
          <th style="width: 22%">ยอดงวด</th>
          <th style="width: 22%">จ่ายแล้ว</th>
          <th style="width: 22%">คงเหลือ</th>
        </tr>
      </thead>
      <tbody>
        ${installments.map(_installmentRowHtml).join('\n')}
      </tbody>
    </table>

    <div class="payment-signature-grid">
      <table class="payment-table">
        <thead>
          <tr>
            <th colspan="4">ตารางการชำระเงิน</th>
          </tr>
          <tr>
            <th style="width: 28%">วันที่จ่าย</th>
            <th style="width: 20%">งวด</th>
            <th style="width: 28%">จำนวนเงิน</th>
            <th style="width: 24%">ผู้รับเงิน</th>
          </tr>
        </thead>
        <tbody>
          ${paymentRows.map(_paymentRowHtml).join('\n')}
        </tbody>
      </table>

      <div class="signature-section">
        <div class="signature-row">
          <span class="signature-label">ลงชื่อ</span><span class="signature-fill"></span>
          <span class="signature-label">ผู้เช่า</span>
        </div>
        <div class="signature-row">
          <span class="signature-label">ลงชื่อ</span><span class="signature-fill"></span>
          <span class="signature-label">ผู้ใช้เช่า</span>
        </div>
        <div class="signature-row">
          <span class="signature-label">ลงชื่อ</span><span class="signature-fill"></span>
          <span class="signature-label">ผู้ค้ำประกัน</span>
        </div>
        <div class="signature-row">
          <span class="signature-label">ลงชื่อ</span><span class="signature-fill"></span>
          <span class="signature-label">พยาน</span>
        </div>
      </div>
    </div>
        </td>
      </tr>
    </tbody>
  </table>
  <script>
    window.addEventListener('load', () => setTimeout(() => window.print(), 350));
  </script>
</body>
</html>
''';
  }

  Future<File> writeContractHtml(String saleId) async {
    final sale = await _database.findActiveSaleById(saleId);
    if (sale == null) {
      throw const SaleContractPrintException('ไม่พบรายการขาย');
    }
    final html = await buildContractHtml(saleId);
    final root = await appDataDirectory();
    final directory = Directory(p.join(root.path, 'contracts'));
    await directory.create(recursive: true);
    final file = File(
      p.join(directory.path, 'contract_${sale.saleNumber}.html'),
    );
    await file.writeAsString(html);
    return file;
  }

  Future<File> printContract(String saleId) async {
    final file = await writeContractHtml(saleId);
    await _openFile(file);
    return file;
  }

  List<_ContractPaymentRow> _buildPaymentRows(
    Sale sale,
    List<SalePaymentLog> logs,
  ) {
    final rows = <_ContractPaymentRow>[];
    if (sale.downPaymentAmount > 0) {
      rows.add(
        _ContractPaymentRow(
          paidAt: sale.createdAt,
          installmentLabel: 'เงินดาวน์',
          amount: sale.downPaymentAmount,
          receiverName: sale.receiverName,
        ),
      );
    }
    rows.addAll(
      logs.map(
        (log) => _ContractPaymentRow(
          paidAt: log.paidAt,
          installmentLabel: 'งวดที่ ${log.installmentNumber}',
          amount: log.paidAmount,
          receiverName: log.receiverName,
        ),
      ),
    );
    if (rows.isEmpty) {
      rows.add(
        _ContractPaymentRow(
          paidAt: null,
          installmentLabel: '-',
          amount: null,
          receiverName: '-',
        ),
      );
    }
    return rows;
  }
}

class SaleContractPrintException implements Exception {
  const SaleContractPrintException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _ContractPaymentRow {
  const _ContractPaymentRow({
    required this.paidAt,
    required this.installmentLabel,
    required this.amount,
    required this.receiverName,
  });

  final DateTime? paidAt;
  final String installmentLabel;
  final double? amount;
  final String receiverName;
}

String _itemRowHtml(SaleItem item) {
  return '''
<tr>
  <td class="center">${_money(item.quantity)}</td>
  <td>${_escapeHtml(item.productName)}</td>
  <td class="right">${_money(item.unitPrice)}</td>
  <td class="right">${_money(item.lineTotal)}</td>
</tr>
''';
}

String _installmentRowHtml(SaleInstallment installment) {
  final outstanding = _roundMoney(
    installment.dueAmount - installment.paidAmount,
  );
  return '''
<tr>
  <td class="center">${installment.installmentNumber}</td>
  <td class="center">${_formatThaiDate(installment.dueDate)}</td>
  <td class="right">${_money(installment.dueAmount)}</td>
  <td class="right">${_money(installment.paidAmount)}</td>
  <td class="right">${_money(outstanding < 0 ? 0 : outstanding)}</td>
</tr>
''';
}

String _paymentRowHtml(_ContractPaymentRow row) {
  return '''
<tr>
  <td class="center">${row.paidAt == null ? '-' : _formatThaiDate(row.paidAt!)}</td>
  <td class="center">${_escapeHtml(row.installmentLabel)}</td>
  <td class="right payment-stamp">${row.amount == null ? '-' : _money(row.amount!)}</td>
  <td class="center">${_escapeHtml(row.receiverName)}</td>
</tr>
''';
}

String _customerAddress(Customer? customer) {
  if (customer == null) {
    return '-';
  }
  final parts = [
    customer.address,
    customer.subDistrict,
    customer.district,
    customer.province,
    customer.zipcode,
  ].where((value) => value != null && value.trim().isNotEmpty);
  final address = parts.join(' ');
  return address.isEmpty ? '-' : address;
}

String _shopDocumentDescription(Shop shop) {
  final details = <String>[];
  final customDescription = shop.description?.trim();
  final address = shop.address?.trim();
  final taxId = shop.taxId?.trim();
  final phone = shop.phone?.trim();
  if (customDescription != null && customDescription.isNotEmpty) {
    details.add(customDescription);
  }
  if (address != null && address.isNotEmpty) {
    details.add(address);
  }
  if (taxId != null && taxId.isNotEmpty) {
    details.add('เลขประจำตัวประชาชน $taxId');
  }
  if (phone != null && phone.isNotEmpty) {
    details.add('โทร. $phone');
  }
  if (details.isEmpty) {
    return 'เอกสารสัญญาซื้อขายของ ${shop.name}';
  }
  return details.join(' ');
}

String _contractIntroText({
  required Sale sale,
  required Customer? customer,
  required Shop shop,
}) {
  final buyerName = sale.customerName.trim().isEmpty
      ? 'ผู้ซื้อ'
      : sale.customerName.trim();
  final sellerName = shop.name.trim().isEmpty ? 'ผู้ขาย' : shop.name.trim();
  final customerAddress = _customerAddress(customer);
  final addressText = customerAddress == '-' ? '' : ' อยู่ที่ $customerAddress';
  final identityText = _customerIdentityText(customer);
  final phoneText = _customerPhoneText(customer);

  return 'สัญญาฉบับนี้ทำขึ้นระหว่าง $sellerName ซึ่งต่อไปนี้เรียกว่า '
      '"ผู้ขาย" ฝ่ายหนึ่ง กับ $buyerName$identityText$addressText$phoneText '
      'ซึ่งต่อไปนี้เรียกว่า "ผู้ซื้อ" อีกฝ่ายหนึ่ง คู่สัญญาทั้งสองฝ่ายตกลง'
      'ทำสัญญาซื้อขายสินค้าเงินผ่อนตามรายการและเงื่อนไขดังต่อไปนี้';
}

String _contractTermsHtml({
  required Sale sale,
  required List<SaleInstallment> installments,
}) {
  final installmentCount = installments.isEmpty
      ? sale.installmentCount
      : installments.length;
  final firstDueDate = installments.isEmpty
      ? '-'
      : _formatThaiDate(installments.first.dueDate);
  final lastDueDate = installments.isEmpty
      ? '-'
      : _formatThaiDate(installments.last.dueDate);
  final vatText = sale.vatAmount > 0
      ? ' โดยมีภาษีมูลค่าเพิ่ม ${_money(sale.vatAmount)} บาท'
      : '';
  final installmentText = sale.installmentAmount > 0
      ? ' งวดละประมาณ ${_money(sale.installmentAmount)} บาท'
      : '';
  final terms = [
    'ผู้ขายตกลงขายและผู้ซื้อตกลงซื้อสินค้าตามรายการ จำนวน ราคา และรายละเอียด'
        'ที่ระบุไว้ในตารางรายการสินค้า โดยให้ถือว่าตารางรายการสินค้าและตาราง'
        'การชำระเงินเป็นส่วนหนึ่งของสัญญาฉบับนี้',
    'ราคาซื้อขายรวมทั้งสิ้น ${_money(sale.grandTotal)} บาท$vatText ผู้ซื้อ'
        'ได้ชำระเงินดาวน์ในวันทำสัญญาเป็นจำนวน ${_money(sale.downPaymentAmount)} '
        'บาท และมียอดคงเหลือที่ต้องชำระ ${_money(sale.remainingAmount)} บาท',
    'ยอดคงเหลือดังกล่าวแบ่งชำระเป็น $installmentCount งวด$installmentText '
        'เริ่มชำระงวดแรกวันที่ $firstDueDate และครบกำหนดงวดสุดท้ายวันที่ '
        '$lastDueDate หรือตามวันที่ระบุไว้ในตารางการชำระเงิน',
    'ผู้ซื้อมีหน้าที่ชำระเงินแต่ละงวดให้ครบถ้วนภายในวันครบกำหนด การชำระเงิน'
        'ทุกครั้งให้บันทึกวันที่จ่าย งวดที่ชำระ จำนวนเงิน และชื่อผู้รับเงินไว้'
        'ในตารางการชำระเงินหรือหลักฐานรับเงินที่ผู้ขายออกให้',
    'เมื่อผู้ซื้อได้รับสินค้าแล้ว ให้ตรวจสอบชนิด จำนวน และสภาพสินค้าในขณะรับมอบ '
        'หากพบความไม่ถูกต้องให้แจ้งผู้ขายทันที ส่วนการรับประกัน การซ่อมแซม '
        'การเปลี่ยนสินค้า หรือค่าขนส่งเพิ่มเติม ให้เป็นไปตามหลักฐานหรือข้อตกลง'
        'ที่ผู้ขายกำหนดไว้เป็นลายลักษณ์อักษร',
    'คู่สัญญาตกลงให้กรรมสิทธิ์ในสินค้าตามสัญญานี้โอนไปยังผู้ซื้อเมื่อผู้ซื้อ'
        'ชำระราคาสินค้าครบถ้วนแล้ว ในระหว่างที่ยังชำระไม่ครบ ผู้ซื้อจะดูแล'
        'รักษาสินค้า ไม่ขาย โอน จำนำ ให้เช่า หรือให้บุคคลอื่นครอบครองสินค้า'
        'โดยไม่ได้รับความยินยอมจากผู้ขาย',
    'หากผู้ซื้อผิดนัดชำระเงินงวดใดงวดหนึ่ง หรือชำระไม่ครบตามจำนวนที่กำหนด '
        'ผู้ขายมีสิทธิ์แจ้งเตือน ติดตามทวงถาม ระงับการส่งมอบหรือบริการเพิ่มเติม '
        'และเรียกให้ผู้ซื้อชำระยอดค้างทั้งหมดพร้อมค่าใช้จ่ายตามจริงที่เกิดขึ้น'
        'จากการติดตามหนี้เท่าที่กฎหมายอนุญาต',
    'การผ่อนผัน การเปลี่ยนแปลงวันชำระเงิน การเปลี่ยนแปลงสินค้า หรือเงื่อนไข'
        'เพิ่มเติมใด ๆ จะมีผลต่อเมื่อมีหลักฐานเป็นหนังสือหรือหลักฐานอิเล็กทรอนิกส์'
        'ที่ตรวจสอบได้จากผู้ขาย',
    'คู่สัญญาได้อ่านข้อความในสัญญาฉบับนี้โดยตลอดแล้ว เห็นว่าถูกต้องตรงตาม'
        'เจตนา จึงลงลายมือชื่อไว้เป็นสำคัญต่อหน้าพยาน',
  ];

  return terms.map((term) => '<li>${_escapeHtml(term)}</li>').join('\n');
}

String _customerIdentityText(Customer? customer) {
  final taxId = customer?.taxId?.trim();
  if (taxId == null || taxId.isEmpty) {
    return '';
  }
  return ' เลขประจำตัวประชาชน $taxId';
}

String _customerPhoneText(Customer? customer) {
  final phone = customer?.phone?.trim();
  if (phone == null || phone.isEmpty) {
    return '';
  }
  return ' โทร. $phone';
}

String _escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

String _money(double value) {
  return value
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
}

String _formatThaiDate(DateTime value) {
  final local = value.toLocal();
  return '${local.day}/${local.month}/${local.year + 543}';
}

double _roundMoney(double value) {
  return (value * 100).roundToDouble() / 100;
}

Future<void> _openFile(File file) async {
  if (Platform.isMacOS) {
    await Process.start('open', [file.path]);
    return;
  }
  if (Platform.isWindows) {
    await Process.start('cmd', [
      '/c',
      'start',
      '',
      file.path,
    ], runInShell: true);
    return;
  }
  if (Platform.isLinux) {
    await Process.start('xdg-open', [file.path]);
  }
}
