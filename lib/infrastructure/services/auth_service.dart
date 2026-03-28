import 'dart:convert';
import 'dart:io';

import 'package:hadhri/infrastructure/services/base_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:hadhri/infrastructure/services/token_service.dart';
import 'package:http/http.dart';

import '../../domain/view_models/base_view_model.dart';
import '../requests/sign_in_request.dart';
import '../requests/sign_up_request.dart';
import '../responses/api_response.dart';
import '../responses/sign_in_response.dart';

class AuthService extends BaseService {
  AuthService({
    required super.httpClient,
    required TokenService tokenService,
    required SecureStorageService storageService,
  }) : _tokenService = tokenService,
       _storageService = storageService;

  final TokenService _tokenService;
  final SecureStorageService _storageService;

  // TODO: Research if HTTP concerns such as the request type should leak into the service layer.
  Future<BaseViewState> signUp(SignUpRequest request) async {
    final urlPath = 'sign-up';

    final BaseViewState<dynamic> vs = BaseViewState(message: '');

    try {
      final Response rawResponse = await httpClient.post(
        urlPath,
        isAuthorized: false,
        payload: request,
      );

      final json = jsonDecode(rawResponse.body);
      final ApiResponse<String> response = ApiResponse<String>.fromJson(
        json,
        parseJsonData: (json) => json['data'],
      );

      if (response.error?.isNotEmpty == true) {
        vs.message = response.error!;
        return vs;
      } else if (response.message?.isNotEmpty == true) {
        vs.message = response.message!;
      }

      if (response.data?.isEmpty == true) {
        throw Exception('No data found.');
      }

      // TODO: Handle the case when both error and message are null.

      await _tokenService.saveToken(response.data!);
    } on SocketException {
      vs.message = "Connection error. Please check your internet connection.";
      return vs;
    } catch (e) {
      vs.message = e.toString();
    }

    return vs;
  }

  Future<BaseViewState<String>> signIn(SignInRequest request) async {
    final String urlPath = 'sign-in';

    final BaseViewState<String> vs = BaseViewState<String>();

    try {
      final Response rawResponse = await httpClient.post(
        urlPath,
        isAuthorized: false,
        payload: request,
      );

      final json = jsonDecode(rawResponse.body);
      final ApiResponse<SignInResponse> response = ApiResponse<SignInResponse>.fromJson(
        json,
        parseJsonData: (json) => SignInResponse.fromJson(json['data']),
      );

      if (response.error?.isNotEmpty == true) {
        vs.error = response.error!;
        return vs;
      } else if (response.message?.isNotEmpty == true) {
        vs.message = response.message!;
      }

      if (response.data == null) {
        throw Exception('No data found.');
      }

      int studentId = response.data!.studentId;
      String token = response.data!.token;

      if (studentId <= 0) throw ArgumentError('Invalid student ID.');
      if (token.isEmpty) throw ArgumentError('Invalid token.');

      await _storageService.write('studentId', studentId.toString());
      await _tokenService.saveToken(token);
    } on SocketException {
      vs.error = 'Connection error. Please check your internet connection.';
      return vs;
    } catch (e) {
      vs.error = e.toString();
    }

    return vs;
  }

  Future<bool> isSignedIn() async {
    try {
      await _tokenService.getTokenIfValid();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> signOut() async {
    await _tokenService.deleteToken();
  }
}
