// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(initialSyncService)
final initialSyncServiceProvider = InitialSyncServiceProvider._();

final class InitialSyncServiceProvider
    extends
        $FunctionalProvider<
          InitialSyncService,
          InitialSyncService,
          InitialSyncService
        >
    with $Provider<InitialSyncService> {
  InitialSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialSyncServiceHash();

  @$internal
  @override
  $ProviderElement<InitialSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InitialSyncService create(Ref ref) {
    return initialSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitialSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitialSyncService>(value),
    );
  }
}

String _$initialSyncServiceHash() =>
    r'5fea118785aefcef2a63ed03f7f1d7b58a338902';
