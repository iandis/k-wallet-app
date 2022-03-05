import 'package:core/core.dart';
import 'package:network/network.dart';

import '../auth_repository.dart';
import '../auth_state.dart';

class DoLogout extends Action<void, void> {
  const DoLogout({
    required GQLAuth authTokenManager,
    required AuthRepository authRepository,
  })  : _authTokenManager = authTokenManager,
        _authRepository = authRepository;

  final GQLAuth _authTokenManager;

  final AuthRepository _authRepository;

  @override
  void call([void input]) {
    _authTokenManager.setToken(null);
    _authRepository.setAuthState((_) => const AuthUnauthenticated());
  }
}
