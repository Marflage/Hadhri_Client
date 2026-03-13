import 'dart:convert';

import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  // TODO: Analyze if auth token can be fetched in the constructor once and used throughout the app lifecycle.
  ApiClient({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  final _baseUrl = 'http://localhost:8080/';

  Future<http.Response> get(String urlPath, Map<String, String> queryParams) async {
    Uri uri = Uri.parse('$_baseUrl$urlPath').replace(queryParameters: queryParams);

    final Map<String, String> headers = await _addAuthorizationHeader({});
    final http.Response rawResponse = await http.get(uri, headers: headers);

    return rawResponse;
  }

  Future<http.Response> post<T>(
    String urlPath, {
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
    T? payload,
  }) async {
    Uri uri = Uri.parse('$_baseUrl$urlPath').replace(queryParameters: queryParams);

    // TODO: Check if query params are not empty, then add them.
    headers = _addContentTypeHeader(headers);
    headers = await _addAuthorizationHeader(headers);

    String body = jsonEncode(payload);

    final http.Response rawResponse = await http.post(uri, headers: headers, body: body);

    return rawResponse;
  }

  void put() {}

  void delete() {}

  Future<Map<String, String>> _addAuthorizationHeader(Map<String, String> headers) async {
    final Map<String, String> h = Map.of(headers);
    final String token = await _authService.getToken();
    final Map<String, String> authHeader = {'Authorization': 'Bearer $token'};

    h.addAll(authHeader);

    return h;
  }

  Map<String, String> _addContentTypeHeader(Map<String, String> headers) {
    final Map<String, String> h = Map.of(headers);
    final Map<String, String> contentTypeHeader = {'content-type': 'application/json'};

    h.addAll(contentTypeHeader);

    return h;
  }
}

// class QueryParamValue {
//   QueryParamValue({required this.value}) {
//     if (value is! String && value is! int) {
//       throw ArgumentError('Value must be either String or int.');
//     }
//   }
//
//   final Object value;
// }
