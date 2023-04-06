import 'package:flutter/material.dart';
import 'package:roboexchange_ui/components/dropdown_timeframe.dart';
import 'package:roboexchange_ui/dialog/add_trend_line_dialog.dart';
import 'package:roboexchange_ui/dialog/confirmation_dialog.dart';
import 'package:roboexchange_ui/model/Timeframe.dart';
import 'package:roboexchange_ui/model/TrendLine.dart';
import 'package:roboexchange_ui/responsive/desktop_scaffold.dart';
import 'package:roboexchange_ui/responsive/mobile_scaffold.dart';
import 'package:roboexchange_ui/responsive/responsive_layout.dart';
import 'package:roboexchange_ui/responsive/tablet_scaffold.dart';
import 'package:roboexchange_ui/service/trend_service.dart';
import 'package:roboexchange_ui/utils.dart';

class TrendLineListPage extends StatefulWidget {
  const TrendLineListPage({Key? key}) : super(key: key);

  @override
  State<TrendLineListPage> createState() => _TrendLineListPageState();
}

class _TrendLineListPageState extends State<TrendLineListPage> {
  final String pageTitle = 'Trends';

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: MobileScaffold(
        body: PageContent(
          showAppBar: false,
        ),
        title: pageTitle,
      ),
      tabletScaffold: TabletScaffold(
        body: PageContent(
          showAppBar: false,
        ),
        title: pageTitle,
      ),
      desktopScaffold: DesktopScaffold(
        body: PageContent(
          showAppBar: true,
        ),
        title: pageTitle,
      ),
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
  final ScrollController _horizontal = ScrollController();

  List<TrendLine> trendLines = [];

  bool isLoading = true;

  Timeframe? filterTimeframe = Timeframe.none;
  TextEditingController filterSymbolController = TextEditingController();
  bool showValidItems = true;

  @override
  void initState() {
    super.initState();
    fetchTrendLines();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AddTrendLineModal(
                                item: null,
                                updateTableFunction: fetchTrendLines,
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add'),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: filterSymbolController,
                          decoration: InputDecoration(
                            label: Text('Search'),
                          ),
                          onChanged: (value) => fetchTrendLines(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 160,
                          child: timeFrameDropDown(
                            filterTimeframe ?? Timeframe.none,
                                (timeframe) =>
                            {
                              setState(() {
                                filterTimeframe = timeframe;
                              }),
                              fetchTrendLines()
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: CheckboxListTile(
                            value: showValidItems ,
                            title: Text('Only Valid'),
                            onChanged: (value) {
                              setState(() {
                                showValidItems = value ?? true;
                              });
                              fetchTrendLines();
                            }
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: isLoading,
                    replacement: RefreshIndicator(
                      onRefresh: () {
                        return fetchTrendLines();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Scrollbar(
                          controller: _horizontal,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _horizontal,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: tableColumns(),
                              rows: tableRows(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> tableColumns() {
    return const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Symbol')),
      DataColumn(label: Text('Last Update')),
      DataColumn(label: Text('Timeframe')),
      DataColumn(label: Text('type')),
      DataColumn(label: Text('X1')),
      DataColumn(label: Text('Y1')),
      DataColumn(label: Text('X2')),
      DataColumn(label: Text('Y2')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> tableRows() {
    List<DataRow> rowList = [];
    for (var item in trendLines) {
      var row = DataRow(
        cells: [
          DataCell(Text(item.id.toString())),
          DataCell(Text(item.symbol)),
          DataCell(Text(item.timeframe.value)),
          DataCell(Text(formatDateTime(item.lastUpdateTime))),
          DataCell(Text(item.type.value)),
          DataCell(Text(item.x1.toString())),
          DataCell(Text(item.y1.toString())),
          DataCell(Text(item.x2.toString())),
          DataCell(Text(item.y2.toString())),
          DataCell(
            Row(
              children: [
                IconButton(onPressed: () => deleteTrendLine(item.id),
                    icon: Icon(Icons.delete)),
                IconButton(onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AddTrendLineModal(
                          updateTableFunction: fetchTrendLines,
                          item: item,
                        );
                      });
                }, icon: Icon(Icons.edit)),
                Checkbox(
                  value: item.isValid,
                  onChanged: (bool? value) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ConfirmationDialog(
                            confirm: value,
                            title: Text('Confirmation'),
                            description: Text(
                                "Change trendline status of symbol ${item
                                    .symbol}.\nAre you sure?"),
                            onSubmit: () {
                              changeStatus(item.id, value);
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          );
                        });
                  },
                )
              ],
            ),
          ),
        ],
      );
      rowList.add(row);
    }
    return rowList;
  }

  Future<void> fetchTrendLines() async {
    setState(() {
      isLoading = true;
    });
    var symbol = filterSymbolController.text;
    var fetchTrendLines = await TrendService.fetchTrendLines(
        symbol, filterTimeframe, showValidItems, true, 'id');
    setState(() {
      trendLines = fetchTrendLines;
      isLoading = false;
    });
  }

  Future<void> changeStatus(id, isEnable) async {
    setState(() {
      isLoading = true;
    });

    var success = await TrendService.changeStatus(id, isEnable);
    if (success) {
      var filtered = trendLines.where((item) => item.id != id).toList();
      setState(() {
        trendLines = filtered;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTrendLine(id) async {
    setState(() {
      isLoading = true;
    });

    var success = await TrendService.deleteTrendLine(id);
    if (success) {
      var filtered = trendLines
          .where((item) => item.id != id)
          .toList();
      setState(() {
        trendLines = filtered;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

}
