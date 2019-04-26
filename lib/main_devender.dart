import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:personal_data_interaction_app/firebase/DB.dart';
//import 'package:personal_data_interaction_app/testFB.dart';

import 'package:personal_data_interaction_app/util/util.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.dateTime}) : super(key: key);

  final String title;
  final DateTime dateTime;

  @override
  _MyHomePageState createState() => new _MyHomePageState(title, dateTime);
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

class _MyHomePageState extends State<MyHomePage> {
  String itemName;
  DateTime dateTime;

  DateTime firstDate, lastDate;

  String color = "";

  List<DateTime> listDates = List<DateTime>();

  _MyHomePageState(this.itemName, this._currentDate2);
  Util util = Util();
  DB _db = DB();
  // DateTime _currentDate = dateTime;
  DateTime _currentDate2;
  String _currentMonth = '';

  Widget _eventIcon;

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;

  @override
  void initState() {
    util
        .giveListOfDateForCalenderVisualization(
        "koriawas@dtu.dk", this.itemName)
        .then((map) {
      List<String> list =
      map.remove("list").replaceAll("[", "").replaceAll("]", "").split(",");

      color = map.remove("color");

      print("inside listDate" + list.toString());

      this._eventIcon = new Container(
          decoration: new BoxDecoration(
            // color: Color.fromRGBO(156, 158, 222, .5),
            color: Color(int.parse(color, radix: 16)),
            shape: BoxShape.rectangle,
          ));

      for (var v in list) {
        print("dates inside init:" + v);

        List<String> date = v.toString().split("-");

        print(date[0] + " " + date[1] + " " + date[2]);

        setState(() {
          _markedDateMap.add(
              new DateTime(
                  int.parse(date[0]), int.parse(date[1]), int.parse(date[2])),
              new Event(
                date: new DateTime(
                    int.parse(date[0]), int.parse(date[1]), int.parse(date[2])),
                title: 'Event 5',
                icon: _eventIcon,
              ));

          listDates.add(new DateTime(
              int.parse(date[0]), int.parse(date[1]), int.parse(date[2])));
        });
      }
      listDates.sort();

      print("sorted List" + listDates.toString());

      print("color :" + color);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      weekendTextStyle: TextStyle(color: Colors.black, fontSize: 15),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal: false,
      isScrollable: false,
      weekdayTextStyle: TextStyle(color: Colors.black),



      //onDayPressed: null,
      nextMonthDayBorderColor: Colors.white,

      /// Removes problem of min select value

      minSelectedDate: _currentDate2,
      maxSelectedDate: _currentDate2,

      // showHeader:false,
      // daysTextStyle: TextStyle(fontSize: 25),
      showHeader: false,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayTextStyle: TextStyle(
        color: Colors.black,
      ),

      //today button
      todayButtonColor: Color.fromRGBO(255,255, 255, -2),
      selectedDayButtonColor: Color.fromRGBO(255,255, 255, -2),
      selectedDayTextStyle: TextStyle(
        color: Colors.black,
      ),
      // minSelectedDate: _currentDate,
      // maxSelectedDate: _currentDate.add(Duration(days: 60)),
      onCalendarChanged: (DateTime date) {
        this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 30.0,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Center(
                child: new Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('PREV'),
                      onPressed: () {
                        DateTime tempDate = _currentDate2;

                        DateTime dateTime = new DateTime(tempDate.year,
                            tempDate.month, (tempDate.day + 1) - tempDate.day);

                        //print(" IsBefore=? " + lis.isBefore(dateTime).toString());

                        if (listDates.first.isBefore(dateTime)) {
                          setState(() {
                            _currentDate2 =
                                _currentDate2.subtract(Duration(days: 30));
                            _currentMonth =
                                DateFormat.yMMM().format(_currentDate2);
                          });
                        } else
                          print("button Desabled ");
                      },
                    ),


                    Expanded(


                        child: Text(
                          _currentMonth,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        )),


                    FlatButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        print("LastDate" + listDates.first.toString());
                        if (listDates.last.isAfter(_currentDate2)) {
                          setState(() {
                            _currentDate2 =
                                _currentDate2.add(Duration(days: 30));
                            _currentMonth =
                                DateFormat.yMMM().format(_currentDate2);
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarouselNoHeader,
            ),
          ],
        ),
      ),
    );
  }
}
