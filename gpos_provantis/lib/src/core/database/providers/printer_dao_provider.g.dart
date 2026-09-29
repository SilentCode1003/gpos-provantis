// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(printerDao)
final printerDaoProvider = PrinterDaoProvider._();

final class PrinterDaoProvider
    extends $FunctionalProvider<PrinterDao, PrinterDao, PrinterDao>
    with $Provider<PrinterDao> {
  PrinterDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printerDaoHash();

  @$internal
  @override
  $ProviderElement<PrinterDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrinterDao create(Ref ref) {
    return printerDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrinterDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrinterDao>(value),
    );
  }
}

String _$printerDaoHash() => r'4eb703c93173bdee6fa62c20eb76abdb050eda06';
