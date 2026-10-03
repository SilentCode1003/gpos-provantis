// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_report_dao_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shiftReportDao)
final shiftReportDaoProvider = ShiftReportDaoProvider._();

final class ShiftReportDaoProvider
    extends $FunctionalProvider<ShiftReportDao, ShiftReportDao, ShiftReportDao>
    with $Provider<ShiftReportDao> {
  ShiftReportDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shiftReportDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shiftReportDaoHash();

  @$internal
  @override
  $ProviderElement<ShiftReportDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShiftReportDao create(Ref ref) {
    return shiftReportDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShiftReportDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShiftReportDao>(value),
    );
  }
}

String _$shiftReportDaoHash() => r'18de3b686d11ea12d700232580d53a40debb5938';
