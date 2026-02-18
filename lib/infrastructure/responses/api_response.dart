class ApiResponse<T> {
  final String? error;
  final T? data;
  final String? message;

  ApiResponse._({
    this.error,
    this.data,
    this.message,
  });

  factory ApiResponse(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? parseJsonData,
  }) {
    if (json.isEmpty) throw Exception('Empty JSON');

    return ApiResponse._(
      data: json['data'] != null && parseJsonData != null ? parseJsonData(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}
