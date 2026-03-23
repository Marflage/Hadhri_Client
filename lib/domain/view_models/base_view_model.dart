class BaseViewModel<T> {
  BaseViewModel({
    this.message,
    this.data,
    this.error,
  });

  String? message;
  T? data;
  String? error;
}
