// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soldItemsRepository)
final soldItemsRepositoryProvider = SoldItemsRepositoryProvider._();

final class SoldItemsRepositoryProvider
    extends
        $FunctionalProvider<
          SoldItemsRepository,
          SoldItemsRepository,
          SoldItemsRepository
        >
    with $Provider<SoldItemsRepository> {
  SoldItemsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldItemsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldItemsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SoldItemsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoldItemsRepository create(Ref ref) {
    return soldItemsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldItemsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldItemsRepository>(value),
    );
  }
}

String _$soldItemsRepositoryHash() =>
    r'68c984b892453c1be271963c6a5ce452b255fd5f';
