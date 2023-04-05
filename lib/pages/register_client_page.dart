import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roboexchange_ui/components/BlurCard.dart';
import 'package:roboexchange_ui/service/auth_service.dart';

class RegisterClientPage extends StatefulWidget {
  const RegisterClientPage({Key? key}) : super(key: key);

  @override
  State<RegisterClientPage> createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends State<RegisterClientPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController cellPhoneNumberController =
      TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/login-background.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
            child: BlurCard(
              border: Border.all(color: Colors.white),
              color: Color.fromARGB(50, 255, 255, 255),
              width: 300,
              height: 430,
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/login"),
                      icon: Icon(Icons.arrow_back_outlined),
                    ),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54)),
                      labelStyle: TextStyle(color: Colors.white54),
                      label: Text("Username"),
                    ),
                  ),
                  TextField(
                    controller: cellPhoneNumberController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54)),
                      labelStyle: TextStyle(color: Colors.white54),
                      label: Text("Phone number"),
                    ),
                  ),
                  TextField(
                    controller: cellPhoneNumberController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54)),
                      labelStyle: TextStyle(color: Colors.white54),
                      label: Text("Email"),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54)),
                      labelStyle: TextStyle(color: Colors.white54),
                      fillColor: Colors.white,
                      label: Text("Confirm Password"),
                    ),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      register();
                    },
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54)),
                      labelStyle: TextStyle(color: Colors.white54),
                      fillColor: Colors.white,
                      label: Text("Password"),
                    ),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      register();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        onPressed: register,
                        child: Text("Register"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    final username = usernameController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final cellPhoneNumber = cellPhoneNumberController.text;
    final emailAddress = emailAddressController.text;
    if (password == confirmPassword) {
      var success = await AuthService.register(
          username, password, cellPhoneNumber, emailAddress);
      if (success && context.mounted) {
        Navigator.of(context).pushNamed("/login");
      }
    }
  }
}
