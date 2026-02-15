import 'dart:convert';

import 'package:hadhri/infrastructure/requests/sign_up_request.dart';
import 'package:hadhri/infrastructure/responses/api_response.dart';
import 'package:http/http.dart';

class AccountFormService {
  static const String baseUrl = 'http://localhost:8080/';

  // TODO: Research if HTTP concerns such as the request type should leak into the service layer.
  Future<void> register(SignUpRequest request) async {
    final url = '${baseUrl}sign-up';
    final uri = Uri.parse(url);

    final body = jsonEncode(request);

    try {
      final rawResponse = await post(
        uri,
        headers: {'content-type': 'application/json'},
        body: body,
      );

      final json = jsonDecode(rawResponse.body);

      if (rawResponse.statusCode != 200) {
        // TODO: Show error.
        final response = ApiResponse(json);

        if (response.error != null) {
          // TODO: Show a snack bar with error.
          final error = response.error;
        }

        // TODO: Show a snack bar with success message.
        // final message = 'asd';
      }
    } catch (e) {
      final error = e.toString();
      // TODO: Show a snack bar with error.
    }
  }
}
