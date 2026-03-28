import 'package:flutter/widgets.dart';
import 'package:hadhri/features/account/page.dart';

class NavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void redirectToAuthPage() =>
      navigatorKey.currentState!.pushReplacementNamed(AccountPage.route);
}
