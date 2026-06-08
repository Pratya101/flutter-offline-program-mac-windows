part of '../../../main.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key, required this.trackingService});

  final TrackingService trackingService;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      SolarIconsOutline.alarm,
                      color: Color(0xFFEA580C),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('ติดตาม', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: DecoratedBox(
                decoration: _surfaceDecoration(),
                child: StreamBuilder<List<OrderTrackingGroup>>(
                  stream: trackingService.watchPendingOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: Text('กำลังโหลดรายการติดตาม...'),
                      );
                    }

                    final items = snapshot.data ?? const [];
                    if (items.isEmpty) {
                      return const Center(child: Text('ไม่มีงวดที่ต้องติดตาม'));
                    }

                    return ClipRRect(
                      borderRadius: _cardBorderRadius(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                ),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    _softSlateColor,
                                  ),
                                  columnSpacing: 28,
                                  dataRowMinHeight: 78,
                                  dataRowMaxHeight: 110,
                                  headingTextStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  columns: const [
                                    DataColumn(label: Text('ลูกค้า')),
                                    DataColumn(label: Text('เลขที่บิล')),
                                    DataColumn(label: Text('งวด')),
                                    DataColumn(
                                      label: Text('จำนวนเงิน/งวด'),
                                      numeric: true,
                                    ),
                                    DataColumn(label: Text('วันครบรอบ')),
                                    DataColumn(label: Text('สถานะ')),
                                  ],
                                  rows: [
                                    for (final item in items)
                                      DataRow(
                                        color: WidgetStateProperty.all(
                                          _trackingRowColor(item),
                                        ),
                                        cells: [
                                          DataCell(Text(item.customerName)),
                                          DataCell(Text(item.saleNumber)),
                                          DataCell(
                                            _TrackingMultilineCell(
                                              primary: _formatInstallments(
                                                item,
                                              ),
                                              secondary:
                                                  '${item.installments.length} งวดค้าง',
                                            ),
                                          ),
                                          DataCell(
                                            _TrackingAmountCell(item: item),
                                          ),
                                          DataCell(
                                            _TrackingMultilineCell(
                                              primary: _formatDate(
                                                item.nearestDueDate,
                                              ),
                                              secondary: 'ใกล้สุด',
                                            ),
                                          ),
                                          DataCell(
                                            _TrackingUrgencyBadge(item: item),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _trackingRowColor(OrderTrackingGroup item) {
  return switch (item.urgency) {
    TrackingUrgency.critical => const Color(0xFFFFF1F2),
    TrackingUrgency.warning => const Color(0xFFFFFBEB),
    TrackingUrgency.normal => _surfaceColor,
  };
}

class _TrackingUrgencyBadge extends StatelessWidget {
  const _TrackingUrgencyBadge({required this.item});

  final OrderTrackingGroup item;

  @override
  Widget build(BuildContext context) {
    final nearestInstallment = item.nearestInstallment;
    final (label, color) = switch (item.urgency) {
      TrackingUrgency.critical => (
        nearestInstallment.isOverdue
            ? 'เลยกำหนด ${nearestInstallment.daysUntilDue.abs()} วัน'
            : 'ใกล้มาก',
        const Color(0xFFDC2626),
      ),
      TrackingUrgency.warning => ('ใกล้ถึงกำหนด', const Color(0xFFD97706)),
      TrackingUrgency.normal => (
        'อีก ${nearestInstallment.daysUntilDue} วัน',
        _primaryColor,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TrackingMultilineCell extends StatelessWidget {
  const _TrackingMultilineCell({
    required this.primary,
    required this.secondary,
    this.alignEnd = false,
  });

  final String primary;
  final String secondary;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          primary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          secondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TrackingAmountCell extends StatelessWidget {
  const _TrackingAmountCell({required this.item});

  final OrderTrackingGroup item;

  @override
  Widget build(BuildContext context) {
    final firstAmount = item.installments.first.outstandingAmount;
    final sameAmount = item.installments.every(
      (installment) => installment.outstandingAmount == firstAmount,
    );
    final primary = sameAmount
        ? '${_formatSalePrice(firstAmount)} บาท'
        : '${_formatSalePrice(item.totalOutstandingAmount)} บาท';
    final secondary = sameAmount
        ? 'รวมค้าง ${_formatSalePrice(item.totalOutstandingAmount)} บาท'
        : 'ยอดรวมทุกงวด';

    return _TrackingMultilineCell(
      primary: primary,
      secondary: secondary,
      alignEnd: true,
    );
  }
}

String _formatInstallments(OrderTrackingGroup item) {
  return '${item.nearestInstallment.installmentNumber}/${item.totalInstallments}';
}
