// Location: src/features/auth/controllers/login_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

/// =========================================================================
/// LOGIN CONTROLLER — design-first stub.
///
/// This intentionally does the bare minimum right now: hold form field
/// values, a submitting flag, and an error message, with a hardcoded
/// admin/admin check standing in for real auth. When real logic lands,
/// only `submit()` needs to change — the screen already reads/writes
/// through this controller, so the UI itself shouldn't need edits.
/// =========================================================================

class LoginState {
  const LoginState({
    this.username = '',
    this.password = '',
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String username;
  final String password;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? errorMessage;

  LoginState copyWith({
    String? username,
    String? password,
    bool? obscurePassword,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginState build() => const LoginState();

  void usernameChanged(String value) {
    state = state.copyWith(username: value, clearError: true);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value, clearError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// TODO(real-auth): replace the hardcoded check with an actual API/auth
  /// call once backend/logic work starts. Returns true on success so the
  /// screen knows whether to navigate.
  Future<bool> submit() async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final ok = state.username == 'admin' && state.password == 'admin';

    if (!ok) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Invalid username or password',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: false);
    return true;
  }
}
