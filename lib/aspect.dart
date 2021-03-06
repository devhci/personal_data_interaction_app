import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/util/util.dart';

class Aspect {
  String name;
  Color color;
  List<DateTime> dates = [];
  DateTime deleteDate;
  DateTime createDate;

  Aspect({
    @required String name,
    @required List<dynamic> stringDates,
    @required String stringColor,
    @required String stringDeleteDate,
    @required String stringCreateDate,
  }) {
    this.name = name;

    this.color = Color(int.parse(stringColor, radix: 16));

    if (stringDeleteDate == "") {
      deleteDate = null;
    } else {
      this.deleteDate = util.formatter.parse(stringDeleteDate);
    }

    this.createDate = util.formatter.parse(stringCreateDate);

    for (dynamic date in stringDates) {
      date = date.toString();
      this.dates.add(util.formatter.parse(date));
    }
  }
}
