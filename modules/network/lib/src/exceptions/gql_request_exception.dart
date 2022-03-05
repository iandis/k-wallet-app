class GQLRequestException implements Exception {
  GQLRequestException({
    required this.message,
    this.code,
  });

  final String message;

  final String? code;

  @override
  String toString() {
    if (message.isEmpty) {
      return '[${code ?? 'GQL_REQ_EXCEPTION'}] GQL Request Exception';
    }
    return message;
  }
}
