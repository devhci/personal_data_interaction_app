import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/aspect.dart';
import 'package:personal_data_interaction_app/util/util.dart';
import 'package:personal_data_interaction_app/main_devender.dart';
import 'dart:async';
import 'package:personal_data_interaction_app/blocs.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Aspect> aspects = [];
  DateTime date;
  bool _loading;
  StreamSubscription<DateTime> dateSubscription;

  void getAllData() async {
    util.getAllData(Util.username).then((allData) {
      setState(() {
        _loading = false;
      });
      for (var aspect in allData) {
        Aspect a = Aspect(
          name: aspect['name'],
          stringDates: aspect['listOfDates'],
          stringColor: aspect['color'],
          stringDeleteDate: aspect['delete_date'],
          stringCreateDate: aspect['create_date'],
        );
        setState(() {
          aspects.add(a);
        });
      }
    });
  }

  @override
  initState() {
    date = DateTime.now();
    dateSubscription = bloc.date.listen((newDate) {
      setState(() {
        date = newDate;
      });
    });

    _loading = true;
    // TODO: download aspects
    getAllData();

    super.initState();
  }

  @override
  void dispose() {
    dateSubscription.cancel();
    super.dispose();
  }

  Widget bar(int count, Color aspectColor) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: count, //aspect.dates.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == count - 1) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: (MediaQuery.of(context).size.width - 80) / 31,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)), color: aspectColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(count.toString()),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 100) / 31,
                decoration: BoxDecoration(color: aspectColor),
              ),
            );
          }
        },
      ),
    );
  }

  Widget barCellBuilder(BuildContext context, int index) {
    int count = 0;

    for (DateTime aspectDate in aspects[index].dates) {
      if (aspectDate.month == this.date.month && aspectDate.year == this.date.year) {
        count++;
      }
    }

    if (count == 0) {
      // If there are no dates in the given month
      return Container();
    }

    return GestureDetector(
//      onTap: () {
//        Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (context) => MyHomePage(
//                  title: aspects[index].name,
//                  dateTime: date,
//                ),
//          ),
//        );
//      },
      child: Container(
          height: 80,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment(-1, 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    aspects[index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              bar(count, aspects[index].color),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Divider(
                  height: 1,
                ),
              )
            ],
          )),
    );
  }

  Widget barChart(List<Aspect> aspects) {
    return ListView.builder(
      itemBuilder: barCellBuilder,
      itemCount: aspects.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.darkBlue)))
        : barChart(aspects);
  }
}
