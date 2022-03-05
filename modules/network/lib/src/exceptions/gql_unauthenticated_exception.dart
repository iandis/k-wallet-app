class GQLUnauthenticatedException implements Exception {
  GQLUnauthenticatedException();

  @override
  String toString() {
    return 'User unauthenticated.';
  }
}
