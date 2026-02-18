class BaseViewModel<T> {
  String message;
  T? data;

  BaseViewModel({
    required this.message,
    this.data,
  });
}
