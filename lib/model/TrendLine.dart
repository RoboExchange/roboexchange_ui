import 'package:roboexchange_ui/model/Timeframe.dart';
import 'package:roboexchange_ui/model/TrendType.dart';

class TrendLine {
  final int? id;
  final String symbol;
  final DateTime lastUpdateTime;
  final Timeframe timeframe;
  final TrendType type;
  final DateTime x1;
  final double y1;
  final DateTime x2;
  final double y2;
  final bool? isValid;

  const TrendLine(this.id, this.symbol, this.lastUpdateTime, this.timeframe,
      this.type, this.x1, this.y1, this.x2, this.y2, this.isValid);

  factory TrendLine.fromObject(Map map) {
    return TrendLine(
        map['id'],
        map['symbol'],
        DateTime.parse(map['lastUpdateTime']),
        Timeframe.fromString(map['timeframe']),
        TrendType.fromString(map['type']),
        DateTime.parse(map['x1']),
        map['y1'],
        DateTime.parse(map['x2']),
        map['y2'],
        map['valid']);
  }

  Map<String, dynamic> toMap() => {
        "symbol": symbol,
        "lastUpdateTime": lastUpdateTime.toIso8601String(),
        "timeframe": timeframe.value,
        "type": type.value,
        "x1": x1.toIso8601String(),
        "y1": y1,
        "x2": x2.toIso8601String(),
        "y2": y2,
      };
}
