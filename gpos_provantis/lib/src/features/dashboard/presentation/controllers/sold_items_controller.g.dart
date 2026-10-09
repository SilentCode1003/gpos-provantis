// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_items_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the Sold Items screen.
///
/// Flow when the user taps Apply:
///   1. [applyQuery] sets the query and asks the server for it.
///   2. The repository saves the response to the local DB.
///   3. The screen watches [soldItemsListProvider], which reads ONLY from the
///      local DB, so it updates automatically after the save.
///
/// If the server can't be reached, step 1-2 are skipped and the screen simply
/// shows whatever was saved earlier for that same query.

@ProviderFor(SoldItemsController)
final soldItemsControllerProvider = SoldItemsControllerProvider._();

/// Drives the Sold Items screen.
///
/// Flow when the user taps Apply:
///   1. [applyQuery] sets the query and asks the server for it.
///   2. The repository saves the response to the local DB.
///   3. The screen watches [soldItemsListProvider], which reads ONLY from the
///      local DB, so it updates automatically after the save.
///
/// If the server can't be reached, step 1-2 are skipped and the screen simply
/// shows whatever was saved earlier for that same query.
final class SoldItemsControllerProvider
    extends $NotifierProvider<SoldItemsController, SoldItemsState> {
  /// Drives the Sold Items screen.
  ///
  /// Flow when the user taps Apply:
  ///   1. [applyQuery] sets the query and asks the server for it.
  ///   2. The repository saves the response to the local DB.
  ///   3. The screen watches [soldItemsListProvider], which reads ONLY from the
  ///      local DB, so it updates automatically after the save.
  ///
  /// If the server can't be reached, step 1-2 are skipped and the screen simply
  /// shows whatever was saved earlier for that same query.
  SoldItemsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soldItemsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soldItemsControllerHash();

  @$internal
  @override
  SoldItemsController create() => SoldItemsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoldItemsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoldItemsState>(value),
    );
  }
}

String _$soldItemsControllerHash() =>
    r'9aa82a846f23572580504359d665fe3b887c154b';

/// Drives the Sold Items screen.
///
/// Flow when the user taps Apply:
///   1. [applyQuery] sets the query and asks the server for it.
///   2. The repository saves the response to the local DB.
///   3. The screen watches [soldItemsListProvider], which reads ONLY from the
///      local DB, so it updates automatically after the save.
///
/// If the server can't be reached, step 1-2 are skipped and the screen simply
/// shows whatever was saved earlier for that same query.

abstract class _$SoldItemsController extends $Notifier<SoldItemsState> {
  SoldItemsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SoldItemsState, SoldItemsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SoldItemsState, SoldItemsState>,
              SoldItemsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
