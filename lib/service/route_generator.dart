import 'package:flutter/material.dart';
import 'package:roboexchange_ui/pages/loading_page.dart';
import 'package:roboexchange_ui/pages/login_page.dart';
import 'package:roboexchange_ui/pages/register_client_page.dart';
import 'package:roboexchange_ui/pages/trend_line_page.dart';

class RouteHandler {
  static Route<dynamic> handle(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => TrendLineListPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginPage());
      case "/register":
        return MaterialPageRoute(builder: (_) => RegisterClientPage());
      case "/loading":
        return MaterialPageRoute(builder: (_) => LoadingPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
