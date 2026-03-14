import 'package:flutter/material.dart';
import 'package:hadhri/features/home/page.dart';
import 'package:hadhri/infrastructure/di_container.dart';

import 'features/account/page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DiContainer.init();

  final bool isUserLoggedIn = await DiContainer.authService.isLoggedIn();

  runApp(
    MainApp(isUserLoggedIn: isUserLoggedIn),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required bool isUserLoggedIn}) : _isUserLoggedIn = isUserLoggedIn;

  final bool _isUserLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          // TODO: Check for log-in session in local storage and if present, show the home page.
          // TODO: Research a better approach to construct the dependency graph.
          child: _isUserLoggedIn
              ? HomePage(attendanceService: DiContainer.attendanceService)
              : AccountPage(service: DiContainer.coursePlanService),
        ),
      ),
    );
  }
}
