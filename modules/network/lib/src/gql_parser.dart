import 'dart:developer';

import 'package:meta/meta.dart';

import 'gql_type.dart';

abstract class GQLParser<T> {
  const GQLParser();

  String get document;
  GQLType get type;

  bool get alwaysFetch => false;

  @alwaysThrows
  Never onError(Exception exception) {
    log(
      'Unhandled exception.',
      name: runtimeType.toString(),
      error: exception,
    );
    throw exception;
  }

  T parse(Map<String, dynamic> json);
}
