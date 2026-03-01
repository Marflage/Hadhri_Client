import 'dart:convert';
import 'dart:io';

import 'package:hadhri/domain/view_models/base_view_model.dart';
import 'package:hadhri/infrastructure/requests/sign_up_request.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:http/http.dart';

class AccountFormService {
  // TODO: Store this in a config file.
  static const String baseUrl = 'http://localhost:8080/';

  // TODO: Research if HTTP concerns such as the request type should leak into the service layer.
  Future<BaseViewModel> register(SignUpRequest request) async {
    final url = '${baseUrl}sign-up';
    final uri = Uri.parse(url);

    final vm = BaseViewModel(message: '');
    final body = jsonEncode(request);

    try {
      final rawResponse = await post(
        uri,
        headers: {'content-type': 'application/json'},
        body: body,
      );

      final json = jsonDecode(rawResponse.body);
      final response = ApiResponse(json);
      vm.message = response.message!;

      if (rawResponse.statusCode != 200 && response.error != null) {
        vm.message = response.error!;
      } else if (response.message != null) {
        vm.message = response.message!;
      }

      // TODO: Handle the case when both error and message are null.
    } catch (e) {
      if (e is SocketException) {
        vm.message = "Connection error. Please check your internet connection.";
        return vm;
      }

      vm.message = e.toString();
    }

    return vm;
  }
}
