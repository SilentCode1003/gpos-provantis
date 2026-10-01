// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posSettingsRepository)
final posSettingsRepositoryProvider = PosSettingsRepositoryProvider._();

final class PosSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          PosSettingsRepository,
          PosSettingsRepository,
          PosSettingsRepository
        >
    with $Provider<PosSettingsRepository> {
  PosSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PosSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PosSettingsRepository create(Ref ref) {
    return posSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosSettingsRepository>(value),
    );
  }
}

String _$posSettingsRepositoryHash() =>
    r'308efed4d95f5a7f1e903919c50f415d01703fa3';
