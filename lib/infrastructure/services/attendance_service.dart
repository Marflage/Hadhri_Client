import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/services/base_service.dart';
import 'package:http/http.dart';

class AttendanceService extends BaseService {
  AttendanceService({required super.httpClient});

  Future<BaseViewState> logAttendance(int studentId) async {
    final urlPath = 'log-attendance';
    final Map<String, String> queryParams = {'studentId': studentId.toString()};
    final BaseViewState<dynamic> vs = BaseViewState(message: '');

    // TODO: Why should this code be surrounded with a try-catch block?
    try {
      final Response rawResponse = await httpClient.post(urlPath, queryParams: queryParams);

      final json = jsonDecode(rawResponse.body);
      final response = ApiResponse.fromJson(json);

      if (response.error?.isNotEmpty == true) {
        vs.error = response.error!;
        return vs;
      } else if (response.message?.isNotEmpty == true) {
        vs.message = response.message!;
      }
    } on SocketException {
      vs.error = 'Connection error. Please check your internet connection.';
    } catch (e) {
      vs.error = e.toString();
    }

    return vs;
  }

  Future<BaseViewState<bool>> isAttendanceLogged() async {
    final urlPath = 'attendance-status';

    final vs = BaseViewState<bool>();

    try {
      final Response rawResponse = await httpClient.get(urlPath);

      final json = jsonDecode(rawResponse.body);
      final response = ApiResponse<bool>.fromJson(json);

      if (response.error?.isNotEmpty == true) {
        throw Exception(response.error);
      } else if (response.message?.isNotEmpty == true) {
        vs.message = response.message!;
      }

      if (response.data == null) throw Exception('No data found');

      vs.data = response.data;
    } on SocketException {
      vs.error = 'Connection error. Please check your internet connection.';
    } catch (e) {
      vs.error = e.toString();
    }

    return vs;
  }
}
