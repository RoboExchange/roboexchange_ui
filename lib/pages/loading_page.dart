import 'package:flutter/material.dart';
import 'package:roboexchange_ui/service/auth_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkToken(context);
    return Center(child: CircularProgressIndicator());
  }

  Future<void> checkToken(BuildContext context) async {
    var isOk = await AuthService.refreshToken();
    if (context.mounted) {
      if (!isOk) {
        Navigator.of(context).pushNamed('/login');
      } else {
        Navigator.of(context).pushNamed('/');
      }
    }
  }
}
