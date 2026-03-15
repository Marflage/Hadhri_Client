import 'package:flutter/material.dart';
import 'package:hadhri/features/account/sign_in_form.dart';
import 'package:hadhri/features/account/sign_up_form.dart';
import 'package:hadhri/infrastructure/di_container.dart';

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
          Expanded(
            child: _showSignInForm
                // TODO: Remove the usage of DiContainer in the UI components.
                ? SignInForm(accountService: DiContainer.accountService)
                : SignUpForm(
                    coursePlanService: DiContainer.coursePlanService,
                    accountService: DiContainer.accountService,
                  ),
          ),
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(_showSignInForm ? 'Do not have an account?' : 'Already have an account?'),
              TextButton(
                onPressed: () => setState(() => _showSignInForm = !_showSignInForm),
                child: Text(_showSignInForm ? 'Sign up.' : 'Sign in.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
