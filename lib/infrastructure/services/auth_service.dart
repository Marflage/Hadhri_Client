import 'package:hadhri/infrastructure/services/token_service.dart';

class AuthService {
  AuthService({required TokenService tokenService}) : _tokenService = tokenService;

  final TokenService _tokenService;

  Future<bool> isLoggedIn() async {
    try {
      await _tokenService.getToken();
    } catch (e) {
      return false;
    }
    return true;
  }
}
