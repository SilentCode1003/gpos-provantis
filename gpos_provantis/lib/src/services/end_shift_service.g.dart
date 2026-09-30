// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_shift_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(endShiftService)
final endShiftServiceProvider = EndShiftServiceProvider._();

final class EndShiftServiceProvider
    extends
        $FunctionalProvider<EndShiftService, EndShiftService, EndShiftService>
    with $Provider<EndShiftService> {
  EndShiftServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endShiftServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endShiftServiceHash();

  @$internal
  @override
  $ProviderElement<EndShiftService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EndShiftService create(Ref ref) {
    return endShiftService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EndShiftService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EndShiftService>(value),
    );
  }
}

String _$endShiftServiceHash() => r'6f82238fdfa0bf43c71b1b92c343f3cd4b171c4e';
