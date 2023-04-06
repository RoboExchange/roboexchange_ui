import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/components/side_menu.dart';

class TabletScaffold extends StatefulWidget {
  final Widget body;
  final String title;

  const TabletScaffold({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: topMenu(context, widget.title),
      drawer: sideMenu(context),
      body: widget.body,
    );
  }
}
