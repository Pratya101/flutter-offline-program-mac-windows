import '../database/app_database.dart';
import 'license_service.dart';

class SaleException implements Exception {
  const SaleException(this.message);

  final String message;

  @override
  String toString() => message;
}

enum SaleVatOption { none, excluded, included }

class SaleItemPayload {
  const SaleItemPayload({required this.product, required this.quantity});

  final Product product;
  final double quantity;
}

class SalePayload {
  const SalePayload({
    required this.customer,
    required this.items,
    required this.vatOption,
    required this.downPaymentAmount,
    required this.installmentCount,
    required this.firstDueDate,
    this.receiverName = 'ระบบ',
  });

  final Customer customer;
  final List<SaleItemPayload> items;
  final SaleVatOption vatOption;
  final double downPaymentAmount;
  final int installmentCount;
  final DateTime firstDueDate;
  final String receiverName;
}

class SaleTotals {
  const SaleTotals({
    required this.subtotal,
    required this.vatAmount,
    required this.grandTotal,
    required this.downPaymentPercent,
    required this.downPaymentAmount,
    required this.remainingAmount,
    required this.installmentCount,
    required this.installmentAmount,
  });

  final double subtotal;
  final double vatAmount;
  final double grandTotal;
  final double downPaymentPercent;
  final double downPaymentAmount;
  final double remainingAmount;
  final int installmentCount;
  final double installmentAmount;
}

class SalePaymentDetail {
  const SalePaymentDetail({required this.sale, required this.installments});

  final Sale sale;
  final List<SaleInstallment> installments;

  int get totalInstallments => installments.length;

  int get paidInstallments {
    return installments.where((installment) => installment.isPaid).length;
  }

  double get installmentPaidAmount {
    return _roundMoney(
      installments.fold<double>(
        0,
        (sum, installment) => sum + installment.paidAmount,
      ),
    );
  }

  double get totalPaidAmount {
    return _roundMoney(sale.downPaymentAmount + installmentPaidAmount);
  }

  double get outstandingAmount {
    final outstanding = sale.grandTotal - totalPaidAmount;
    return _roundMoney(outstanding < 0 ? 0 : outstanding);
  }
}

class SaleService {
  SaleService(this._database, {LicenseService? licenseService})
    : _licenseService = licenseService ?? LicenseService.fromEnvironment();

  static const vatRate = 0.07;

  final AppDatabase _database;
  final LicenseService _licenseService;

  SaleTotals calculateTotals({
    required List<SaleItemPayload> items,
    required SaleVatOption vatOption,
    required double downPaymentAmount,
    required int installmentCount,
  }) {
    _validateItems(items);
    _validateInstallmentCount(installmentCount);

    final lineTotal = items.fold<double>(
      0,
      (sum, item) => sum + item.product.salePrice * item.quantity,
    );

    final (subtotal, vatAmount, grandTotal) = switch (vatOption) {
      SaleVatOption.none => (lineTotal, 0.0, lineTotal),
      SaleVatOption.excluded => (
        lineTotal,
        _roundMoney(lineTotal * vatRate),
        _roundMoney(lineTotal * (1 + vatRate)),
      ),
      SaleVatOption.included => (
        _roundMoney(lineTotal / (1 + vatRate)),
        _roundMoney(lineTotal - _roundMoney(lineTotal / (1 + vatRate))),
        lineTotal,
      ),
    };

    _validateDownPaymentAmount(
      amount: downPaymentAmount,
      grandTotal: grandTotal,
    );

    final roundedDownPayment = _roundMoney(downPaymentAmount);
    final downPaymentPercent = grandTotal == 0
        ? 0.0
        : _roundMoney(roundedDownPayment / grandTotal * 100);
    final remainingAmount = _roundMoney(grandTotal - roundedDownPayment);
    final installmentAmount = _roundMoney(remainingAmount / installmentCount);

    return SaleTotals(
      subtotal: _roundMoney(subtotal),
      vatAmount: _roundMoney(vatAmount),
      grandTotal: _roundMoney(grandTotal),
      downPaymentPercent: downPaymentPercent,
      downPaymentAmount: roundedDownPayment,
      remainingAmount: remainingAmount,
      installmentCount: installmentCount,
      installmentAmount: installmentAmount,
    );
  }

  Future<Sale> createSale(SalePayload payload) async {
    _validateCustomer(payload.customer);
    _validateItems(payload.items);
    _validateInstallmentCount(payload.installmentCount);
    try {
      await _licenseService.assertCanCreateSale(_database);
    } on LicenseException catch (error) {
      throw SaleException(error.message);
    }

    final totals = calculateTotals(
      items: payload.items,
      vatOption: payload.vatOption,
      downPaymentAmount: payload.downPaymentAmount,
      installmentCount: payload.installmentCount,
    );

    return _database.createSale(
      saleNumber: _generateSaleNumber(),
      customerId: payload.customer.id,
      customerName: payload.customer.name,
      vatOption: payload.vatOption.storageValue,
      vatRate: payload.vatOption == SaleVatOption.none ? 0 : vatRate,
      subtotal: totals.subtotal,
      vatAmount: totals.vatAmount,
      grandTotal: totals.grandTotal,
      downPaymentPercent: totals.downPaymentPercent,
      downPaymentAmount: totals.downPaymentAmount,
      remainingAmount: totals.remainingAmount,
      receiverName: payload.receiverName,
      installmentCount: totals.installmentCount,
      installmentAmount: totals.installmentAmount,
      firstDueDate: _dateOnly(payload.firstDueDate),
      items: payload.items.map((item) {
        final lineTotal = _roundMoney(item.product.salePrice * item.quantity);
        return SaleItemDraft(
          productId: item.product.id,
          productCode: item.product.code,
          productName: item.product.name,
          quantity: item.quantity,
          unitPrice: item.product.salePrice,
          lineTotal: lineTotal,
        );
      }).toList(),
    );
  }

