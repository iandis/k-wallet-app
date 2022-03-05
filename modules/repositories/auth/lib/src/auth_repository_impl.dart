part of 'auth_repository.dart';

class _AuthRepositoryImpl implements AuthRepository {
  _AuthRepositoryImpl({
    required LoginRequest loginRequest,
    required RegisterRequest registerRequest,
    required UpdatePasswordRequest updatePasswordRequest,
    required ForgotPasswordRequest forgotPasswordRequest,
  })  : _loginRequest = loginRequest,
        _registerRequest = registerRequest,
        _updatePasswordRequest = updatePasswordRequest,
        _forgotPasswordRequest = forgotPasswordRequest;

  factory _AuthRepositoryImpl.create(GQLClient client) {
    return _AuthRepositoryImpl(
      loginRequest: LoginRequest(client),
      registerRequest: RegisterRequest(client),
      updatePasswordRequest: UpdatePasswordRequest(client),
      forgotPasswordRequest: ForgotPasswordRequest(client),
    );
  }

  final LoginRequest _loginRequest;

  final RegisterRequest _registerRequest;

  final UpdatePasswordRequest _updatePasswordRequest;

  final ForgotPasswordRequest _forgotPasswordRequest;

  final BehaviorSubject<AuthState> _authStateController =
      BehaviorSubject<AuthState>.seeded(const AuthUnauthenticated());

  @override
  void cancel(AuthActionType actionType) {
    switch (actionType) {
      case AuthActionType.login:
        _loginRequest.close();
        break;
      case AuthActionType.register:
        _registerRequest.close();
        break;
      default:
    }
  }

  @override
  Future<bool> submitForgotPassword(ForgotPasswordInput input) {
    return _forgotPasswordRequest.execute(input.toMap);
  }

  @override
  Future<Auth> submitLogin(LoginInput input) {
    return _loginRequest.execute(input.toMap, withNewHttpClient: true);
  }

  @override
  Future<Auth> submitRegister(RegisterInput input) {
    return _registerRequest.execute(input.toMap, withNewHttpClient: true);
  }

  @override
  Future<Auth> submitUpdatePassword(UpdatePasswordInput input) {
    return _updatePasswordRequest.execute(input.toMap);
  }

  @override
  AuthStateSubscription onAuthStateChanges(AuthStateListener listener) {
    return _authStateController.stream.listen(listener);
  }

  @override
  void setAuthState(
    AuthState Function(AuthState currentState) newStateFn,
  ) {
    final AuthState currentState = _authStateController.value;
    final AuthState newState = newStateFn(currentState);
    _authStateController.add(newState);
  }
}
