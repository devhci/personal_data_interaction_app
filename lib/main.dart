import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:personal_data_interaction_app/firebase/DB.dart';
import 'package:personal_data_interaction_app/testFB.dart';

import 'package:personal_data_interaction_app/util/util.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'dooboolab flutter calendar',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: new MyHomePage(title: 'Flutter Calendar Carousel Example'),
      home: new TestClass(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Util util = Util();
  DB _db = DB();
  DateTime _currentDate = DateTime(2019, 4, 17);
  DateTime _currentDate2 = DateTime(2019, 4, 17);
  String _currentMonth = '';

  static Widget _eventIcon = new Container(
      decoration: new BoxDecoration(
    color: Color.fromRGBO(156, 158, 222, .5),
    shape: BoxShape.rectangle,

    /*  gradient: new LinearGradient(
          colors: [Colors.red, Colors.cyan],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft
      ),*/

    /*child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),*/
  ));

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    util.giveListOfDateForCalenderVisualization().then((list) {
      print("inside listDate" + list.toString());

      for (var v in list) {
        var formatter = new DateFormat('yyyy-MM-dd');

        print(v);

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
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
      showWeekDays: true,
      weekFormat: false,
      weekdayTextStyle: TextStyle(color: Colors.black, fontSize: 15),
      markedDatesMap: _markedDateMap,
      height: 500.0,
      selectedDateTime: _currentDate2,
      iconColor: Colors.black,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal: false,
    );

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(color: Colors.white, fontSize: 3),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal: false,
      // daysTextStyle: TextStyle(fontSize: 25),
      showHeader: true,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate,
      maxSelectedDate: _currentDate.add(Duration(days: 60)),
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
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarousel,
              ),
            ],
          ),
        ));
  }
}
