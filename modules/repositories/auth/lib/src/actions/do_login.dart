import 'dart:async';

import 'package:auth/src/actions/do_cancel_login.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';
import 'package:network/network.dart';

import '../auth_repository.dart';
import '../auth_state.dart';
import '../entities/auth.dart';
import '../exceptions/auth_exception.dart';
import '../inputs/login_input.dart';

class DoLogin extends Action<LoginInput, Auth> {
  const DoLogin({
    required GQLAuth authTokenManager,
    required AuthRepository authRepository,
    required DoCancelLogin doCancelLogin,
  })  : _authTokenManager = authTokenManager,
        _authRepository = authRepository,
        _doCancelLogin = doCancelLogin;

  final GQLAuth _authTokenManager;

  final AuthRepository _authRepository;

  final DoCancelLogin _doCancelLogin;

  static const Duration _maxLoginTimelimit = Duration(seconds: 30);

  @override
  Future<Auth> call(LoginInput input) async {
    try {
      final Auth result = await _authRepository
          .submitLogin(input)
          .timeout(_maxLoginTimelimit, onTimeout: _onLoginTimeout);

      final String token = result.token != null
          ? result.token!
          : throw AuthException('Bad token credential');

      _authTokenManager.setToken(token);
      _authRepository.setAuthState((_) => AuthAuthenticated(result));
      return result;
    } catch (_) {
      rethrow;
    }
  }

  @alwaysThrows
  Never _onLoginTimeout() {
    _doCancelLogin();
    throw TimeoutException('Login request timeout', _maxLoginTimelimit);
  }
}