  Future<void> deleteSale(String id) {
    return _database.softDeleteSale(id);
  }

  Future<SalePaymentDetail> getSalePaymentDetail(String saleId) async {
    final sale = await _database.findActiveSaleById(saleId);
    if (sale == null) {
      throw const SaleException('ไม่พบรายการขาย');
    }

    final installments = await _database.getSaleInstallments(saleId);
    return SalePaymentDetail(sale: sale, installments: installments);
  }

  Future<void> recordInstallmentPayment({
    required String saleId,
    required String installmentId,
    required double amount,
    String receiverName = 'ระบบ',
  }) async {
    final sale = await _database.findActiveSaleById(saleId);
    if (sale == null) {
      throw const SaleException('ไม่พบรายการขาย');
    }

    final installment = await _database.findSaleInstallment(
      saleId: saleId,
      installmentId: installmentId,
    );
    if (installment == null) {
      throw const SaleException('ไม่พบงวดที่ต้องการรับชำระ');
    }

    final roundedAmount = _roundMoney(amount);
    if (roundedAmount <= 0 || roundedAmount.isNaN || roundedAmount.isInfinite) {
      throw const SaleException('ยอดรับชำระต้องมากกว่า 0');
    }

    final outstanding = installment.outstandingAmount;
    if (outstanding <= 0) {
      throw const SaleException('งวดนี้รับชำระครบแล้ว');
    }
    if (roundedAmount > outstanding) {
      throw const SaleException('ยอดรับชำระต้องไม่เกินยอดคงเหลือของงวด');
    }

    final paidAmount = _roundMoney(installment.paidAmount + roundedAmount);
    await _database.updateSaleInstallmentPayment(
      saleId: saleId,
      installmentId: installmentId,
      installmentNumber: installment.installmentNumber,
      paidAmount: paidAmount,
      paymentAmount: roundedAmount,
      receiverName: receiverName,
      paidAt: paidAmount >= installment.dueAmount
          ? DateTime.now()
          : installment.paidAt,
    );
  }

  void _validateCustomer(Customer customer) {
    if (customer.isDeleted) {
      throw const SaleException('ลูกค้านี้ถูกลบแล้ว');
    }
  }

  void _validateItems(List<SaleItemPayload> items) {
    if (items.isEmpty) {
      throw const SaleException('กรุณาเลือกสินค้า');
    }

    for (final item in items) {
      if (item.product.isDeleted) {
        throw const SaleException('สินค้านี้ถูกลบแล้ว');
      }
      if (item.quantity.isNaN ||
          item.quantity.isInfinite ||
          item.quantity <= 0) {
        throw const SaleException('จำนวนสินค้าต้องมากกว่า 0');
      }
      if (item.product.salePrice.isNaN ||
          item.product.salePrice.isInfinite ||
          item.product.salePrice < 0) {
        throw const SaleException('ราคาสินค้าไม่ถูกต้อง');
      }
    }
  }

  void _validateDownPaymentAmount({
    required double amount,
    required double grandTotal,
  }) {
    if (amount.isNaN || amount.isInfinite || amount < 0) {
      throw const SaleException('ยอดเงินดาวน์ต้องมากกว่าหรือเท่ากับ 0');
    }
    if (amount > grandTotal) {
      throw const SaleException('ยอดเงินดาวน์ต้องไม่เกินยอดรวม');
    }
  }

  void _validateInstallmentCount(int count) {
    if (count < 1 || count > 10) {
      throw const SaleException('จำนวนงวดต้องอยู่ระหว่าง 1-10');
    }
  }
}

extension SaleInstallmentStatus on SaleInstallment {
  double get outstandingAmount {
    final outstanding = dueAmount - paidAmount;
    return _roundMoney(outstanding < 0 ? 0 : outstanding);
  }

  bool get isPaid => outstandingAmount <= 0;

  bool get isOverdue {
    if (isPaid) {
      return false;
    }
    return _dateOnly(dueDate).isBefore(_dateOnly(DateTime.now()));
  }

  int get overdueDays {
    if (!isOverdue) {
      return 0;
    }
    return _dateOnly(DateTime.now()).difference(_dateOnly(dueDate)).inDays;
  }
}

extension SaleVatOptionLabel on SaleVatOption {
  String get storageValue {
    return switch (this) {
      SaleVatOption.none => 'NONE',
      SaleVatOption.excluded => 'EXCLUDED',
      SaleVatOption.included => 'INCLUDED',
    };
  }

  String get label {
    return switch (this) {
      SaleVatOption.none => 'ไม่มี VAT',
      SaleVatOption.excluded => 'VAT 7% แยก',
      SaleVatOption.included => 'VAT 7% รวม',
    };
  }

  static SaleVatOption fromStorage(String value) {
    return switch (value) {
      'EXCLUDED' => SaleVatOption.excluded,
      'INCLUDED' => SaleVatOption.included,
      _ => SaleVatOption.none,
    };
  }
}

String _generateSaleNumber() {
  final now = DateTime.now();
  final date =
      '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';
  final suffix = (now.microsecond % 10000).toString().padLeft(4, '0');
  return 'SALE-$date-$suffix';
}

double _roundMoney(double value) {
  return (value * 100).roundToDouble() / 100;
}

DateTime _dateOnly(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
