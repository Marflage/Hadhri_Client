import 'dart:convert';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/responses/get_course_plans.dart';
import 'package:http/http.dart';

class CoursePlanService {
  // TODO: Store this in a config file for maintainability and reusability.
  static const String _baseUrl = 'http://localhost:8080/';

  Future<BaseViewModel> fetchCoursePlansAsync() async {
    // TODO: Create a constant for this URL.
    const url = '${_baseUrl}course-plans';
    // const url = 'http://10.0.2.2:8080/course-plans';
    final uri = Uri.parse(url);

    final vm = BaseViewModel(message: '');

    try {
      final rawResponse = await get(uri);

      final json = jsonDecode(rawResponse.body);
      final response = ApiResponse<GetCoursePlansResponse>(
        json,
        parseJsonData: (json) => GetCoursePlansResponse(json),
      );

      if (rawResponse.statusCode != 200 && response.error != null) {
        vm.message = response.error!;
      } else if (response.message != null) {
        vm.message = response.message!;
      }

      // TODO: Handle the case when both error and message are null.

      if (response.data == null) {
        throw Exception('No data found');
      }

      vm.data = response.data;
    } catch (e) {
      vm.message = e.toString();
    }

    return vm;
  }
}
