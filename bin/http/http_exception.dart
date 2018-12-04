/// Exception of Http.
class HttpException implements Exception {
  int status;
  String message;

  HttpException(int this.status, [String this.message]);

  String toString() {
    String stringRepresentation = "$status";
    if (message != null) {
      stringRepresentation += ": $message";
    }
    return stringRepresentation;
  }
}
