// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discounts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discountsRepository)
final discountsRepositoryProvider = DiscountsRepositoryProvider._();

final class DiscountsRepositoryProvider
    extends
        $FunctionalProvider<
          DiscountsRepository,
          DiscountsRepository,
          DiscountsRepository
        >
    with $Provider<DiscountsRepository> {
  DiscountsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiscountsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiscountsRepository create(Ref ref) {
    return discountsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscountsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscountsRepository>(value),
    );
  }
}

String _$discountsRepositoryHash() =>
    r'a82d9cf2ee26c4213c23b0eb9c71fb7e9d434475';
