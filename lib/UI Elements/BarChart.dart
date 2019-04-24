import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'MyColors.dart';
import '../Aspect.dart';
import 'package:personal_data_interaction_app/util/util.dart';
import 'package:personal_data_interaction_app/main_devender.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Aspect> aspects = [];

  void getAllData() async {
    util.getAllData("koriawas@dtu.dk").then((allData) {
      for (var aspect in allData) {
        Aspect a = Aspect(aspect['name'], aspect['listOfDates'], aspect['color']);
        setState(() {
          aspects.add(a);
        });
      }
    });
  }

  @override
  initState() {
    // TODO: download aspects
    getAllData();

    super.initState();
  }

  Widget bar(Aspect aspect) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: aspect.dateTimeDates.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == aspect.dateTimeDates.length - 1) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: (MediaQuery.of(context).size.width - 80) / 31,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)), color: aspect.color),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(aspect.dateTimeDates.length.toString()),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 100) / 31,
                decoration: BoxDecoration(color: aspect.color),
              ),
            );
          }
        },
      ),
    );
  }

  Widget barCell(BuildContext context, int index) {
    return FlatButton(
      onPressed: () {
        // TODO: navigate to calendar view with this "aspects[index].name"
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: aspects[index].name,
                )));
      },
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
              bar(aspects[index]),
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
      itemBuilder: barCell,
      itemCount: aspects.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return barChart(aspects);
  }
}
