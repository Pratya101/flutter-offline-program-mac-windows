part of '../../main.dart';

String _displayText(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return '-';
  }
  return text;
}

String _formatSalePrice(double value) {
  return NumberFormat('#,##0.00', 'th_TH').format(value);
}

double? _parseSalePrice(String value) {
  final normalized = value.trim().replaceAll(',', '');
  if (normalized.isEmpty) {
    return null;
  }
  return double.tryParse(normalized);
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final month = _thaiShortMonths[local.month - 1];
  final buddhistYear = local.year + 543;
  final time =
      '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}:${_twoDigits(local.second)}';
  return '${local.day} $month $buddhistYear $time';
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final month = _thaiShortMonths[local.month - 1];
  final buddhistYear = local.year + 543;
  return '${local.day} $month $buddhistYear';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

const _thaiShortMonths = [
  'ม.ค.',
  'ก.พ.',
  'มี.ค.',
  'เม.ย.',
  'พ.ค.',
  'มิ.ย.',
  'ก.ค.',
  'ส.ค.',
  'ก.ย.',
  'ต.ค.',
  'พ.ย.',
  'ธ.ค.',
];
