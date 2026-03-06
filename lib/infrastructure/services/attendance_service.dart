import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/services/base_service.dart';
import 'package:http/http.dart';

class AttendanceService extends BaseService {
  AttendanceService({required super.apiClient});

  Future<BaseViewModel> logAttendance(int studentId) async {
    final urlPath = 'log-attendance';
    final Map<String, String> queryParams = {'studentId': studentId.toString()};
    final vm = BaseViewModel(message: '');

    // TODO: Why should this code be surrounded with a try-catch block?
    try {
      final Response rawResponse = await apiClient.post(urlPath, queryParams);

      final json = jsonDecode(rawResponse.body);
      final response = ApiResponse.fromJson(json);

      if (response.error != null) {
        vm.message = response.error!;
      } else if (response.message != null) {
        vm.message = response.message!;
      }
    } catch (e) {
      if (e is SocketException) {
        vm.message = 'Connection. Please check your internet connection.';
        return vm;
      }

      vm.message = e.toString();
    }

    return vm;
  }
}
