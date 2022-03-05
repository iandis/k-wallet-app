import 'package:auth/src/inputs/update_password_input.dart';

class ForgotPasswordInput extends UpdatePasswordInput {
  const ForgotPasswordInput({
    required this.username,
    required String oldPassword,
    required String newPassword,
  })  : assert(
          username.length >= 5 && username.length <= 15,
          'Username must be between 5 - 15 characters',
        ),
        super(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );

  final String username;

  @override
  Map<String, dynamic> get toMap {
    return <String, dynamic>{
      'username': username,
      ...super.toMap,
    };
  }
}
