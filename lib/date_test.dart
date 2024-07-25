void main() {
  //tesing the date time
  DateTime now = DateTime.now();
  print(now);

  //print now but only the date withotu time
  print(now.toIso8601String().substring(0, 10));

  String date = now.toIso8601String().substring(0, 10);
  print(date);

  //reconvert the date string to a date object
  DateTime dateObj = DateTime.parse(date);
  print(dateObj);
}
