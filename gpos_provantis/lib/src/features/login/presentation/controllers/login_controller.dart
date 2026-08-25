// Location: src/features/auth/controllers/login_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/repository/login_repository.dart';

part 'login_controller.g.dart';

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

  Future<bool> submit() async {
    final username = state.username.trim();
    final password = state.password.trim();

    if (username.isEmpty || password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Username and password are required.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      await ref
          .read(userDataRepositoryProvider)
          .fetchAndSaveUser(username, password);
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Invalid username or password.',
      );
      return false;
    }
  }
}
