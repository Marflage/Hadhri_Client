class ApiResponse {
  final String? error;
  final String? data;
  final String? message;

  ApiResponse._({
    this.error,
    this.data,
    this.message,
  });

  factory ApiResponse(Map<String, dynamic> json) {
    if (json.isEmpty) throw Exception('Empty JSON');

    return ApiResponse._(data: json['data'], message: json['message'], error: json['error']);
  }
}
