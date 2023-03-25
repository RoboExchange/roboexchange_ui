import 'package:flutter/material.dart';

var drawer = Drawer(
  child: Column(
    children: [
      DrawerHeader(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Image.asset('images/logo.png'),
          ),
        ),
      ),
      ListTile(
        onTap: () {},
        title: Text("Trends"),
        leading: Icon(Icons.trending_up),
      ),
      ListTile(
        onTap: () {},
        title: Text("Signals"),
        leading: Icon(Icons.signal_cellular_alt),
      ),
      ListTile(
        onTap: () {},
        title: Text("Settings"),
        leading: Icon(Icons.settings),
      ),
    ],
  ),
);