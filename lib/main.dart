import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:personal_data_interaction_app/firebase/DB.dart';

import 'package:personal_data_interaction_app/util/db_read_write.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'dooboolab flutter calendar',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Montlhy Viz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DB _db = DB();
  DateTime _currentDate = DateTime(2019, 2, 3);
  DateTime _currentDate2 = DateTime(2019, 2, 3);
  String _currentMonth = '';
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.red.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(1500)),
        border: Border.all(color: Colors.blue, width: 0.5)),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    ///
    ///

    ///

    Firestore.instance
        .collection('auto-id')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => print(doc)));

    HashMap<String, dynamic> map = HashMap<String, dynamic>();

    /* Map<String, Object> data1 = new HashMap<>();
    data1.put("name", "San Francisco");
    data1.put("state", "CA");
    data1.put("country", "USA");
    data1.put("capital", false);
    data1.put("population", 860000);
    data1.put("regions", ;*/

    List dtLst = new List();

    dtLst.add(Timestamp.now());

    map["timestemp"] = dtLst;

    /*Firestore Firestore.instance.runTransaction((Transaction tx) async {
      */ /*DocumentSnapshot snapshot =
      (await Firestore.instance
          .collection('auto-id')
          .snapshots()) as DocumentSnapshot;
      var doc = snapshot.data;*/ /*

      return transaction.get(userRef).then(doc => {
      if (!doc.data().bookings) {
      transaction.set({
      bookings: [booking]
      });
      } else {
      const bookings = doc.data().bookings;
      bookings.push(booking);
      transaction.update(userRef, { bookings: bookings });
      }
      });


   //   DocumentReference washingtonRef = doc.doc ("cities");

      if (doc['Social'].contains("timestemp")) {
        await tx.update(snapshot.reference, <String, dynamic>{
          'timestemp': FieldValue.arrayUnion(["A","B"])
        });

      }
    });*/

    HashMap<String, dynamic> update = HashMap<String, dynamic>();
    update["timestemp"] = dtLst;

    //print(Firestore.instance.collection('auto-id').document("Social").setData(update,merge: true));

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

  /*  final DocumentReference postRef =
        Firestore.instance.collection('auto-id').document('Social');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.data.containsKey("timestemp")) {
        await tx.update(postRef, <String, dynamic>{
          'timestemp': FieldValue.arrayRemove([formatter.format(now)])
        });
      }
    });*/

    final DocumentReference postRef = Firestore.instance.collection('auto-id').document('Social');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.data.containsKey("timestemp")) {
        await tx.update(postRef, <String, dynamic>{'timestemp': FieldValue.arrayUnion([formatter.format(now)+7.toString()])});
      }
    });


    //_db.deleteItem("Social");

    _db.createNewItem("Social");

    for (int i = 0; i < 25; i++) {
      i = i + 1;
      _markedDateMap.add(
          new DateTime(2019, 2, 3 + i),
          new Event(
            date: new DateTime(2019, 2, 3 + i),
            title: 'Event 5',
            icon: _eventIcon,
          ));
    }

    super.initState();
  }

  _create() async {
    var file = new File('db.json');

    file.writeAsString("contents");
  }

  Future<String> _read() async {
    _create();
    String text;
    try {
      final directory = await getApplicationDocumentsDirectory();

      final file = File('${directory.path}/db.json');
      text = await file.readAsString();

      print("text" + text);
    } catch (e) {
      final directory = await getApplicationDocumentsDirectory();
      print("directory=" '${directory.path}/');
      print("Couldn't read file");
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal:
          false, // null for not showing hidden events indicator
      showHeader: false,
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
//      inactiveDateColor: Colors.black12,
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
              //custom icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarousel,
              ), // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                    FlatButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          _currentDate2 =
                              _currentDate2.subtract(Duration(days: 30));
                          _currentMonth =
                              DateFormat.yMMM().format(_currentDate2);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        setState(() {
                          _currentDate2 = _currentDate2.add(Duration(days: 30));
                          _currentMonth =
                              DateFormat.yMMM().format(_currentDate2);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ), //
            ],
          ),
        ));
  }
}
