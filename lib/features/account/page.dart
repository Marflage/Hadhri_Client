import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadhri/features/account/account_form.dart';
import 'package:hadhri/infrastructure/responses/get_course_plans.dart';
import 'package:hadhri/infrastructure/services/account_form_service.dart';
import 'package:http/http.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late GetCoursePlans _getCoursePlans;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    // TODO: Fetch the reference data of course and time slots.
    _fetchCoursePlansAsync();
  }

  // TODO: Move this into the service layer in a separate file.
  Future<void> _fetchCoursePlansAsync() async {
    // TODO: Create a constant for this URL.
    const url = 'http://192.168.100.9:8080/course-plans';
    // const url = 'http://10.0.2.2:8080/course-plans';
    var uri = Uri.parse(url);

    // TODO: Wrap this operation in a try-catch block.
    final response = await get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      // TODO: Create the view model.

      setState(() {
        _getCoursePlans = GetCoursePlans(responseJson);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const CircularProgressIndicator.adaptive()
          : AccountForm(
              getCoursePlans: _getCoursePlans,
              service: AccountFormService(),
            ),
    );
  }
}
