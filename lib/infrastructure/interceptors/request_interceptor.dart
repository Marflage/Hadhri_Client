import 'package:hadhri/infrastructure/services/navigator_service.dart';
import 'package:hadhri/infrastructure/services/token_service.dart';

class RequestInterceptor {
  RequestInterceptor({required TokenService tokenService}) : _tokenService = tokenService;

  final TokenService _tokenService;

  Future<Map<String, String>> addAuthorizationHeader(Map<String, String> headers) async {
    final Map<String, String> h = Map.of(headers);

    late final String token;

    try {
      token = await _tokenService.getTokenIfValid();
    } catch (e) {
      NavigatorService.redirectToAuthPage();
    }

    final Map<String, String> authHeader = {'Authorization': 'Bearer $token'};

    h.addAll(authHeader);

    return h;
  }

  Map<String, String> addContentTypeHeader(Map<String, String> headers) {
    final Map<String, String> h = Map.of(headers);
    final Map<String, String> contentTypeHeader = {'content-type': 'application/json'};

    h.addAll(contentTypeHeader);

    return h;
  }
}
