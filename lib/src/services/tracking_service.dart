import '../database/app_database.dart';

enum TrackingUrgency { critical, warning, normal }

class InstallmentTrackingItem {
  const InstallmentTrackingItem({
    required this.saleId,
    required this.saleNumber,
    required this.customerId,
    required this.customerName,
    required this.installmentId,
    required this.installmentNumber,
    required this.dueAmount,
    required this.paidAmount,
    required this.dueDate,
  });

  final String saleId;
  final String saleNumber;
  final String customerId;
  final String customerName;
  final String installmentId;
  final int installmentNumber;
  final double dueAmount;
  final double paidAmount;
  final DateTime dueDate;

  double get outstandingAmount {
    final outstanding = dueAmount - paidAmount;
    return _roundMoney(outstanding < 0 ? 0 : outstanding);
  }

  int get daysUntilDue {
    return _dateOnly(dueDate).difference(_dateOnly(DateTime.now())).inDays;
  }

  bool get isOverdue => daysUntilDue < 0;

  TrackingUrgency get urgency {
    if (daysUntilDue <= 3) {
      return TrackingUrgency.critical;
    }
    if (daysUntilDue <= 7) {
      return TrackingUrgency.warning;
    }
    return TrackingUrgency.normal;
  }
}

class OrderTrackingGroup {
  const OrderTrackingGroup({
    required this.saleId,
    required this.saleNumber,
    required this.customerId,
    required this.customerName,
    required this.installments,
  });

  final String saleId;
  final String saleNumber;
  final String customerId;
  final String customerName;
  final List<InstallmentTrackingItem> installments;

  InstallmentTrackingItem get nearestInstallment => installments.first;

  DateTime get nearestDueDate => nearestInstallment.dueDate;

  double get totalOutstandingAmount {
    return _roundMoney(
      installments.fold<double>(
        0,
        (sum, installment) => sum + installment.outstandingAmount,
      ),
    );
  }

  TrackingUrgency get urgency {
    if (installments.any((item) => item.urgency == TrackingUrgency.critical)) {
      return TrackingUrgency.critical;
    }
    if (installments.any((item) => item.urgency == TrackingUrgency.warning)) {
      return TrackingUrgency.warning;
    }
    return TrackingUrgency.normal;
  }
}

class TrackingService {
  const TrackingService(this._database);

  final AppDatabase _database;

  Stream<List<InstallmentTrackingItem>> watchPendingInstallments() {
    return _database
        .customSelect(
          '''
SELECT
  s.id AS sale_id,
  s.sale_number AS sale_number,
  s.customer_id AS customer_id,
  s.customer_name AS customer_name,
  si.id AS installment_id,
  si.installment_number AS installment_number,
  si.due_amount AS due_amount,
  si.paid_amount AS paid_amount,
  si.due_date AS due_date
FROM sale_installments si
JOIN sales s ON s.id = si.sale_id
WHERE COALESCE(s.is_deleted, 0) = 0
  AND (si.due_amount - COALESCE(si.paid_amount, 0)) > 0
ORDER BY si.due_date ASC, s.sale_number ASC, si.installment_number ASC;
''',
          readsFrom: {_database.sales, _database.saleInstallments},
        )
        .watch()
        .map((rows) {
          return rows.map((row) {
            final dueDateSeconds = row.read<int>('due_date');
            return InstallmentTrackingItem(
              saleId: row.read<String>('sale_id'),
              saleNumber: row.read<String>('sale_number'),
              customerId: row.read<String>('customer_id'),
              customerName: row.read<String>('customer_name'),
              installmentId: row.read<String>('installment_id'),
              installmentNumber: row.read<int>('installment_number'),
              dueAmount: row.read<double>('due_amount'),
              paidAmount: row.read<double>('paid_amount'),
              dueDate: DateTime.fromMillisecondsSinceEpoch(
                dueDateSeconds * 1000,
              ),
            );
          }).toList();
        });
  }

  Stream<List<OrderTrackingGroup>> watchPendingOrders() {
    return watchPendingInstallments().map((items) {
      final groups = <String, List<InstallmentTrackingItem>>{};
      for (final item in items) {
        groups.putIfAbsent(item.saleId, () => []).add(item);
      }

      final orderGroups = <OrderTrackingGroup>[];
      for (final installments in groups.values) {
        installments.sort((a, b) {
          final dueDateCompare = a.dueDate.compareTo(b.dueDate);
          if (dueDateCompare != 0) {
            return dueDateCompare;
          }
          return a.installmentNumber.compareTo(b.installmentNumber);
        });
        final first = installments.first;
        orderGroups.add(
          OrderTrackingGroup(
            saleId: first.saleId,
            saleNumber: first.saleNumber,
            customerId: first.customerId,
            customerName: first.customerName,
            installments: List.unmodifiable(installments),
          ),
        );
      }

      orderGroups.sort((a, b) {
        final dueDateCompare = a.nearestDueDate.compareTo(b.nearestDueDate);
        if (dueDateCompare != 0) {
          return dueDateCompare;
        }
        return a.saleNumber.compareTo(b.saleNumber);
      });
      return orderGroups;
    });
  }
}

DateTime _dateOnly(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

double _roundMoney(double value) {
  return (value * 100).roundToDouble() / 100;
}
