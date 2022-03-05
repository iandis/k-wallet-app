import 'package:meta/meta.dart';
import 'package:network/network.dart';

import '../entities/auth.dart';

@internal
class RegisterRequest extends GQLExecutor<Auth> {
  RegisterRequest(GQLClient client)
      : super(
          client: client,
          parser: const _RegisterParser(),
        );
}

class _RegisterParser extends GQLParser<Auth> {
  const _RegisterParser();

  @override
  String get document => r'''
    mutation register($username: String!, $password: String!) {
      register(registerInput: {username: $username, password: $password}) {
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
    final dynamic auth = json['register'];
    return Auth.fromJson(auth as Map<String, dynamic>);
  }
}
