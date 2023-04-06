import 'package:flutter/material.dart';
import 'package:roboexchange_ui/model/Timeframe.dart';

DropdownButtonFormField timeFrameDropDown(Timeframe selected, Function(Timeframe?) onChange) {
  return DropdownButtonFormField(
    value: selected,
    items: timeframeItems(),
    onChanged: (value) => onChange(value),
  );
}

List<DropdownMenuItem<Timeframe>> timeframeItems() {
  return Timeframe.values.map((item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item.value),
    );
  }).toList();
}
