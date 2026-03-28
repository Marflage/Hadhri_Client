import 'dart:io';

import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:hadhri/infrastructure/services/token_service.dart';

import '../enums/storage_keys.dart';
import '../services/navigator_service.dart';

class ResponseInterceptor {
  ResponseInterceptor({
    required TokenService tokenService,
    required SecureStorageService storageService,
  }) : _tokenService = tokenService,
       _storageService = storageService;

  final TokenService _tokenService;
  final SecureStorageService _storageService;

  Future<void> ifTokenExpired(int statusCode) async {
    if (statusCode == HttpStatus.unauthorized) {
      await _tokenService.deleteToken();

      // TODO: Use an enum/const for storage keys.
      await _storageService.delete(StorageKeys.studentId.toString());

      NavigatorService.redirectToAuthPage();
    }
  }
}
