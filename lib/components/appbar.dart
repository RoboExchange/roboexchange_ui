import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class CustomAppBar {
  static AppBar getAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            storage.delete(key: 'token');
            Navigator.of(context).pushNamed("/login");
          },
          icon: Icon(Icons.logout),
        )
      ],
    );
  }
}
