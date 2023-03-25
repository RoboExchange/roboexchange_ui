import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roboexchange_ui/service/auth_service.dart';

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
                  style: TextStyle(color: Colors.white),
                  controller: usernameController,
                  decoration: InputDecoration(
                    label: Text("Username"),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white54),
                    focusColor: Colors.white,
                  ),
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordPassword,
                  decoration: InputDecoration(
                    label: Text("Password"),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white54),
                    focusColor: Colors.white,
                  ),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    login();
                  },
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

    final username = usernameController.text;
    final password = passwordPassword.text;
    var success = await AuthService.login(username, password);

    if (success && context.mounted) {
      Navigator.of(context).pushNamed("/");
    } else if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
