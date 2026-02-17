class BaseViewModel<T> {
  String message;
  final T? data;

  BaseViewModel({
    required this.message,
    this.data,
  });
}
