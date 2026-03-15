import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/requests/sign_in_request.dart';
import 'package:hadhri/infrastructure/requests/sign_up_request.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
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
      } else if (response.message?.isNotEmpty == true) {
        vm.message = response.message!;
      }

      if (response.data?.isEmpty == true) {
        throw Exception('No data found.');
      }

      // TODO: Handle the case when both error and message are null.

      await _authService.saveToken(response.data!);
    } on SocketException catch (e) {
      vm.message = "Connection error. Please check your internet connection.";
      return vm;
    } catch (e) {
      vm.message = e.toString();
    }

    return vm;
  }

  Future<BaseViewModel<String>> signIn(SignInRequest request) async {
    final String urlPath = 'sign-in';

    final vm = BaseViewModel<String>(message: '');

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
        throw Exception("No data found.");
      }

      await _authService.saveToken(response.data!);
    } on SocketException catch (e) {
      vm.message = "Connection error. Please check your internet connection.";
      return vm;
    } catch (e) {
      vm.message = e.toString();
    }

    return vm;
  }
}
