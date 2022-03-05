import 'package:core/core.dart';

import '../auth_repository.dart';

class DoListenAuthState
    extends Action<AuthStateListener, AuthStateSubscription> {
  const DoListenAuthState({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  AuthStateSubscription call(AuthStateListener input) {
    return _authRepository.onAuthStateChanges(input);
  }
}
