import 'dart:async';

abstract class GQLAuth {
  FutureOr<String?> getToken();
  void setToken(String? newToken);
}
