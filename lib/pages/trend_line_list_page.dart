import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:roboexchange_ui/components/appbar.dart';
import 'package:roboexchange_ui/constant.dart';
import 'package:roboexchange_ui/model/add_trend_line_modal.dart';
import 'package:roboexchange_ui/model/confirmation_dialog.dart';
import 'package:roboexchange_ui/responsive/desktop_scaffold.dart';
import 'package:roboexchange_ui/responsive/mobile_scaffold.dart';
import 'package:roboexchange_ui/responsive/responsive_layout.dart';
import 'package:roboexchange_ui/responsive/tablet_scaffold.dart';
import 'package:roboexchange_ui/service/auth_service.dart';

class TrendLineListPage extends StatefulWidget {
  const TrendLineListPage({Key? key}) : super(key: key);

  @override
  State<TrendLineListPage> createState() => _TrendLineListPageState();
}

class _TrendLineListPageState extends State<TrendLineListPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MobileScaffold(
          body: PageContent(
            showAppBar: false,
          )),
      tabletScaffold: TabletScaffold(
        body: PageContent(
          showAppBar: false,
        ),
      ),
      desktopScaffold: DesktopScaffold(
          body: PageContent(
            showAppBar: true,
          )),
    );
  }
}

class PageContent extends StatefulWidget {
  final bool showAppBar;

  const PageContent({Key? key, required this.showAppBar}) : super(key: key);

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  var storage = const FlutterSecureStorage();
  List trendLines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrendLines(true);
  }

  Future<void> _updateTable() async {
    setState(() {
      isLoading = true;
    });
    fetchTrendLines(true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: Column(
          children: [
            Visibility(
              visible: widget.showAppBar,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomAppBar.getAppBar(context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      TabBar(
                        unselectedLabelColor: Colors.black38,
                        padding: EdgeInsets.all(5),
                        indicator: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onTap: (selectedIndex) {
                          setState(() {
                            isLoading = true;
                          });
                          switch (selectedIndex) {
                            case 0:
                              fetchTrendLines(true);
                              break;
                            case 1:
                              fetchTrendLines(false);
                          }
                        },
                        tabs: const [
                          Tab(
                            text: "Active",
                            icon: Icon(Icons.check),
                          ),
                          Tab(
                            text: "Need Update",
                            icon: Icon(Icons.update),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Visibility(
                          visible: isLoading,
                          replacement: RefreshIndicator(
                            onRefresh: () => fetchTrendLines(true),
                            child: TabBarView(
                              children: [
                                trendLineTable(true),
                                trendLineTable(false),
                              ],
                            ),
                          ),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              showDialog(
                context: context,
                builder: (_) {
                  return AddTrendLineModal(
                    item: null,
                    updateTableFunction: _updateTable,
                  );
                },
              ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Column trendLineTable(bool isValid) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Visibility(
                visible: isLoading,
                replacement: RefreshIndicator(
                  onRefresh: () => fetchTrendLines(isValid),
                  child: LayoutBuilder(
                    builder: (context, constraint) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                          BoxConstraints(minWidth: constraint.maxWidth),
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("id")),
                              DataColumn(label: Text("symbol")),
                              DataColumn(label: Text("last update")),
                              DataColumn(label: Text("timeframe")),
                              DataColumn(label: Text("type")),
                              DataColumn(label: Text("x1")),
                              DataColumn(label: Text("y1")),
                              DataColumn(label: Text("x2")),
                              DataColumn(label: Text("y2")),
                              DataColumn(label: Text("actions")),
                            ],
                            rows: fillTableRows(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> fetchTrendLines(bool isValid) async {
    var url = '/api/v1/trend-line/list';
    var queryParameters = {"isValid": isValid.toString()};
    var uri = Uri.https(serverBaseUrl, url, queryParameters);
    var token = await AuthService.getToken();
    var headers = {'Authorization': '$token'};
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      setState(() {
        trendLines = json["data"] as List;
        isLoading = false;
      });
    } else if (response.statusCode == 401 && context.mounted) {
      Navigator.of(context).pushNamed("/login");
    }
  }

  List<DataRow> fillTableRows() {
    List<DataRow> listRows = [];
    for (var tl in trendLines) {
      var id = tl['id'].toString();
      var symbol = tl['symbol'] ?? " ";
      var timeframe = tl['timeframe'] ?? " ";
      var lastUpdateTime = tl['lastUpdateTime'].toString();
      var type = tl['type'] ?? " ";
      var x1 = tl['x1'].toString();
      var x2 = tl['x2'].toString();
      var y1 = tl['y1'].toString();
      var y2 = tl['y2'].toString();
      var isEnable = tl['enable'];
      var dataRow = DataRow(cells: [
        DataCell(Text(id)),
        DataCell(Text(symbol)),
        DataCell(Text(formatDateTime(DateTime.parse(lastUpdateTime)))),
        DataCell(Text(timeframe)),
        DataCell(Text(type)),
        DataCell(Text(formatDateTime(DateTime.parse(x1)))),
        DataCell(Text(y1)),
        DataCell(Text(formatDateTime(DateTime.parse(x2)))),
        DataCell(Text(y2)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteTrendLine(id),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () =>
              {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AddTrendLineModal(
                          updateTableFunction: _updateTable, item: tl);
                    })
              },
            ),
            Checkbox(
              value: isEnable,
              onChanged: (value) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return ConfirmationDialog(
                        confirm: value,
                        title: Text('Confirmation'),
                        description:
                        Text(
                            "Change trendline status of symbol $symbol.\nAre you sure?"),
                        onSubmit: () {
                          changeStatus(id, value);
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        },
                      );
                    });
              },
            )
          ],
        )),
      ]);
      listRows.add(dataRow);
    }
    return listRows;
  }

  Future<void> deleteTrendLine(id) async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.https(serverBaseUrl, '/api/v1/trend-line/$id');
    var token = await AuthService.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var response = await http.delete(uri, headers: headers);
    if (response.statusCode == 200) {
      var filtered = trendLines
          .where((element) => element['id'].toString() != id)
          .toList();
      setState(() {
        trendLines = filtered;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> changeStatus(id,isEnable) async {
    setState(() {
      isLoading = true;
    });

    var reqParameters = {
      'id': id.toString(),
      'enable': isEnable.toString(),
    };
    var uri = Uri.https(serverBaseUrl, '/api/v1/trend-line/status', reqParameters);
    var token = await AuthService.getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var filtered = trendLines
          .where((element) => element['id'].toString() != id)
          .toList();
      setState(() {
        trendLines = filtered;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime
        .hour}:${dateTime.minute}";
  }
}
