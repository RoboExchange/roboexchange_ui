import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/components/drawer.dart';

class TabletScaffold extends StatefulWidget {
  final Widget body;

  const TabletScaffold({Key? key, required this.body}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      drawer: drawer,
      body: widget.body,
    );
  }
}
