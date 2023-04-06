import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/components/side_menu.dart';

class MobileScaffold extends StatefulWidget {
  final Widget body;
  final String title;

  const MobileScaffold({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: topMenu(context, widget.title),
      drawer: sideMenu(context),
      body: widget.body,
    );
  }
}
