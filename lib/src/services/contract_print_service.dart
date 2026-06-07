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
    final items = await _database.getSaleItems(sale.id);
    final installments = await _database.getSaleInstallments(sale.id);
    final paymentLogs = await _database.getSalePaymentLogs(sale.id);
    final paymentRows = _buildPaymentRows(sale, paymentLogs);

    return '''
<!doctype html>
<html lang="th">
<head>
  <meta charset="utf-8">
  <title>สัญญาซื้อขาย ${_escapeHtml(sale.saleNumber)}</title>
  <style>
    @page { size: A4; margin: 12mm; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      color: #1f2937;
      font-family: "TH Sarabun New", "Sarabun", Tahoma, sans-serif;
      font-size: 15px;
      line-height: 1.35;
      background: #fff;
    }
    .document {
      width: 100%;
      min-height: 277mm;
      border: 1px solid #64748b;
      padding: 10mm;
    }
    .store-box {
      border: 1px solid #64748b;
      border-radius: 6px;
      text-align: center;
      padding: 8px 10px 10px;
      margin-bottom: 14px;
    }
    .title {
      margin: 0 0 2px;
      font-size: 22px;
      font-weight: 800;
      text-decoration: underline;
    }
    .store-name {
      margin: 0;
      color: #1d4ed8;
      font-size: 30px;
      font-weight: 900;
    }
    .store-detail {
      margin: 2px 0 0;
      font-weight: 700;
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
      min-height: 22px;
      border-bottom: 1px dotted #475569;
      padding: 0 4px 1px;
      font-weight: 700;
    }
    .body-text {
      margin: 10px 0;
      text-align: justify;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 8px 0 12px;
    }
    th, td {
      border: 1px solid #64748b;
      padding: 5px 7px;
      vertical-align: top;
    }
    th {
      text-align: center;
      background: #f1f5f9;
      font-weight: 800;
    }
    .right { text-align: right; }
    .center { text-align: center; }
    .payment-table {
      width: 48%;
      min-width: 320px;
      margin-top: 16px;
    }
    .payment-stamp {
      font-weight: 800;
      color: #047857;
    }
    .signature-grid {
      display: grid;
      grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
      gap: 18px;
      margin-top: 18px;
    }
    .signature-line {
      display: grid;
      grid-template-columns: 44px minmax(0, 1fr);
      gap: 8px;
      align-items: end;
      margin-top: 14px;
    }
    .muted { color: #64748b; }
    @media print {
      .no-print { display: none; }
      .document { border-color: #334155; }
    }
  </style>
</head>
<body>
  <div class="document">
    <section class="store-box">
      <h1 class="title">หนังสือสัญญาซื้อขาย</h1>
      <p class="store-name">ร้าน ดี ดี เฟอร์นิเจอร์</p>
      <p class="store-detail">จำหน่ายเฟอร์นิเจอร์ทุกชนิด โทร. 098-1235023, 042-287246, 080-4063509</p>
    </section>

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
      <span class="line">ร้าน ดี ดี เฟอร์นิเจอร์</span>
    </div>

    <p class="body-text">
      ผู้ซื้อและผู้ขายได้ตกลงทำสัญญาซื้อขายสินค้าตามรายการต่อไปนี้ โดยผู้ซื้อยินยอมชำระเงินตามจำนวนงวดและกำหนดวันที่ระบุไว้ในสัญญานี้
    </p>

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

    <div class="signature-grid">
      <div>
        <div class="signature-line"><span>ลงชื่อ</span><span class="line"></span></div>
        <div class="signature-line"><span>ลงชื่อ</span><span class="line"></span></div>
        <div class="signature-line"><span>ลงชื่อ</span><span class="line"></span></div>
      </div>
      <div>
        <div class="signature-line"><span>ผู้ขาย</span><span class="line"></span></div>
        <div class="signature-line"><span>ผู้ซื้อ</span><span class="line"></span></div>
        <div class="signature-line"><span>พยาน</span><span class="line"></span></div>
      </div>
    </div>
  </div>
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
          receiverName: 'ระบบ',
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
