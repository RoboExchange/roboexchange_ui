import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/components/side_menu.dart';

class DesktopScaffold extends StatefulWidget {
  final Widget body;
  final String title;
  final FloatingActionButton? floatingActionButton;

  const DesktopScaffold(
      {Key? key,
      required this.body,
      required this.title,
      this.floatingActionButton})
      : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xDFEAEAFF),
      floatingActionButton: widget.floatingActionButton,
      body: Row(
        children: [
          sideMenu(context),
          Expanded(
            child: Column(
              children: [
                topMenu(context, widget.title),
                widget.body
              ],
            ),
          ),
        ],
      ),
    );
  }
}
