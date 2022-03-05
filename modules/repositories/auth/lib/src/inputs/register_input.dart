import 'package:auth/src/inputs/login_input.dart';

class RegisterInput extends LoginInput {
  const RegisterInput({
    required String username,
    required String password,
  }) : super(
          username: username,
          password: password,
        );
}
