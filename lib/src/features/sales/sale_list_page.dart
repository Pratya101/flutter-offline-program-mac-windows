part of '../../../main.dart';

class SaleListPage extends StatefulWidget {
  const SaleListPage({
    super.key,
    required this.database,
    required this.saleService,
  });

  final AppDatabase database;
  final SaleService saleService;

  @override
  State<SaleListPage> createState() => _SaleListPageState();
}

class _SaleListPageState extends State<SaleListPage> {
  final _searchController = TextEditingController();
  String? _selectedSaleId;
  Future<_SaleOrderDetailData>? _detailFuture;
  var _recordingPayment = false;
  var _printingContract = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Sale sale) {
    setState(() {
      _selectedSaleId = sale.id;
      _detailFuture = _loadDetail(sale.id);
    });
  }

  Future<_SaleOrderDetailData> _loadDetail(String saleId) async {
    final paymentDetail = await widget.saleService.getSalePaymentDetail(saleId);
    final saleItems = await widget.database.getSaleItems(saleId);
    return _SaleOrderDetailData(
      paymentDetail: paymentDetail,
      saleItems: saleItems,
    );
  }

  void _reloadDetail() {
    final saleId = _selectedSaleId;
    if (saleId == null) {
      return;
    }
    setState(() {
      _detailFuture = _loadDetail(saleId);
    });
  }

  void _closeDetail() {
    setState(() {
      _selectedSaleId = null;
      _detailFuture = null;
    });
  }

  Future<void> _openPaymentDialog(SaleInstallment installment) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return _SalePaymentAmountDialog(installment: installment);
      },
    );
    if (amount == null) {
      return;
    }

    setState(() => _recordingPayment = true);
    try {
      await widget.saleService.recordInstallmentPayment(
        saleId: installment.saleId,
        installmentId: installment.id,
        amount: amount,
      );
      if (!mounted) {
        return;
      }
      _showToast(context, 'บันทึกรับชำระแล้ว');
      _reloadDetail();
    } on SaleException catch (error) {
      if (!mounted) {
        return;
      }
      _showToast(context, error.message);
    } finally {
      if (mounted) {
        setState(() => _recordingPayment = false);
      }
    }
  }

  Future<void> _printContract() async {
    final saleId = _selectedSaleId;
    if (saleId == null) {
      return;
    }

    setState(() => _printingContract = true);
    try {
      final file = await SaleContractPrintService(
        widget.database,
      ).printContract(saleId);
      if (!mounted) {
        return;
      }
      _showToast(context, 'สร้างเอกสารสัญญาแล้ว: ${file.path}');
    } on SaleContractPrintException catch (error) {
      if (!mounted) {
        return;
      }
      _showToast(context, error.message);
    } finally {
      if (mounted) {
        setState(() => _printingContract = false);
      }
    }
  }

  List<SaleListItem> _filterSales(List<SaleListItem> sales) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return sales;
    }

    return sales.where((item) {
      final sale = item.sale;
      return sale.saleNumber.toLowerCase().contains(query) ||
          sale.customerName.toLowerCase().contains(query) ||
          (item.customerPhone?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final detailFuture = _detailFuture;
    if (detailFuture != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: _SalePaymentDetailPanel(
          detailFuture: detailFuture,
          recordingPayment: _recordingPayment,
          printingContract: _printingContract,
          onBack: _closeDetail,
          onPrintContract: _printContract,
          onRecordPayment: _openPaymentDialog,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'รายการขาย',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                width: 340,
                child: TextField(
                  key: const ValueKey('sale-list-search-field'),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'ค้นหาชื่อลูกค้า / เบอร์โทร / เลขที่เอกสาร',
                    prefixIcon: Icon(SolarIconsOutline.magnifier),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: _SaleListTablePanel(
                    database: widget.database,
                    filterSales: _filterSales,
                    onOpenDetail: _openDetail,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleOrderDetailData {
  const _SaleOrderDetailData({
    required this.paymentDetail,
    required this.saleItems,
  });

  final SalePaymentDetail paymentDetail;
  final List<SaleItem> saleItems;
}

class _SalePaymentAmountDialog extends StatefulWidget {
  const _SalePaymentAmountDialog({required this.installment});

  final SaleInstallment installment;

  @override
  State<_SalePaymentAmountDialog> createState() =>
      _SalePaymentAmountDialogState();
}

class _SalePaymentAmountDialogState extends State<_SalePaymentAmountDialog> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: _formatSalePrice(widget.installment.outstandingAmount),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _confirm() {
    final amount = _parseSalePrice(_amountController.text);
    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
      title: const Text('บันทึกรับชำระ'),
      content: SizedBox(
        width: 360,
        child: TextField(
          controller: _amountController,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText:
                'ยอดรับชำระ งวดที่ ${widget.installment.installmentNumber}',
            prefixIcon: const Icon(SolarIconsOutline.walletMoney),
            suffixText: 'บาท',
          ),
          onSubmitted: (_) => _confirm(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(onPressed: _confirm, child: const Text('ยืนยันรับชำระ')),
      ],
    );
  }
}

class _SaleListTablePanel extends StatelessWidget {
  const _SaleListTablePanel({
    required this.database,
    required this.filterSales,
    required this.onOpenDetail,
  });

  final AppDatabase database;
  final List<SaleListItem> Function(List<SaleListItem>) filterSales;
  final ValueChanged<Sale> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: ClipRRect(
        borderRadius: _cardBorderRadius(),
        child: StreamBuilder<List<SaleListItem>>(
          stream: database.watchActiveSaleListItems(),
          builder: (context, snapshot) {
            final sales = filterSales(snapshot.data ?? const []);
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: Text('กำลังโหลดรายการขาย...'));
            }
            if (sales.isEmpty) {
              return Center(
                child: Text(
                  'ยังไม่มีรายการขาย',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            _softSlateColor,
                          ),
                          headingTextStyle: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: const Color(0xFF334155),
                                fontWeight: FontWeight.w900,
                              ),
                          columns: const [
                            DataColumn(label: Text('ดู')),
                            DataColumn(label: Text('เลขที่')),
                            DataColumn(label: Text('ลูกค้า')),
                            DataColumn(label: Text('เบอร์โทร')),
                            DataColumn(label: Text('วันที่')),
                            DataColumn(label: Text('ยอดรวม'), numeric: true),
                            DataColumn(label: Text('คงเหลือ'), numeric: true),
                          ],
                          rows: [
                            for (final item in sales)
                              DataRow(
                                onSelectChanged: (_) => onOpenDetail(item.sale),
                                cells: [
                                  DataCell(
                                    IconButton(
                                      key: ValueKey(
                                        'sale-list-open-${item.sale.id}',
                                      ),
                                      tooltip: 'เปิดรายละเอียด',
                                      onPressed: () => onOpenDetail(item.sale),
                                      icon: const Icon(SolarIconsOutline.eye),
                                    ),
                                  ),
                                  DataCell(Text(item.sale.saleNumber)),
                                  DataCell(Text(item.sale.customerName)),
                                  DataCell(
                                    Text(_displayText(item.customerPhone)),
                                  ),
                                  DataCell(
                                    Text(_formatDateTime(item.sale.createdAt)),
                                  ),
                                  DataCell(
                                    Text(
                                      _formatSalePrice(item.sale.grandTotal),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      _formatSalePrice(
                                        item.sale.remainingAmount,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SalePaymentDetailPanel extends StatelessWidget {
  const _SalePaymentDetailPanel({
    required this.detailFuture,
    required this.recordingPayment,
    required this.printingContract,
    required this.onBack,
    required this.onPrintContract,
    required this.onRecordPayment,
  });

  final Future<_SaleOrderDetailData> detailFuture;
  final bool recordingPayment;
  final bool printingContract;
  final VoidCallback onBack;
  final VoidCallback onPrintContract;
  final ValueChanged<SaleInstallment> onRecordPayment;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: FutureBuilder<_SaleOrderDetailData>(
          future: detailFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('กำลังโหลดรายละเอียด...'));
            }

            final data = snapshot.data!;
            final detail = data.paymentDetail;
            return LayoutBuilder(
              builder: (context, constraints) {
                final wideLayout = constraints.maxWidth >= 1080;
                final documentPanel = KeyedSubtree(
                  key: const ValueKey('sale-order-document-panel'),
                  child: _buildDocumentPanel(context, data),
                );
                final paymentPanel = KeyedSubtree(
                  key: const ValueKey('sale-order-payment-panel'),
                  child: _buildPaymentPanel(
                    context,
                    detail,
                    boundedHeight: wideLayout,
                  ),
                );

                if (!wideLayout) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        documentPanel,
                        const SizedBox(height: 18),
                        paymentPanel,
                      ],
                    ),
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: documentPanel),
                    const SizedBox(width: 18),
                    const VerticalDivider(width: 1),
                    const SizedBox(width: 18),
                    SizedBox(width: 420, child: paymentPanel),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocumentPanel(BuildContext context, _SaleOrderDetailData data) {
    final detail = data.paymentDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'กลับ',
              onPressed: onBack,
              icon: const Icon(SolarIconsOutline.arrowLeft),
            ),
            const SizedBox(width: 4),
            const Icon(SolarIconsOutline.billList, color: _primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'รายละเอียด Order',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              key: const ValueKey('sale-contract-print-button'),
              onPressed: printingContract ? null : onPrintContract,
              icon: printingContract
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(SolarIconsOutline.printer, size: 18),
              label: const Text('พิมพ์สัญญา'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _surfaceBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SalePaymentMetric(
                  label: 'ยอดรวม',
                  value: '${_formatSalePrice(detail.sale.grandTotal)} บาท',
                ),
                _SalePaymentMetric(
                  label: 'เงินดาวน์',
                  value:
                      '${_formatSalePrice(detail.sale.downPaymentAmount)} บาท',
                ),
                _SalePaymentMetric(
                  label: 'ยอดคงเหลือ',
                  value: '${_formatSalePrice(detail.outstandingAmount)} บาท',
                  emphasized: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _SaleOrderItemsTable(items: data.saleItems),
      ],
    );
  }

  Widget _buildPaymentPanel(
    BuildContext context,
    SalePaymentDetail detail, {
    required bool boundedHeight,
  }) {
    final installmentList = ListView.separated(
      shrinkWrap: !boundedHeight,
      physics: boundedHeight ? null : const NeverScrollableScrollPhysics(),
      itemCount: detail.installments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final installment = detail.installments[index];
        return _SaleInstallmentPaymentTile(
          installment: installment,
          recordingPayment: recordingPayment,
          onRecordPayment: onRecordPayment,
        );
      },
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surfaceBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  SolarIconsOutline.walletMoney,
                  color: _primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ข้อมูลการรับชำระเงิน',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${detail.paidInstallments} / ${detail.totalInstallments} งวด',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SalePaymentMetric(
              label: 'รับชำระงวดแล้ว',
              value: '${_formatSalePrice(detail.installmentPaidAmount)} บาท',
            ),
            _SalePaymentMetric(
              label: 'ยอดคงเหลือ',
              value: '${_formatSalePrice(detail.outstandingAmount)} บาท',
              emphasized: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  SolarIconsOutline.billList,
                  size: 18,
                  color: _primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'รายการงวดชำระ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${detail.installments.length} รายการ',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (boundedHeight)
              Expanded(child: installmentList)
            else
              installmentList,
          ],
        ),
      ),
    );
  }
}

class _SaleOrderItemsTable extends StatelessWidget {
  const _SaleOrderItemsTable({required this.items});

  final List<SaleItem> items;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _softSlateColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surfaceBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          headingRowHeight: 38,
          dataRowMinHeight: 42,
          dataRowMaxHeight: 48,
          headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF334155),
            fontWeight: FontWeight.w900,
          ),
          columns: const [
            DataColumn(label: Text('สินค้า')),
            DataColumn(label: Text('จำนวน'), numeric: true),
            DataColumn(label: Text('ราคา'), numeric: true),
            DataColumn(label: Text('รวม'), numeric: true),
          ],
          rows: [
            for (final item in items)
              DataRow(
                cells: [
                  DataCell(Text(item.productName)),
                  DataCell(Text(_formatSalePrice(item.quantity))),
                  DataCell(Text(_formatSalePrice(item.unitPrice))),
                  DataCell(Text(_formatSalePrice(item.lineTotal))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SalePaymentMetric extends StatelessWidget {
  const _SalePaymentMetric({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: emphasized ? _primaryColor : const Color(0xFF334155),
              fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleInstallmentPaymentTile extends StatelessWidget {
  const _SaleInstallmentPaymentTile({
    required this.installment,
    required this.recordingPayment,
    required this.onRecordPayment,
  });

  final SaleInstallment installment;
  final bool recordingPayment;
  final ValueChanged<SaleInstallment> onRecordPayment;

  @override
  Widget build(BuildContext context) {
    final isPaid = installment.isPaid;
    final isOverdue = installment.isOverdue;
    final statusColor = isPaid
        ? _primaryColor
        : isOverdue
        ? const Color(0xFFDC2626)
        : const Color(0xFF64748B);
    final statusText = isPaid
        ? 'รับชำระแล้ว'
        : isOverdue
        ? 'เลยกำหนด ${installment.overdueDays} วัน'
        : 'รอชำระ';
    return DecoratedBox(
      key: ValueKey('sale-installment-row-${installment.installmentNumber}'),
      decoration: BoxDecoration(
        color: isPaid
            ? _softMintColor
            : isOverdue
            ? const Color(0xFFFFF7ED)
            : _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid
              ? const Color(0xFFB7DDD6)
              : isOverdue
              ? const Color(0xFFFED7AA)
              : _surfaceBorderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            final leading = DecoratedBox(
              decoration: BoxDecoration(
                color: isPaid
                    ? _primaryColor
                    : isOverdue
                    ? const Color(0xFFFFEDD5)
                    : _softSlateColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 34,
                height: 34,
                child: Center(
                  child: Text(
                    installment.installmentNumber.toString(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isPaid
                          ? _surfaceColor
                          : isOverdue
                          ? const Color(0xFFEA580C)
                          : _primaryColor,
                      fontWeight: FontWeight.w900,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            );
            final detail = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'งวดที่ ${installment.installmentNumber}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  'ครบกำหนด ${_formatDate(installment.dueDate)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
            final amount = Column(
              crossAxisAlignment: compact
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  'ค่างวด',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatSalePrice(installment.dueAmount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: compact ? TextAlign.left : TextAlign.right,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF334155),
                    fontWeight: FontWeight.w900,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (!isPaid) ...[
                  const SizedBox(height: 2),
                  Text(
                    'คงเหลือ ${_formatSalePrice(installment.outstandingAmount)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: compact ? TextAlign.left : TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ],
            );
            final action = isPaid
                ? const SizedBox.shrink()
                : FilledButton.icon(
                    key: ValueKey(
                      'sale-installment-pay-${installment.installmentNumber}',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: _surfaceColor,
                      minimumSize: const Size.fromHeight(38),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: recordingPayment
                        ? null
                        : () => onRecordPayment(installment),
                    icon: const Icon(SolarIconsOutline.card, size: 18),
                    label: const Text('บันทึกรับชำระงวดนี้'),
                  );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      leading,
                      const SizedBox(width: 10),
                      Expanded(child: detail),
                    ],
                  ),
                  const SizedBox(height: 8),
                  amount,
                  if (!isPaid) ...[const SizedBox(height: 9), action],
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading,
                    const SizedBox(width: 10),
                    Expanded(child: detail),
                    const SizedBox(width: 10),
                    SizedBox(width: 122, child: amount),
                  ],
                ),
                if (!isPaid) ...[const SizedBox(height: 9), action],
              ],
            );
          },
        ),
      ),
    );
  }
}
