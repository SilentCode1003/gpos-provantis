import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/repository/login_repository.dart';
import 'package:gpos_provantis/src/services/sync/catalog_sync.dart';
import 'package:gpos_provantis/src/services/sync/controller/catalog_sync_controller.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';

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

  bool _isOffline(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout;

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

    final repo = ref.read(userDataRepositoryProvider);

    try {
      await repo.fetchAndSaveUser(username, password);
      state = state.copyWith(isSubmitting: false);

      try {
        await ref
            .read(catalogSyncControllerProvider.notifier)
            .runSync(ref.read(catalogSyncServiceProvider));
      } catch (e) {
        state = state.copyWith(isSubmitting: false);
        throw ('Failed to sync catalog: $e');
      }

      return true;
    } on DioException catch (e) {
      if (_isOffline(e)) {
        // No connection: fall back to the login saved on this device.
        final ok = await repo.verifyOffline(username, password);
        state = state.copyWith(
          isSubmitting: false,
          clearError: ok,
          errorMessage: ok
              ? null
              : 'You are offline, and these details do not match '
                    'the login saved on this device.',
        );
        return ok;
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Invalid username or password.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Invalid username or password.',
      );
      return false;
    }
  }
}
