import 'package:meta/meta.dart';
import 'package:network/network.dart';

@internal
class ForgotPasswordRequest extends GQLExecutor<bool> {
  ForgotPasswordRequest(GQLClient client)
      : super(
          client: client,
          parser: const _ForgotPasswordParser(),
        );
}

class _ForgotPasswordParser extends GQLParser<bool> {
  const _ForgotPasswordParser();

  @override
  String get document => r'''
    mutation forgotPassword(
      $username: String!
      $oldPassword: String!
      $newPassword: String!
    ) {
      userForgotPassword(userForgotPasswordInput: {
        username: $username
        oldPassword: $oldPassword
        newPassword: $newPassword
      })
    }
  ''';

  @override
  GQLType get type => GQLType.mutation;

  @override
  bool parse(Map<String, dynamic> json) {
    final dynamic isSuccess = json['userForgotPassword'];
    return isSuccess is bool && isSuccess;
  }
}
