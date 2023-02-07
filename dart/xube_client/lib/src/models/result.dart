class Result<T> {
  final String? title;
  final String? message;
  final T? data;
  final bool hasError;

  Result({
    this.title,
    this.message,
    this.data,
    this.hasError = false,
  });
}
