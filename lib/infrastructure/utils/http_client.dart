import 'dart:convert';

import 'package:hadhri/infrastructure/interceptors/request_interceptor.dart';
import 'package:hadhri/infrastructure/interceptors/response_interceptor.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  // TODO: Analyze if auth token can be fetched in the constructor once and used throughout the app lifecycle.
  HttpClient({
    required RequestInterceptor requestInterceptor,
    required ResponseInterceptor responseInterceptor,
  }) : _requestInterceptor = requestInterceptor,
       _responseInterceptor = responseInterceptor;

  final RequestInterceptor _requestInterceptor;
  final ResponseInterceptor _responseInterceptor;

  static const _baseUrl = 'http://localhost:8080/';

  Future<http.Response> get(String urlPath, {Map<String, String> queryParams = const {}}) async {
    Uri uri = Uri.parse('$_baseUrl$urlPath').replace(queryParameters: queryParams);

    final Map<String, String> headers = await _requestInterceptor.addAuthorizationHeader({});
    headers.addAll({'accept': 'application/json'});

    final http.Response rawResponse = await http.get(uri, headers: headers);

    _responseInterceptor.ifTokenExpired(rawResponse.statusCode);

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
      headers = await _requestInterceptor.addAuthorizationHeader(headers);
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
    headers = _requestInterceptor.addContentTypeHeader(headers);

    String body = jsonEncode(payload);

    final http.Response rawResponse = await http.post(uri, headers: headers, body: body);

    _responseInterceptor.ifTokenExpired(rawResponse.statusCode);

    return rawResponse;
  }

  void put() {}

  void delete() {}
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
