// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shiftReportRepository)
final shiftReportRepositoryProvider = ShiftReportRepositoryProvider._();

final class ShiftReportRepositoryProvider
    extends
        $FunctionalProvider<
          ShiftReportRepository,
          ShiftReportRepository,
          ShiftReportRepository
        >
    with $Provider<ShiftReportRepository> {
  ShiftReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shiftReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shiftReportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShiftReportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShiftReportRepository create(Ref ref) {
    return shiftReportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShiftReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShiftReportRepository>(value),
    );
  }
}

String _$shiftReportRepositoryHash() =>
    r'98ebc3dcc4ac3e7ebc01ae8b24f6ed6c89f723ca';
