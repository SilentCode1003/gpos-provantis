// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoriesDao)
final categoriesDaoProvider = CategoriesDaoProvider._();

final class CategoriesDaoProvider
    extends $FunctionalProvider<CategoriesDao, CategoriesDao, CategoriesDao>
    with $Provider<CategoriesDao> {
  CategoriesDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesDaoHash();

  @$internal
  @override
  $ProviderElement<CategoriesDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoriesDao create(Ref ref) {
    return categoriesDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoriesDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoriesDao>(value),
    );
  }
}

String _$categoriesDaoHash() => r'080351582e97b4c6f2f67f4ca6b6650fba679371';
