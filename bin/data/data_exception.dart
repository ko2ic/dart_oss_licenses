/// Exception to use in case of data error.
class DataException implements Exception {
  final String message;

  DataException(this.message);

  @override
  String toString() {
    return "DataException: ${this.message}";
  }
}
