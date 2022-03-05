import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'gql_auth.dart';

abstract class GQLClient {
  factory GQLClient({
    required String baseUrl,
    required GQLAuth auth,
  }) = _GQLClientImpl;

  String get baseUrl;
  GQLAuth get auth;

  Future<QueryResult> query(
    QueryOptions options, {
    http.Client? httpClient,
  });

  Future<QueryResult> mutate(
    MutationOptions options, {
    http.Client? httpClient,
  });
}

class _GQLClientImpl implements GQLClient {
  _GQLClientImpl({
    required this.baseUrl,
    required this.auth,
  }) {
    initClient();
  }

  @override
  final String baseUrl;

  @override
  final GQLAuth auth;

  @protected
  late final GraphQLClient _graphQLClient;

  late final AuthLink _authLink;

  late final GraphQLCache _graphQLCache;

  @protected
  void initClient() {
    _authLink = AuthLink(getToken: auth.getToken);
    final HttpLink httpLink = HttpLink(baseUrl);

    final Link link = _authLink.concat(httpLink);

    _graphQLCache = GraphQLCache();

    _graphQLClient = GraphQLClient(
      link: link,
      cache: _graphQLCache,
    );
  }

  GraphQLClient _createClient(http.Client httpClient) {
    final HttpLink httpLink = HttpLink(
      baseUrl,
      httpClient: httpClient,
    );

    final Link link = _authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: _graphQLCache,
    );
  }

  @override
  Future<QueryResult> mutate(
    MutationOptions options, {
    http.Client? httpClient,
  }) {
    GraphQLClient graphQLClient = _graphQLClient;
    if (httpClient != null) {
      graphQLClient = _createClient(httpClient);
    }
    return graphQLClient.mutate(options);
  }

  @override
  Future<QueryResult> query(
    QueryOptions options, {
    http.Client? httpClient,
  }) {
    GraphQLClient graphQLClient = _graphQLClient;
    if (httpClient != null) {
      graphQLClient = _createClient(httpClient);
    }
    return graphQLClient.query(options);
  }
}
