class Result<T> {
  final String? title;
  final String? message;
  final T? data;
  final String? responseCode;
  final bool hasError;

  Result({
    this.title,
    this.message,
    this.data,
    this.responseCode,
    this.hasError = false,
  });
}
