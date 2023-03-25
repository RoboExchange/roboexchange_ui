import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:roboexchange_ui/constant.dart';
import 'package:roboexchange_ui/model/add_trend_line_modal.dart';
import 'package:roboexchange_ui/responsive/desktop_scaffold.dart';
import 'package:roboexchange_ui/responsive/mobile_scaffold.dart';
import 'package:roboexchange_ui/responsive/responsive_layout.dart';
import 'package:roboexchange_ui/responsive/tablet_scaffold.dart';

class TrendLineListPage extends StatefulWidget {
  const TrendLineListPage({Key? key}) : super(key: key);

  @override
  State<TrendLineListPage> createState() => _TrendLineListPageState();
}

class _TrendLineListPageState extends State<TrendLineListPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MobileScaffold(body: PageContent(showAppBar: false,)),
      tabletScaffold: TabletScaffold(body: PageContent(showAppBar: false,),),
      desktopScaffold: DesktopScaffold(body: PageContent(showAppBar: true,)),
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
    fetchAllTrendLines();
  }

  Future<void> _updateTable() async {
    setState(() {
      isLoading = true;
    });
    fetchAllTrendLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Column(
        children: [
          Visibility(
            visible: widget.showAppBar,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppBar(
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.logout))
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Visibility(
                  visible: isLoading,
                  replacement: RefreshIndicator(
                    onRefresh: fetchAllTrendLines,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
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
    );
  }

  Future<void> fetchAllTrendLines() async {
    var url = '$serverBaseUrl/api/v1/trend-line/list';
    var uri = Uri.parse(url);

    final token = await storage.read(key: 'token');
    final headers = {'Authorization': '$token'};
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
      var type = tl['type'] ?? " ";
      var x1 = tl['x1'] != null ? tl['x1'].toString() : " ";
      var x2 = tl['x2'] != null ? tl['x2'].toString() : " ";
      var y1 = tl['y1'] != null ? tl['y1'].toString() : " ";
      var y2 = tl['y2'] != null ? tl['y2'].toString() : " ";
      var dataRow = DataRow(cells: [
        DataCell(Text(id)),
        DataCell(Text(symbol)),
        DataCell(Text(timeframe)),
        DataCell(Text(type)),
        DataCell(Text(formatDateTime(DateTime.parse(x1)))),
        DataCell(Text(y1)),
        DataCell(Text(formatDateTime(DateTime.parse(x2)))),
        DataCell(Text(y2)),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () => deleteTrendLine(id),
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () => {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AddTrendLineModal(
                          updateTableFunction: _updateTable, item: tl);
                    })
              },
              icon: Icon(Icons.edit),
            ),
          ],
        )),
      ]);
      listRows.add(dataRow);
    }
    return listRows;
  }

  Future<void> deleteTrendLine(id) async {
    var url = '$serverBaseUrl/api/v1/trend-line/$id';
    var uri = Uri.parse(url);
    var response = await http.delete(uri);
    if (response.statusCode == 200) {
      var filtered = trendLines
          .where((element) => element['id'].toString() != id)
          .toList();
      setState(() {
        trendLines = filtered;
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute}";
  }
}
