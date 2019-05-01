import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/util/util.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import 'dart:async';

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title, this.dateTime}) : super(key: key);

  final String title;
  final DateTime dateTime;

  @override
  _CalendarState createState() => new _CalendarState(title, dateTime);
}

class _CalendarState extends State<Calendar> {
  String itemName;
  DateTime dateTime;
  DateTime firstDate, lastDate;
  String color = "";
  List<DateTime> listDates = List<DateTime>();
  DateTime _currentDate2;
  Widget _eventIcon;
  CalendarCarousel _calendarCarouselNoHeader;
  StreamSubscription<DateTime> dateSubscription;

  _CalendarState(this.itemName, this._currentDate2);

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    _currentDate2 = DateTime.now();
    dateSubscription = bloc.date.listen((newDate) {
      setState(() {
        _currentDate2 = newDate;
      });
    });

    util.giveListOfDateForCalenderVisualization(Util.username, this.itemName).then((map) {
      List<String> list = map.remove("list").replaceAll("[", "").replaceAll("]", "").split(",");

      color = map.remove("color");

      this._eventIcon = Container(
        decoration: BoxDecoration(
          color: Colors.transparent, //Color(int.parse(color, radix: 16)),
          border: Border.all(color: Color(int.parse(color, radix: 16)), width: 5),
          shape: BoxShape.circle,
        ),
      );

      for (var v in list) {
        List<String> date = v.toString().split("-");
        setState(() {
          _markedDateMap.add(
            new DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2])),
            new Event(
              date: new DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2])),
              title: 'Event 5',
              icon: _eventIcon,
            ),
          );

          listDates.add(new DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2])));
        });
      }
      listDates.sort();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayTextStyle: TextStyle(color: Colors.black),
      daysTextStyle: TextStyle(color: Colors.black),
      weekendTextStyle: TextStyle(color: Colors.black),
      weekdayTextStyle: TextStyle(color: Colors.black),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      selectedDateTime: _currentDate2,
      height: 300.0,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal: false,
      isScrollable: false,
      firstDayOfWeek: 1,
      onDayPressed: null,
      dayButtonColor: Colors.transparent,
      nextMonthDayBorderColor: Colors.white,
      showHeader: false,
      markedDateIconBuilder: (event) {
        return event.icon;
      },

      //today button
      todayButtonColor: null,
      selectedDayButtonColor: null,
      selectedDayTextStyle: TextStyle(color: Colors.black),
    );

    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: _calendarCarouselNoHeader,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "The circles represent the days when you did the \"$itemName\" activity",
            style: TextStyle(fontWeight: FontWeight.w300, color: MyColors.darkGrey, fontSize: 16),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    dateSubscription.cancel();
    super.dispose();
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

//            Container(
//              margin: EdgeInsets.only(
//                top: 30.0,
//                bottom: 16.0,
//                left: 16.0,
//                right: 16.0,
//              ),
//              child: Center(
//                child: new Row(
//                  children: <Widget>[
//                    FlatButton(
//                      child: Text('PREV'),
//                      onPressed: () {
//                        DateTime tempDate = _currentDate2;
//                        DateTime dateTime =
//                            new DateTime(tempDate.year, tempDate.month, (tempDate.day + 1) - tempDate.day);
//                        //print(" IsBefore=? " + lis.isBefore(dateTime).toString());
//                        if (listDates.first.isBefore(dateTime)) {
//                          setState(() {
//                            _currentDate2 = _currentDate2.subtract(Duration(days: 30));
//                            _currentMonth = DateFormat.yMMM().format(_currentDate2);
//                          });
//                        } else
//                          print("button Desabled ");
//                      },
//                    ),
//                    Expanded(
//                        child: Text(
//                      _currentMonth,
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 20.0,
//                      ),
//                    )),
//                    FlatButton(
//                      child: Text('NEXT'),
//                      onPressed: () {
//                        print("LastDate" + listDates.first.toString());
//                        if (listDates.last.isAfter(_currentDate2)) {
//                          setState(() {
//                            _currentDate2 = _currentDate2.add(Duration(days: 30));
//                            _currentMonth = DateFormat.yMMM().format(_currentDate2);
//                          });
//                        }
//                      },
//                    )
//                  ],
//                ),
//              ),
//            ),
