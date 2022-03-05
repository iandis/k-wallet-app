import 'dart:async';

import 'package:meta/meta.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

import 'auth_action_type.dart';
import 'auth_state.dart';
import 'entities/auth.dart';
import 'inputs/_inputs.dart';

import 'requests/forgot_password_request.dart';
import 'requests/login_request.dart';
import 'requests/register_request.dart';
import 'requests/update_password_request.dart';

part 'auth_repository_impl.dart';

typedef AuthStateListener = void Function(AuthState state);
typedef AuthStateSubscription = StreamSubscription<AuthState>;

abstract class AuthRepository {
  @internal
  factory AuthRepository({
    required LoginRequest loginRequest,
    required RegisterRequest registerRequest,
    required UpdatePasswordRequest updatePasswordRequest,
    required ForgotPasswordRequest forgotPasswordRequest,
  }) = _AuthRepositoryImpl;

  factory AuthRepository.create(GQLClient client) = _AuthRepositoryImpl.create;

  Future<Auth> submitLogin(LoginInput input);

  Future<Auth> submitRegister(RegisterInput input);

  Future<bool> submitForgotPassword(ForgotPasswordInput input);

  Future<Auth> submitUpdatePassword(UpdatePasswordInput input);

  AuthStateSubscription onAuthStateChanges(AuthStateListener listener);

  @internal
  void setAuthState(AuthState Function(AuthState currentState) newStateFn);

  @internal
  void cancel(AuthActionType actionType);
}
