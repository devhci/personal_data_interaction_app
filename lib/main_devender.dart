import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:personal_data_interaction_app/firebase/DB.dart';
//import 'package:personal_data_interaction_app/testFB.dart';

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
      //home: new MyHomePage(title: 'Flutter Calendar Carousel Example'),
      // home: new TestClass(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  String itemName;

  DateTime firstDate, lastDate;

  List<DateTime> listDates = List<DateTime>();

  _MyHomePageState(this.itemName);
  Util util = Util();
  DB _db = DB();
  DateTime _currentDate = new DateTime.now();
  DateTime _currentDate2 = new DateTime.now();
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
    util
        .giveListOfDateForCalenderVisualization(
            "koriawas@dtu.dk", this.itemName)
        .then((list) {
      print("inside listDate" + list.toString());

      for (var v in list) {
        var formatter = new DateFormat('yyyy-MM-dd');

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
    });

    /*List<String> fDate = list.removeAt(0).split("-");

      this.firstDate = new DateTime(
          int.parse(fDate[0]), int.parse(fDate[1]), int.parse(fDate[2]));

      List<String> lDate = list.removeLast().split("-");

      this.lastDate = new DateTime(
          int.parse(lDate[0]), int.parse(lDate[1]), int.parse(lDate[2]));
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
       */ /* this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));*/ /*
      },

      //todayButtonColor: Colors.red,
      todayBorderColor: Colors.white70,
      weekendTextStyle: TextStyle(
        color: Colors.black12,
         // fontSize: 5
      ),
     // nextMonthDayBorderColor: Colors.green,
      //thisMonthDayBorderColor: Colors.grey,
      showWeekDays: true,
      weekFormat: false,
      weekdayTextStyle: TextStyle(color: Colors.black, fontSize: 15),
      daysTextStyle:TextStyle(color: Colors.black12) ,
      showHeaderButton:true,

      minSelectedDate: ,

      markedDatesMap: _markedDateMap,
      height: 400.0,
      selectedDateTime: _currentDate2,

      /// Color of current date
      selectedDayBorderColor: Colors.green ,
        inactiveDaysTextStyle:TextStyle(color: Colors.black12),
       leftButtonIcon: FlatButton(onPressed: () => print("hello devender"), child: Container()),



      iconColor: Colors.black,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
    //  minSelectedDate: _currentDate,
     // maxSelectedDate: _currentDate.add(Duration(days: 60)),
      todayTextStyle: TextStyle(
        color: Colors.red,
      ),
      markedDateIconBuilder: (event) {
        return event.icon;
      },
     // todayBorderColor: Colors.green,
      markedDateMoreShowTotal: false,
    );*/

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      //todayBorderColor: Colors.green,
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
      todayButtonColor: Colors.green,
      selectedDayButtonColor: Colors.white70,
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
                        fontSize: 24.0,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ),
            ],
          ),
        ));
  }
}
