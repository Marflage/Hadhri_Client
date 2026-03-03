import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:http/http.dart';

class AttendanceService {
  final baseUrl = 'http://localhost:8080/';

  Future<BaseViewModel> logAttendance(int studentId) async {
    final url = '${baseUrl}log-attendance?studentId=$studentId';
    final uri = Uri.parse(url);

    final vm = BaseViewModel(message: '');

    try {
      final rawResponse = await post(
        uri,
        // TODO: Create a const for this.
        headers: {'content-type': 'application/json'},
      );

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
