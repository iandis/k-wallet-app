import 'dart:async';

import 'package:core/core.dart';

import '../auth_repository.dart';
import '../inputs/forgot_password_input.dart';

class DoForgotPassword extends Action<ForgotPasswordInput, bool> {
  const DoForgotPassword({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<bool> call(ForgotPasswordInput input) {
    return _authRepository.submitForgotPassword(input);
  }
}
