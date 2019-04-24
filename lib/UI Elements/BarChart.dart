import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'MyColors.dart';
import '../Aspect.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Aspect> aspects;

  @override
  initState() {
    // TODO: download aspects
    aspects = [
      Aspect("Did I go climbing?", 10, Colors.redAccent),
      Aspect("I didn't use my phone before going to bed", 8, Colors.deepPurpleAccent),
      Aspect("Did I have a good meal today?", 27, Colors.greenAccent),
    ];
    super.initState();
  }

  Widget bar(Aspect aspect) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: aspect.count,
        itemBuilder: (BuildContext context, int index) {
          if (index == aspect.count - 1) {
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
                    child: Text(aspect.count.toString()),
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
    return Container(
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
        ));
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
