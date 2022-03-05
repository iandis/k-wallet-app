import 'dart:async';

import 'package:auth/src/actions/do_cancel_register.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';
import 'package:network/network.dart';

import '../auth_repository.dart';
import '../auth_state.dart';
import '../entities/auth.dart';
import '../exceptions/auth_exception.dart';
import '../inputs/register_input.dart';

class DoRegister extends Action<RegisterInput, Auth> {
  const DoRegister({
    required GQLAuth authTokenManager,
    required AuthRepository authRepository,
    required DoCancelRegister doCancelRegister,
  })  : _authTokenManager = authTokenManager,
        _authRepository = authRepository,
        _doCancelRegister = doCancelRegister;

  final GQLAuth _authTokenManager;

  final AuthRepository _authRepository;

  final DoCancelRegister _doCancelRegister;

  static const Duration _maxRegisterTimelimit = Duration(minutes: 1);

  @override
  Future<Auth> call(RegisterInput input) async {
    try {
      final Auth result = await _authRepository
          .submitRegister(input)
          .timeout(_maxRegisterTimelimit, onTimeout: _onRegisterTimeout);

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
  Never _onRegisterTimeout() {
    _doCancelRegister();
    throw TimeoutException('Register request timeout', _maxRegisterTimelimit);
  }
}
