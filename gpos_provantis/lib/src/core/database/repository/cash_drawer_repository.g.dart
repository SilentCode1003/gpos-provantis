// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drawer_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashDrawerRepository)
final cashDrawerRepositoryProvider = CashDrawerRepositoryProvider._();

final class CashDrawerRepositoryProvider
    extends
        $FunctionalProvider<
          CashDrawerRepository,
          CashDrawerRepository,
          CashDrawerRepository
        >
    with $Provider<CashDrawerRepository> {
  CashDrawerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDrawerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDrawerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CashDrawerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CashDrawerRepository create(Ref ref) {
    return cashDrawerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDrawerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDrawerRepository>(value),
    );
  }
}

String _$cashDrawerRepositoryHash() =>
    r'f7406792ca005ff259d16f540f1628481887842c';
