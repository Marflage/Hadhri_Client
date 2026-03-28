import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/responses/get_student_details_response.dart';

import 'base_service.dart';

class AccountService extends BaseService {
  AccountService({required super.apiClient});

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
