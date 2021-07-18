class HttpException implements Exception {
  final String message;
  HttpException({required this.message});

  String toString() {
    return message;
  }
}
