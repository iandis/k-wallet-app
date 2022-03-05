import 'package:core/core.dart';
import 'package:meta/meta.dart';

import '../auth_action_type.dart';
import '../auth_repository.dart';

class DoCancelLogin extends Action<void, void> {
  const DoCancelLogin({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @internal
  @override
  void call([void input]) {
    _authRepository.cancel(AuthActionType.login);
  }
}
