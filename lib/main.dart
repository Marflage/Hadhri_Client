import 'package:flutter/material.dart';
import 'package:hadhri/features/home/page.dart';
import 'package:hadhri/infrastructure/di_container.dart';

import 'features/account/page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DiContainer.init();

  final bool isUserLoggedIn = await DiContainer.authService.isSignedIn();

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
      initialRoute: _isUserLoggedIn ? HomePage.route : AccountPage.route,
      routes: {
        AccountPage.route: (context) =>
            AccountPage(coursePlanService: DiContainer.coursePlanService),
        HomePage.route: (context) => HomePage(
          attendanceService: DiContainer.attendanceService,
          accountService: DiContainer.accountService,
          storageService: DiContainer.storageService,
          authService: DiContainer.authService,
        ),
      },
    );
  }
}
