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
      await _isTokenValid(token);
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

  Future<bool> _isTokenValid(String token) async {
    try {
      final jwt = JWT.decode(token);

      // TODO: Create a const for this magic string.
      DateTime expiry = DateTime.fromMillisecondsSinceEpoch(jwt.payload['exp']);

      if (expiry.isBefore(DateTime.now())) throw Exception('Token expired.');

      return true;
    } catch (e) {
      return false;
    }
  }
}
