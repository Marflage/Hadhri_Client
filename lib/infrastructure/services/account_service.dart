import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/responses/get_student_details_response.dart';
import 'package:hadhri/infrastructure/responses/get_student_enrollment_details_response.dart';
import 'package:http/http.dart' show Response;

import 'base_service.dart';

class AccountService extends BaseService {
  AccountService({required super.httpClient});

  Future<BaseViewState<GetStudentDetailsResponse>> getStudentDetails() async {
    final String urlPath = 'students';

    final BaseViewState<GetStudentDetailsResponse> vs = BaseViewState<GetStudentDetailsResponse>(
      message: '',
    );

    try {
      final rawResponse = await httpClient.get(urlPath);
      final json = jsonDecode(rawResponse.body);

      final ApiResponse<GetStudentDetailsResponse> response =
          ApiResponse<GetStudentDetailsResponse>.fromJson(
            json,
            parseJsonData: (json) => GetStudentDetailsResponse.fromJson(json['data']),
          );

      if (response.error?.isNotEmpty == true) {
        vs.error = response.error!;
        return vs;
      } else if (response.message?.isNotEmpty == true) {
        vs.message = response.message!;
      }

      if (response.data == null) {
        throw Exception('No data found');
      }

      vs.data = response.data;
    } on SocketException {
      vs.error = 'Connection error. Please check your internet connection.';
    } catch (e) {
      vs.error = e.toString();
    }

    return vs;
  }

  Future<BaseViewState<GetStudentEnrollmentDetailsResponse>> getStudentEnrollmentDetails() async {
    final String urlPath = 'student-enrollments';
    final vs = BaseViewState<GetStudentEnrollmentDetailsResponse>();

    try {
      final Response rawResponse = await httpClient.get(urlPath);
      final json = jsonDecode(rawResponse.body);

      final response = ApiResponse<GetStudentEnrollmentDetailsResponse>.fromJson(
        json,
        parseJsonData: (json) => GetStudentEnrollmentDetailsResponse.fromJson(json['data']),
      );

      if (response.error?.isNotEmpty == true) throw Exception(response.error);

      if (response.message?.isNotEmpty == true) vs.message = response.message!;

      if (response.data == null) throw Exception('No data found.');

      vs.data = response.data;
    } on SocketException {
      vs.error = 'Connection error. Please check your internet connection.';
    } catch (e) {
      vs.error = e.toString();
    }

    return vs;
  }
}
