enum TrendType {
  macd('MACD'),
  rsi('RSI'),
  candle('CANDLE');

  final String value;

  const TrendType(this.value);

  static TrendType fromString(String str) {
    return TrendType.values.where((element) => element.value == str).first;
  }
}
