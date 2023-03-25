import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/components/drawer.dart';

class DesktopScaffold extends StatefulWidget {
  final Widget body;

  const DesktopScaffold({Key? key, required this.body}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          drawer,
          Expanded(
            child: widget.body,
          ),
        ],
      ),
    );
  }
}
