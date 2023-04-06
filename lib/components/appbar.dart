import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

AppBar topMenu(BuildContext context, String title) {
  return AppBar(
// automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    shadowColor: null,
    foregroundColor: Colors.black,
    title: Text(title),
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
