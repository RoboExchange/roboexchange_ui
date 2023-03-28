import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roboexchange_ui/constant.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const storage = FlutterSecureStorage();

  static Future<bool> login(String username,String password) async {
    var url = "$serverBaseUrl/api/v1/auth/login";
    final uri = Uri.parse(url);

    final credentials = '$username:$password';
    var encoded = base64.encode(utf8.encode(credentials));
    var headers = {'Authorization': 'Basic $encoded'};
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var token = response.headers['authorization'];
      print('Login success');
      await storage.write(key: 'token', value: token);
      return true;
    }

    return false;
  }

  static Future<String?> getToken() async {
    var token = await storage.read(key: 'token');
    return token;
  }
}