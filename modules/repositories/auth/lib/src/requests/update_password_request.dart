import 'package:meta/meta.dart';
import 'package:network/network.dart';

import '../entities/auth.dart';

@internal
class UpdatePasswordRequest extends GQLExecutor<Auth> {
  UpdatePasswordRequest(GQLClient client)
      : super(
          client: client,
          parser: const _UpdatePasswordParser(),
        );
}

class _UpdatePasswordParser extends GQLParser<Auth> {
  const _UpdatePasswordParser();

  @override
  String get document => r'''
    mutation updatePassword(
      $oldPassword: String!
      $newPassword: String!
    ) {
      userUpdatePassword(userUpdatePasswordInput: {
        oldPassword: $oldPassword
        newPassword: $newPassword
      }) {
        token
      }
    }
  ''';

  @override
  GQLType get type => GQLType.mutation;

  @override
  Auth parse(Map<String, dynamic> json) {
    final dynamic auth = json['userUpdatePassword'];
    return Auth.fromJson(auth as Map<String, dynamic>);
  }
}
