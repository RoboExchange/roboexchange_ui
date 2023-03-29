import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roboexchange_ui/components/dropdown_timeframe.dart';
import 'package:roboexchange_ui/constant.dart';
import 'package:roboexchange_ui/service/auth_service.dart';

class AddTrendLineModal extends StatefulWidget {
  final Function updateTableFunction;
  final Map? item;

  const AddTrendLineModal(
      {Key? key, required this.updateTableFunction, required this.item})
      : super(key: key);

  @override
  State<AddTrendLineModal> createState() => _AddTrendLineModalState();
}

class _AddTrendLineModalState extends State<AddTrendLineModal> {
  String selectedTimeframe = "FOUR_HOUR";

  bool isUpdate = false;
  var currentDate = DateTime.now();
  var currentTime = TimeOfDay.now();
  DateTime x1DateTime = DateTime.now();
  DateTime x2DateTime = DateTime.now();

  TextEditingController symbolController = TextEditingController();
  TextEditingController y1Controller = TextEditingController();
  TextEditingController y2Controller = TextEditingController();
  late int id;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      isUpdate = true;
      id = item["id"];
      symbolController.text = item["symbol"];
      y1Controller.text = item['y1'].toString();
      y2Controller.text = item['y2'].toString();
      x1DateTime = DateTime.parse(item['x1']);
      x2DateTime = DateTime.parse(item['x2']);
    }
  }

  @override
  Widget build(BuildContext context) {
    String x1DateStr =
        "${x1DateTime.year}/${x1DateTime.month}/${x1DateTime.day}  ${x1DateTime.hour}:${x1DateTime.minute}";
    String x2DateStr =
        "${x2DateTime.year}/${x2DateTime.month}/${x2DateTime.day}  ${x2DateTime.hour}:${x2DateTime.minute}";
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              if (isUpdate) {
                updateItem()
                    .then((value) => Navigator.of(context, rootNavigator: true)
                        .pop('dialog'))
                    .then((value) => widget.updateTableFunction());
              } else {
                addItem()
                    .then((value) => Navigator.of(context, rootNavigator: true)
                        .pop('dialog'))
                    .then((value) => widget.updateTableFunction());
              }
            },
            child: Text(isUpdate ? "Update" : "Add"))
      ],
      scrollable: true,
      title: Text(isUpdate ? "Update Item" : "Add Item"),
      content: Form(
        child: Column(
          children: [
            TextFormField(
              controller: symbolController,
              decoration: InputDecoration(labelText: "Symbol"),
            ),
            DropDownTimeframes(
                selectedTimeframe: selectedTimeframe,
                onChange:(String? value) {
                  setState(() {
                    selectedTimeframe = value!;
                  });
                },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => chooseDateTime(true),
                  child: Text(x1DateStr),
                ),
              ),
            ),
            TextFormField(
              controller: y1Controller,
              decoration: InputDecoration(labelText: "Y1 value"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => chooseDateTime(false),
                  child: Text(x2DateStr),
                ),
              ),
            ),
            TextFormField(
              controller: y2Controller,
              decoration: InputDecoration(labelText: "Y1 value"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseDateTime(bool isX1) async {
    var date = await pickDate();
    var time = await pickTime();

    if (date == null || time == null) return;

    if (isX1) {
      setState(() {
        x1DateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    } else {
      setState(() {
        x2DateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: x1DateTime,
      firstDate: DateTime(currentDate.year - 10),
      lastDate: DateTime(currentDate.year + 10));

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: currentTime);

  Future<void> addItem() async {
    var token = await AuthService.getToken();
    var data = {
      "symbol": symbolController.text,
      "x1": x1DateTime.toIso8601String(),
      "y1": double.parse(y1Controller.text),
      "x2": x2DateTime.toIso8601String(),
      "y2": double.parse(y2Controller.text),
      "type": "MACD",
      "timeframe": selectedTimeframe,
      "enable": true
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var uri = Uri.https(serverBaseUrl,'/api/v1/trend-line/add');
    await http.post(uri,
        body: jsonEncode(data), headers: headers);
  }

  Future<void> updateItem() async {
    var token = await AuthService.getToken();
    var data = {
      "symbol": symbolController.text,
      "x1": x1DateTime.toIso8601String(),
      "y1": double.parse(y1Controller.text),
      "x2": x2DateTime.toIso8601String(),
      "y2": double.parse(y2Controller.text),
      "type": "MACD",
      "timeframe": selectedTimeframe,
      "enable": true
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var uri = Uri.https(serverBaseUrl,'/api/v1/trend-line/$id');
    var response =
        await http.put(uri, body: jsonEncode(data), headers: headers);
    print(response.body);
  }
}
