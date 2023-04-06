import 'package:flutter/material.dart';
import 'package:roboexchange_ui/pages/trend_line_page.dart';

Drawer sideMenu(BuildContext context) {
  return Drawer(
    backgroundColor: Color(0xFF575E91),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom: Divider.createBorderSide(
                  context,
                  color: Colors.white38,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Image.asset('images/logo.png'),
              ),
            ),
          ),
          MouseRegion(
            child: ListTile(
              hoverColor: Color(0xFF7A83A4),
              iconColor: Colors.white70,
              textColor: Colors.white70,
              title: Text("Trends"),
              leading: Icon(Icons.trending_up),
              onTap: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => TrendLineListPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  )),
            ),
          ),
          ListTile(
            hoverColor: Color(0xFF7A83A4),
            iconColor: Colors.white70,
            textColor: Colors.white70,
            title: Text("Signals"),
            leading: Icon(Icons.signal_cellular_alt),
          ),
          ListTile(
            hoverColor: Color(0xFF7A83A4),
            iconColor: Colors.white70,
            textColor: Colors.white70,
            title: Text("Settings"),
            leading: Icon(Icons.settings),
          ),
        ],
      ),
    ),
  );
}
