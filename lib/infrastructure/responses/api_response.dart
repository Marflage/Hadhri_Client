class ApiResponse<T> {
  ApiResponse._({
    this.error,
    this.data,
    this.message,
  });

  final String? error;
  final T? data;
  final String? message;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? parseJsonData,
  }) {
    if (json.isEmpty) throw Exception('Empty JSON');

    return ApiResponse._(
      data: parseJsonData != null ? parseJsonData(json) : json['data'],
      message: json['message'],
      error: json['error'],
    );
  }
}
