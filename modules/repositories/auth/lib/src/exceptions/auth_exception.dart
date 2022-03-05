class AuthException implements Exception {
  AuthException([this.message = '']);

  final String message;

  @override
  String toString() {
    if (message.isNotEmpty) {
      return message;
    }
    return 'Auth Exception';
  }
}
