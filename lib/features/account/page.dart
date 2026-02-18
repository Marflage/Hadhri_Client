import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadhri/features/account/account_form.dart';
import 'package:hadhri/infrastructure/responses/get_course_plans.dart';
import 'package:hadhri/infrastructure/services/account_form_service.dart';
import 'package:http/http.dart';

import '../../infrastructure/services/course_plan_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.service,
  });

  final CoursePlanService service;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late GetCoursePlansResponse _getCoursePlans;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    // TODO: Should the operation be awaited here?
    final vm = widget.service.fetchCoursePlansAsync();
    vm.then(
      (value) => setState(() {
        _isLoading = false;
        _getCoursePlans = value.data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: const CircularProgressIndicator.adaptive())
          : AccountForm(
              getCoursePlans: _getCoursePlans,
              service: AccountFormService(),
            ),
    );
  }
}
