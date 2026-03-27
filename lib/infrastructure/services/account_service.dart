import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/requests/sign_in_request.dart';
import 'package:hadhri/infrastructure/requests/sign_up_request.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/responses/get_student_details_response.dart';
import 'package:hadhri/infrastructure/responses/sign_in_response.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:http/http.dart';

import 'base_service.dart';

class AccountService extends BaseService {
  AccountService({
    required super.apiClient,
    required AuthService authService,
    required SecureStorageService storageService,
  }) : _authService = authService,
       _storageService = storageService;

  final AuthService _authService;
  final SecureStorageService _storageService;

  // TODO: Research if HTTP concerns such as the request type should leak into the service layer.
  Future<BaseViewState> signUp(SignUpRequest request) async {
    final urlPath = 'sign-up';

    final BaseViewState<dynamic> vs = BaseViewState(message: '');

    try {
      final Response rawResponse = await apiClient.post(
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

      await _authService.saveToken(response.data!);
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
      final Response rawResponse = await apiClient.post(
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
      await _authService.saveToken(token);
    } on SocketException {
      vs.error = 'Connection error. Please check your internet connection.';
      return vs;
    } catch (e) {
      vs.error = e.toString();
    }

    return vs;
  }

  Future<BaseViewState<GetStudentDetailsResponse>> getStudentDetails(int id) async {
    final String urlPath = 'student-details';

    Map<String, String> queryParams = {'studentId': '$id'};

    final BaseViewState<GetStudentDetailsResponse> vs = BaseViewState<GetStudentDetailsResponse>(
      message: '',
    );

    try {
      final rawResponse = await apiClient.get(urlPath, queryParams);
      final json = jsonDecode(rawResponse.body);

      final ApiResponse<GetStudentDetailsResponse> response =
          ApiResponse<GetStudentDetailsResponse>.fromJson(
            json,
            parseJsonData: (json) => GetStudentDetailsResponse.fromJson(json['data']),
          );

      if (response.error?.isNotEmpty == true) {
        vs.message = response.error!;
        return vs;
      } else if (response.message?.isNotEmpty == true) {
        vs.message = response.message!;
      }

      if (response.data == null) {
        throw Exception('No data found');
      }

      vs.data = response.data;
    } on SocketException {
      vs.message = 'Connection error. Please check your internet connection.';
    } catch (e) {
      vs.message = e.toString();
    }

    return vs;
  }
}
