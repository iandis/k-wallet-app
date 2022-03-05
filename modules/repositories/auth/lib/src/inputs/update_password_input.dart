class UpdatePasswordInput {
  const UpdatePasswordInput({
    required this.oldPassword,
    required this.newPassword,
  }) : assert(
          oldPassword.length >= 8 &&
              oldPassword.length <= 25 &&
              newPassword.length >= 8 &&
              newPassword.length <= 25,
          'Password must be between 8 - 25 characters',
        );

  final String oldPassword;

  final String newPassword;

  Map<String, dynamic> get toMap {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}
