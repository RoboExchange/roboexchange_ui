import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/components/drawer.dart';

class MobileScaffold extends StatefulWidget {
  final Widget body;

  const MobileScaffold({Key? key, required this.body}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      drawer: drawer,
      body: widget.body,
    );
  }
}
