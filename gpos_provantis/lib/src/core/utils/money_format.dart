/// Formats an amount in Philippine pesos, e.g. 1250 -> ₱1,250.00,
/// -50 -> -₱50.00. No external packages needed.
String formatPeso(double value) {
  final fixed = value.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  // Avoid showing "-₱0.00" for tiny negative values that round to zero.
  final sign = value < 0 && fixed != '0.00' ? '-' : '';
  return '$sign₱$whole.${parts[1]}';
}
