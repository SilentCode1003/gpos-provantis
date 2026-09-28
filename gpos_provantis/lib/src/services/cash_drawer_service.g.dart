// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drawer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashDrawerService)
final cashDrawerServiceProvider = CashDrawerServiceProvider._();

final class CashDrawerServiceProvider
    extends
        $FunctionalProvider<
          CashDrawerService,
          CashDrawerService,
          CashDrawerService
        >
    with $Provider<CashDrawerService> {
  CashDrawerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDrawerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDrawerServiceHash();

  @$internal
  @override
  $ProviderElement<CashDrawerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CashDrawerService create(Ref ref) {
    return cashDrawerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDrawerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDrawerService>(value),
    );
  }
}

String _$cashDrawerServiceHash() => r'2cbc01f667f93395e18eb991dec30022f67bf17e';
