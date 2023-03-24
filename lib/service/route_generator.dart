import 'package:flutter/material.dart';
import 'package:roboexchange_ui/pages/login_page.dart';
import 'package:roboexchange_ui/pages/trend_line_list_page.dart';

class RouteHandler {
  static Route<dynamic> handle(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => TrendLineListPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
