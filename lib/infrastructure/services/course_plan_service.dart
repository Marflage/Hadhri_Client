import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:hadhri/infrastructure/responses/get_course_plans.dart';
import 'package:http/http.dart';

class CoursePlanService {
  // TODO: Store this in a config file for maintainability and reusability.
  static const String _baseUrl = 'http://localhost:8080/';

  Future<BaseViewState<GetCoursePlansResponse>> fetchCoursePlansAsync() async {
    // TODO: Create a constant for this URL.
    const url = '${_baseUrl}course-plans';
    // const url = 'http://10.0.2.2:8080/course-plans';
    final uri = Uri.parse(url);

    final BaseViewState<GetCoursePlansResponse> vs = BaseViewState<GetCoursePlansResponse>(
      message: '',
    );

    try {
      final rawResponse = await get(uri);

      final json = jsonDecode(rawResponse.body);
      final response = ApiResponse<GetCoursePlansResponse>.fromJson(
        json,
        parseJsonData: (json) => GetCoursePlansResponse(json['data']),
      );

      if (rawResponse.statusCode != 200 && response.error != null) {
        vs.message = response.error!;
      } else if (response.message != null) {
        vs.message = response.message!;
      }

      // TODO: Handle the case when both error and message are null.

      if (response.data == null) {
        throw Exception('No data found');
      }

      vs.data = response.data;
    } catch (e) {
      if (e is SocketException) {
        vs.message = "Connection error. Please check your internet connection.";
        return vs;
      }

      vs.message = e.toString();
    }

    return vs;
  }
}
