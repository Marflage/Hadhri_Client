import 'package:flutter/material.dart';
import 'package:hadhri/features/account/page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          // TODO: Check for log-in session in local storage and if present, show the home page.
          child: AccountPage(),
        ),
      ),
    );
  }
}
