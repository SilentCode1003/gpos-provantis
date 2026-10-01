class PosSettingsDto {
  final String printerName;
  final String printerIp;
  final String productionPrinterIp;
  final String paperSize;
  final bool isBluetooth;
  final bool isEnable;
  final bool isCashDrawer;

  const PosSettingsDto({
    required this.printerName,
    required this.printerIp,
    required this.productionPrinterIp,
    required this.paperSize,
    required this.isBluetooth,
    required this.isEnable,
    required this.isCashDrawer,
  });

  factory PosSettingsDto.fromJson(Map<String, dynamic> json) {
    return PosSettingsDto(
      printerName: json['printername'] as String? ?? '',
      printerIp: json['printerip'] as String? ?? '',
      productionPrinterIp: json['productionprinterip'] as String? ?? '',
      paperSize: json['papersize'] as String? ?? '',
      isBluetooth: _toBool(json['isbluetooth']),
      isEnable: _toBool(json['isenable']),
      isCashDrawer: _toBool(json['iscashdrawer']),
    );
  }

  /// The server may send flags as bool, 0/1 or "true"/"1" strings (common when
  /// the value comes straight from a MySQL tinyint), so they are never cast
  /// directly.
  static bool _toBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final v = value.trim().toLowerCase();
      return v == 'true' || v == '1';
    }
    return false;
  }
}
