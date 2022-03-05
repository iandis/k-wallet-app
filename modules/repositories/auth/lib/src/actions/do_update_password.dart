import 'package:core/core.dart';
import 'package:network/network.dart';

import '../auth_repository.dart';
import '../auth_state.dart';
import '../entities/auth.dart';
import '../exceptions/auth_exception.dart';
import '../inputs/update_password_input.dart';

class DoUpdatePassword extends Action<UpdatePasswordInput, Auth> {
  const DoUpdatePassword({
    required GQLAuth authTokenManager,
    required AuthRepository authRepository,
  })  : _authTokenManager = authTokenManager,
        _authRepository = authRepository;

  final GQLAuth _authTokenManager;

  final AuthRepository _authRepository;

  @override
  Future<Auth> call(UpdatePasswordInput input) async {
    try {
      final Auth result = await _authRepository.submitUpdatePassword(input);

      final String token = result.token != null
          ? result.token!
          : throw AuthException('Bad token credential');

      _authTokenManager.setToken(token);
      _authRepository.setAuthState((AuthState oldState) {
        final AuthAuthenticated currentState = oldState as AuthAuthenticated;
        final AuthAuthenticated newState = AuthAuthenticated(
          currentState.data.copyWith(token: token),
        );
        return newState;
      });
      return result;
    } catch (exception) {
      if (exception is GQLUnauthenticatedException) {
        _authRepository.setAuthState((_) => const AuthUnauthenticated());
      }
      rethrow;
    }
  }
}
