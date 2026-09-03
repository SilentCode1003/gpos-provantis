// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denominations_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(denominationsRepository)
final denominationsRepositoryProvider = DenominationsRepositoryProvider._();

final class DenominationsRepositoryProvider
    extends
        $FunctionalProvider<
          DenominationsRepository,
          DenominationsRepository,
          DenominationsRepository
        >
    with $Provider<DenominationsRepository> {
  DenominationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'denominationsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$denominationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DenominationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DenominationsRepository create(Ref ref) {
    return denominationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DenominationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DenominationsRepository>(value),
    );
  }
}

String _$denominationsRepositoryHash() =>
    r'732c837f1ada41e1840d921ead349b15a6618099';
