import 'package:meta/meta.dart';
import 'package:network/network.dart';

import '../entities/auth.dart';

@internal
class LoginRequest extends GQLExecutor<Auth> {
  LoginRequest(GQLClient client)
      : super(
          client: client,
          parser: const _LoginParser(),
        );
}

class _LoginParser extends GQLParser<Auth> {
  const _LoginParser();

  @override
  String get document => r'''
    mutation login($username: String!, $password: String!) {
      login(loginInput: {username: $username, password: $password}) {
        user {
          id
          username
          name
          phone
          email
          image
        }
        token
      }
    }
  ''';

  @override
  GQLType get type => GQLType.mutation;

  @override
  Auth parse(Map<String, dynamic> json) {
    final dynamic auth = json['login'];
    return Auth.fromJson(auth as Map<String, dynamic>);
  }
}
