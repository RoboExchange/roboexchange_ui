import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:roboexchange_ui/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordPassword = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          height: 280,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(label: Text("Username")),
                  onEditingComplete: login,
                ),
                TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordPassword,
                  decoration: InputDecoration(label: Text("Password")),
                  onEditingComplete: login,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: login,
                  child: Text("LOGIN"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    const url = "${Constant.serverBaseUrl}/api/v1/auth/login";
    final uri = Uri.parse(url);
    final username = usernameController.text;
    final password = passwordPassword.text;
    final credentials = '$username:$password';

    var encoded = base64.encode(utf8.encode(credentials));

    var headers = {'Authorization': 'Basic $encoded'};

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var responseHeaders = response.headers;
      var token = responseHeaders['authorization'];
      print('Login success');
      storage.write(key: 'token', value: token)
          .then((value) => Navigator.of(context).pushNamed("/"));
    }

    if (context.mounted) Navigator.of(context).pop();
  }
}
