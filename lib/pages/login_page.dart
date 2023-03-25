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
      body: Center(
        child: SizedBox(
          width: 400,
          height: 280,
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    label: Text("Username"),
                  ),
                ),
                TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordPassword,
                  decoration: InputDecoration(
                    label: Text("Password"),
                  ),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    login();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: login,
                    child: Text("LOGIN"),
                  ),
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
