import 'package:flutter/material.dart';
import 'package:roboexchange_ui/service/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoboExchange',
      initialRoute: '/',
      onGenerateRoute: RouteHandler.handle,
    );
  }
}
