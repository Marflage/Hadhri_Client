import 'package:flutter/material.dart';
import 'package:hadhri/features/account/sign_in_form.dart';
import 'package:hadhri/features/account/sign_up_form.dart';
import 'package:hadhri/infrastructure/services/account_service.dart';

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
  var _showSignInForm = true;

  @override
  Widget build(BuildContext context) {
    // TODO: Analyze if this Scaffold can be removed safely.
    return Scaffold(
      body: Column(
        children: [
          _showSignInForm
              ? SignInForm(service: AccountService())
              : SignUpForm(
                  coursePlanService: CoursePlanService(),
                  accountService: AccountService(),
                ),
          TextButton(
            onPressed: () => setState(() => _showSignInForm = false),
            child: Text('Sign up.'),
          ),
        ],
      ),
    );
  }
}
