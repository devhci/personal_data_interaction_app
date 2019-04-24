import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Aspect {
  String name;
  Color color;
  List<DateTime> dateTimeDates = [];

  Aspect(String name, List<dynamic> stringDates, String stringColor) {
    var formatter = DateFormat('yyyy-MM-dd');

    this.name = name;

    color = Color(int.parse(stringColor, radix: 16));

    for (dynamic date in stringDates) {
      date = date.toString();
      dateTimeDates.add(formatter.parse(date));
    }
  }
}
