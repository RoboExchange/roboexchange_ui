import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:roboexchange_ui/constant.dart';
import 'package:roboexchange_ui/model/Timeframe.dart';
import 'package:roboexchange_ui/model/TrendLine.dart';

class TrendService {
  static const storage = FlutterSecureStorage();
  static String baseURL = '/api/v1/trend-line';

  /*
  * fetch trend lines
  * */
  static Future<List<TrendLine>> fetchTrendLines(
      String? symbol,
      Timeframe? timeframe,
      bool isValid,
      bool isAscend,
      String? orderBy) async {
    var token = await storage.read(key: 'token');
    String url = '$baseURL/list';
    var headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json'
    };
    var queryParams = <String, String>{"ascend": "true", "orderBy": "id"};
    if (isValid) queryParams.putIfAbsent("isValid", () => isValid.toString());
    if (symbol != null) queryParams.putIfAbsent("symbol", () => symbol);
    if (timeframe != null) {
      queryParams.putIfAbsent("timeframe", () => timeframe.value);
    }
    if (isAscend) queryParams.putIfAbsent("ascend", () => isAscend.toString());
    if (orderBy != null) queryParams.putIfAbsent("orderBy", () => orderBy);

    var uri = Uri.https(serverBaseUrl, url, queryParams);
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      var dataList = json['data'] as List;
      return dataList.map((e) => TrendLine.fromObject(e)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }
    return List.empty();
  }

  /*
  * Change trend status
  * */
  static Future<bool> changeStatus(id, isEnable) async {
    var token = await storage.read(key: 'token');
    String url = '$baseURL/status';
    var reqParameters = {
      'id': id.toString(),
      'enable': isEnable.toString(),
    };
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var uri = Uri.https(serverBaseUrl, url, reqParameters);
    var response = await http.get(uri, headers: headers);
    return response.statusCode == 200;
  }

  /*
  * Delete trend line
  * */
  static Future<bool> deleteTrendLine(id) async {
    var token = await storage.read(key: 'token');
    String url = '$baseURL/$id';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var uri = Uri.https(serverBaseUrl, url);
    var response = await http.delete(uri, headers: headers);
    return response.statusCode == 200;
  }

  /*
  * Add trend line
  * */
  static Future<bool> addItem(TrendLine trendLine) async {
    var token = await storage.read(key: 'token');
    String url = '$baseURL/add';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };

    var body = trendLine.toMap();

    var uri = Uri.https(serverBaseUrl, url);
    var response = await http.post(uri, body: jsonEncode(body), headers: headers);
    print('[INFO] Add item ${trendLine.symbol} ${trendLine.timeframe.value} ${trendLine.type.value} ${trendLine.isValid}');
    if (response.statusCode != 200) {
      print('[ERROR] ${response.statusCode} ${response.body}');
    }
    return response.statusCode == 200;
  }

  static Future<bool> updateItem(id, TrendLine trendLine) async {
    var token = await storage.read(key: 'token');
    String url = '$baseURL/$id';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };
    var body = jsonEncode(trendLine.toMap());
    var uri = Uri.https(serverBaseUrl, url);
    var response = await http.put(uri, body: body, headers: headers);
    print('[INFO] Update item $id ${trendLine.symbol} ${trendLine.timeframe.value} ${trendLine.type.value} ${trendLine.isValid}');
    if (response.statusCode != 200) {
      print('[ERROR] ${response.statusCode} ${response.body}');
    }
    return response.statusCode == 200;
  }
}
