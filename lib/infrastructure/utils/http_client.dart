import 'dart:convert';

import 'package:hadhri/infrastructure/services/token_service.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  // TODO: Analyze if auth token can be fetched in the constructor once and used throughout the app lifecycle.
  HttpClient({required TokenService tokenService}) : _tokenService = tokenService;

  final TokenService _tokenService;
  final _baseUrl = 'http://localhost:8080/';

  Future<http.Response> get(String urlPath, Map<String, String> queryParams) async {
    Uri uri = Uri.parse('$_baseUrl$urlPath').replace(queryParameters: queryParams);

    final Map<String, String> headers = await _addAuthorizationHeader({});
    headers.addAll({'accept': 'application/json'});

    final http.Response rawResponse = await http.get(uri, headers: headers);

    return rawResponse;
  }

  Future<http.Response> post<T>(
    String urlPath, {
    bool isAuthorized = true,
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
    T? payload,
  }) async {
    if (isAuthorized) {
      headers = await _addAuthorizationHeader(headers);
    }

    return _post(urlPath, queryParams: queryParams, headers: headers, payload: payload);
  }

  Future<http.Response> _post<T>(
    String urlPath, {
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
    T? payload,
  }) async {
    Uri uri = Uri.parse('$_baseUrl$urlPath').replace(queryParameters: queryParams);

    // TODO: Check if query params are not empty, then add them.
    headers = _addContentTypeHeader(headers);

    String body = jsonEncode(payload);

    final http.Response rawResponse = await http.post(uri, headers: headers, body: body);

    return rawResponse;
  }

  void put() {}

  void delete() {}

  Future<Map<String, String>> _addAuthorizationHeader(Map<String, String> headers) async {
    final Map<String, String> h = Map.of(headers);
    final String token = await _tokenService.getToken();
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
