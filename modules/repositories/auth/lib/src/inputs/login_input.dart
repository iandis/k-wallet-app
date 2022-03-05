class LoginInput {
  const LoginInput({
    required this.username,
    required this.password,
  })  : assert(
          username.length >= 5 && username.length <= 15,
          'Username must be between 5 - 15 characters',
        ),
        assert(
          password.length >= 8 && password.length <= 25,
          'Password must be between 8 - 25 characters',
        );

  final String username;

  final String password;

  Map<String, dynamic> get toMap {
    return {
      'username': username,
      'password': password,
    };
  }
}
