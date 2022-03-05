import 'package:core/core.dart';
import 'package:meta/meta.dart';

import '../auth_action_type.dart';
import '../auth_repository.dart';

class DoCancelRegister extends Action<void, void> {
  const DoCancelRegister({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @internal
  @override
  void call([void input]) {
    _authRepository.cancel(AuthActionType.register);
  }
}
