// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_ereceipt_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the send e-receipt sheet: holds the two fields, validates them, and
/// asks [MailerService] to send. The sheet only draws this state.
///
/// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).

@ProviderFor(SendEReceiptController)
final sendEReceiptControllerProvider = SendEReceiptControllerFamily._();

/// Drives the send e-receipt sheet: holds the two fields, validates them, and
/// asks [MailerService] to send. The sheet only draws this state.
///
/// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).
final class SendEReceiptControllerProvider
    extends $NotifierProvider<SendEReceiptController, SendEReceiptState> {
  /// Drives the send e-receipt sheet: holds the two fields, validates them, and
  /// asks [MailerService] to send. The sheet only draws this state.
  ///
  /// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).
  SendEReceiptControllerProvider._({
    required SendEReceiptControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sendEReceiptControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sendEReceiptControllerHash();

  @override
  String toString() {
    return r'sendEReceiptControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SendEReceiptController create() => SendEReceiptController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendEReceiptState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendEReceiptState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SendEReceiptControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sendEReceiptControllerHash() =>
    r'a820311089e49d0412ebd01712e410bb4a765a69';

/// Drives the send e-receipt sheet: holds the two fields, validates them, and
/// asks [MailerService] to send. The sheet only draws this state.
///
/// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).

final class SendEReceiptControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SendEReceiptController,
          SendEReceiptState,
          SendEReceiptState,
          SendEReceiptState,
          String
        > {
  SendEReceiptControllerFamily._()
    : super(
        retry: null,
        name: r'sendEReceiptControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives the send e-receipt sheet: holds the two fields, validates them, and
  /// asks [MailerService] to send. The sheet only draws this state.
  ///
  /// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).

  SendEReceiptControllerProvider call(String initialOrNumber) =>
      SendEReceiptControllerProvider._(argument: initialOrNumber, from: this);

  @override
  String toString() => r'sendEReceiptControllerProvider';
}

/// Drives the send e-receipt sheet: holds the two fields, validates them, and
/// asks [MailerService] to send. The sheet only draws this state.
///
/// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).

abstract class _$SendEReceiptController extends $Notifier<SendEReceiptState> {
  late final _$args = ref.$arg as String;
  String get initialOrNumber => _$args;

  SendEReceiptState build(String initialOrNumber);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SendEReceiptState, SendEReceiptState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SendEReceiptState, SendEReceiptState>,
              SendEReceiptState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
