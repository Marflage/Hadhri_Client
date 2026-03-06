import 'package:hadhri/infrastructure/services/secure_storage_service.dart';

class AuthService {
  AuthService({required SecureStorageService storageService}) : _storageService = storageService;

  final SecureStorageService _storageService;

  // TODO: Why is the static keyword required for a const to be declared?
  static const String authTokenKey = 'authToken';

  Future<String> getToken() async {
    final String? token = await _storageService.read(authTokenKey);

    if (token == null || token.isEmpty) {
      throw Exception('Auth token not found.');
    }

    return token;
  }

  Future<void> saveToken(String value) async {
    await _storageService.write(authTokenKey, value);
  }

  Future<void> deleteToken() async {
    await _storageService.delete(authTokenKey);
  }
}
