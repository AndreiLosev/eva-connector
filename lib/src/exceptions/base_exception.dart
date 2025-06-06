class BaseException {
  final String message;

  BaseException([this.message = '']);

  @override
  String toString() {
    return "${runtimeType.toString()}: $message";
  }
}
