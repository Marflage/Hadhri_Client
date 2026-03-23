class BaseViewState<T> {
  BaseViewState({
    this.message,
    this.data,
    this.error,
  });

  String? message;
  T? data;
  String? error;
}
