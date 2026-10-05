// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_drop_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cashDropRepository)
final cashDropRepositoryProvider = CashDropRepositoryProvider._();

final class CashDropRepositoryProvider
    extends
        $FunctionalProvider<
          CashDropRepository,
          CashDropRepository,
          CashDropRepository
        >
    with $Provider<CashDropRepository> {
  CashDropRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashDropRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashDropRepositoryHash();

  @$internal
  @override
  $ProviderElement<CashDropRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CashDropRepository create(Ref ref) {
    return cashDropRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashDropRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashDropRepository>(value),
    );
  }
}

String _$cashDropRepositoryHash() =>
    r'20cc1f8a4b807ab1926cdf0a3b92cb7681ddd8a6';
