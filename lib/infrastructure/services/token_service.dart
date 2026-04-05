import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';

class TokenService {
  TokenService({required SecureStorageService storageService}) : _storageService = storageService;

  final SecureStorageService _storageService;

  // TODO: Why is the static keyword required for a const to be declared?
  static const String authTokenKey = 'authToken';

  Future<String> getTokenIfValid() async {
    final String token = await _getToken();

    try {
      _checkTokenValidity(token);
    } catch (e) {
      rethrow;
    }

    return token;
  }

  Future<void> saveToken(String value) async {
    await _storageService.write(authTokenKey, value);
  }

  Future<void> deleteToken() async {
    await _storageService.delete(authTokenKey);
  }

  Future<String> _getToken() async {
    final String? token = await _storageService.read(authTokenKey);

    if (token == null || token.isEmpty) {
      throw Exception('Auth token not found.');
    }

    return token;
  }

  void _checkTokenValidity(String token) {
    final jwt = JWT.decode(token);

    DateTime expiry = DateTime.fromMillisecondsSinceEpoch(jwt.payload['exp'] * 1000);

    if (expiry.isBefore(DateTime.now().toUtc())) throw Exception('Token expired.');
  }
}
