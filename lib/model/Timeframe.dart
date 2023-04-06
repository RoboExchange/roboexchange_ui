
enum Timeframe {
  none(''),
  fiveMinute('FIVE_MINUTE'),
  fifteenMinute('FIFTEEN_MINUTE'),
  oneHour('ONE_HOUR'),
  fourHour('FOUR_HOUR'),
  oneDay('ONE_DAY'),
  oneWeek('ONE_WEEK');

  final String value;
  const Timeframe(this.value);

  static Timeframe fromString(String str) {
    return Timeframe.values.where((element) => element.value == str).first;
  }
}