import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/services/mailer_service.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

part 'send_ereceipt_controller.g.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

const Object _unset = Object();

/// Everything the "Send e-receipt" sheet shows.
class SendEReceiptState {
  const SendEReceiptState({
    this.orNumber = '',
    this.email = '',
    this.showValidation = false,
    this.isSending = false,
    this.lookupError,
  });

  final String orNumber;
  final String email;

  /// True after the cashier tried to submit with a bad field, so errors are
  /// not shown while they are still typing for the first time.
  final bool showValidation;

  final bool isSending;

  /// "No receipt found..." from the last send. Cleared when the OR is edited.
  final String? lookupError;

  String get _or => orNumber.trim();
  String get _email => email.trim();

  bool get isOrValid => _or.isNotEmpty;
  bool get isEmailValid => _emailPattern.hasMatch(_email);

  /// Enables the submit button. Format problems are reported on submit, as
  /// before; this only needs both fields filled in and nothing in flight.
  bool get canSubmit => _or.isNotEmpty && _email.isNotEmpty && !isSending;

  String? get orError {
    if (lookupError != null) return lookupError;
    if (showValidation && !isOrValid) return 'Enter the OR number';
    return null;
  }

  String? get emailError =>
      showValidation && !isEmailValid ? 'Enter a valid email address' : null;

  SendEReceiptState copyWith({
    String? orNumber,
    String? email,
    bool? showValidation,
    bool? isSending,
    Object? lookupError = _unset,
  }) {
    return SendEReceiptState(
      orNumber: orNumber ?? this.orNumber,
      email: email ?? this.email,
      showValidation: showValidation ?? this.showValidation,
      isSending: isSending ?? this.isSending,
      lookupError: identical(lookupError, _unset)
          ? this.lookupError
          : lookupError as String?,
    );
  }
}

/// Drives the send e-receipt sheet: holds the two fields, validates them, and
/// asks [MailerService] to send. The sheet only draws this state.
///
/// [initialOrNumber] pre-fills the OR number (e.g. when opened from a receipt).
@riverpod
class SendEReceiptController extends _$SendEReceiptController {
  @override
  SendEReceiptState build(String initialOrNumber) {
    return SendEReceiptState(orNumber: initialOrNumber);
  }

  void setOrNumber(String value) {
    if (value == state.orNumber) return;
    // A new OR number makes the old "not found" message stale.
    state = state.copyWith(orNumber: value, lookupError: null);
  }

  void setEmail(String value) {
    if (value == state.email) return;
    state = state.copyWith(email: value);
  }

  /// Validates and sends. Returns true only when the email went out, so the
  /// sheet knows to close. On failure the sheet stays open for a retry.
  Future<bool> submit() async {
    if (state.isSending) return false;

    if (!state.isOrValid || !state.isEmailValid) {
      state = state.copyWith(showValidation: true);
      return false;
    }

    final orNumber = state.orNumber.trim();
    final email = state.email.trim();

    // Read before the first await: the toast emitter outlives this controller.
    final toast = ref.read(toastEmitterProvider);
    final mailer = ref.read(mailerServiceProvider);

    state = state.copyWith(isSending: true, lookupError: null);

    try {
      await mailer.sendEReceipt(orNumber: orNumber, recipient: email);
      toast.success('E-receipt for OR# $orNumber sent to $email.');
      if (ref.mounted) state = state.copyWith(isSending: false);
      return true;
    } on ReceiptNotFoundException catch (e) {
      // Shown under the OR field, where the cashier can fix it.
      if (ref.mounted) {
        state = state.copyWith(isSending: false, lookupError: e.message);
      }
      return false;
    } on EReceiptException catch (e) {
      toast.error(e.message);
      if (ref.mounted) state = state.copyWith(isSending: false);
      return false;
    } catch (e, st) {
      debugPrint('SendEReceiptController: unexpected failure: $e\n$st');
      toast.error('Could not send the e-receipt. Please try again.');
      if (ref.mounted) state = state.copyWith(isSending: false);
      return false;
    }
  }
}
