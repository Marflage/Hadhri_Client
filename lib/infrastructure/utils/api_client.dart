import 'dart:convert';

import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({required SecureStorageService storageService}) : _storageService = storageService;

  final SecureStorageService _storageService;

  final _baseUrl = 'http://localhost:8080/';

  Future<http.Response> get(String relUrl, Map<String, String> queryParams) async {
    Uri uri = Uri.parse('$_baseUrl$relUrl');
    uri.queryParameters.addAll(queryParams);

    http.Request('get', uri).headers;
    final Map<String, String> headers = await _addAuthorizationHeader({});
    final http.Response rawResponse = await http.get(uri, headers: headers);

    return rawResponse;
  }

  Future<http.Response> post<T>(String relUrl, Map<String, String> headers, T payload) async {
    Uri uri = Uri.parse('$_baseUrl$relUrl');
    String body = jsonEncode(payload);

    headers = _addContentTypeHeader(headers);
    headers = await _addAuthorizationHeader(headers);

    final http.Response rawResponse = await http.post(uri, headers: headers, body: body);

    return rawResponse;
  }

  void put() {}

  void delete() {}

  Future<Map<String, String>> _addAuthorizationHeader(Map<String, String> headers) async {
    final Map<String, String> h = Map.of(headers);

    final String token = await _storageService.read('authToken');
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
