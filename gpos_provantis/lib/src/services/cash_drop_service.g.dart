// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drop_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashDropService)
final cashDropServiceProvider = CashDropServiceProvider._();

final class CashDropServiceProvider
    extends
        $FunctionalProvider<CashDropService, CashDropService, CashDropService>
    with $Provider<CashDropService> {
  CashDropServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDropServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDropServiceHash();

  @$internal
  @override
  $ProviderElement<CashDropService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CashDropService create(Ref ref) {
    return cashDropService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDropService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDropService>(value),
    );
  }
}

String _$cashDropServiceHash() => r'cbe7347577d5a75bf2b89b8f7cef6c6363617b01';
