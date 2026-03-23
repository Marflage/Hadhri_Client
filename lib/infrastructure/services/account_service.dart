import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/requests/sign_in_request.dart';
import 'package:hadhri/infrastructure/requests/sign_up_request.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/responses/get_student_details_response.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:http/http.dart';

import 'base_service.dart';

class AccountService extends BaseService {
  AccountService({
    required super.apiClient,
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  // TODO: Research if HTTP concerns such as the request type should leak into the service layer.
  Future<BaseViewModel> signUp(SignUpRequest request) async {
    final urlPath = 'sign-up';

    final vm = BaseViewModel(message: '');

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
        vm.message = response.error!;
        return vm;
      } else if (response.message?.isNotEmpty == true) {
        vm.message = response.message!;
      }

      if (response.data?.isEmpty == true) {
        throw Exception('No data found.');
      }

      // TODO: Handle the case when both error and message are null.

      await _authService.saveToken(response.data!);
    } on SocketException {
      vm.message = "Connection error. Please check your internet connection.";
      return vm;
    } catch (e) {
      vm.message = e.toString();
    }

    return vm;
  }

  Future<BaseViewModel<String>> signIn(SignInRequest request) async {
    final String urlPath = 'sign-in';

    final BaseViewModel<String> vm = BaseViewModel<String>();

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
        vm.error = response.error!;
        return vm;
      } else if (response.message?.isNotEmpty == true) {
        vm.message = response.message!;
      }

      if (response.data?.isEmpty == true) {
        throw Exception('No data found.');
      }

      await _authService.saveToken(response.data!);
    } on SocketException {
      vm.error = 'Connection error. Please check your internet connection.';
      return vm;
    } catch (e) {
      vm.error = e.toString();
    }

    return vm;
  }

  Future<BaseViewModel<GetStudentDetailsResponse>> getStudentDetails(int id) async {
    final String urlPath = 'student-details';

    Map<String, String> queryParams = {'studentId': '$id'};

    final vs = BaseViewModel<GetStudentDetailsResponse>(message: '');

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
