import 'package:flutter/material.dart';
import 'package:roboexchange_ui/constant.dart';

class DropDownTimeframes extends StatefulWidget {
  final String? selectedTimeframe;
  final Function(String?) onChange;

  const DropDownTimeframes(
      {Key? key, this.selectedTimeframe, required this.onChange})
      : super(key: key);

  @override
  State<DropDownTimeframes> createState() => _DropDownTimeframesState();
}

class _DropDownTimeframesState extends State<DropDownTimeframes> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(label: Text("Timeframe")),
      value: widget.selectedTimeframe,
      items: timeframes.map((String tf) {
        return DropdownMenuItem(
          value: tf,
          child: Text(tf),
        );
      }).toList(),
      onChanged: (String? value) => widget.onChange(value),
    );
  }
}
