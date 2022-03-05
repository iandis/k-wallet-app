import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'exceptions/_exceptions.dart';
import 'gql_client.dart';
import 'gql_parser.dart';
import 'gql_type.dart';

abstract class GQLExecutor<T> {
  GQLExecutor({
    required GQLClient client,
    required GQLParser<T> parser,
  })  : _client = client,
        _parser = parser;

  final GQLClient _client;
  final GQLParser<T> _parser;

  FetchPolicy get _fetchPolicy => _parser.alwaysFetch
      ? FetchPolicy.networkOnly
      : FetchPolicy.cacheAndNetwork;

  http.Client? _httpClient;

  @nonVirtual
  Future<T> execute(
    Map<String, dynamic> variables, {
    bool withNewHttpClient = false,
  }) async {
    final QueryResult result;

    close();
    _httpClient = withNewHttpClient ? http.Client() : null;

    if (_parser.type == GQLType.query) {
      final QueryOptions queryOptions = QueryOptions(
        document: gql(_parser.document),
        variables: variables,
        fetchPolicy: _fetchPolicy,
      );

      result = await _client.query(
        queryOptions,
        httpClient: _httpClient,
      );
    } else {
      final MutationOptions mutationOptions = MutationOptions(
        document: gql(_parser.document),
        variables: variables,
        fetchPolicy: _fetchPolicy,
      );

      result = await _client.mutate(
        mutationOptions,
        httpClient: _httpClient,
      );
    }

    close();

    if (result.hasException) {
      final OperationException operationException = result.exception!;
      _parser.onError(
        _tryConvertException(operationException) ?? operationException,
      );
    }

    return _parser.parse(result.data!);
  }

  /// Calls [execute] without passing any variables.
  @nonVirtual
  Future<T> run({bool withNewHttpClient = false}) {
    return execute(
      const <String, dynamic>{},
      withNewHttpClient: withNewHttpClient,
    );
  }

  void close() {
    _httpClient?.close();
    _httpClient = null;
  }

  // ignore: body_might_complete_normally_nullable
  Exception? _tryConvertException(
    OperationException exception,
  ) {
    if (exception.graphqlErrors.isNotEmpty) {
      final GraphQLError graphQLError = exception.graphqlErrors.first;

      final String? errorCode = graphQLError.extensions?['code'] is String
          ? graphQLError.extensions!['code'] as String
          : null;

      if (errorCode == 'UNAUTHENTICATED') {
        return GQLUnauthenticatedException();
      } else {
        return GQLRequestException(
          message: graphQLError.message,
          code: errorCode,
        );
      }
    }
  }
}
