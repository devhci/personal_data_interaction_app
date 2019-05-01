import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import 'dart:async';

class MyAppBar extends StatefulWidget {
  final TabElement tabElement;
  MyAppBar({this.tabElement});

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final monthFormatter = DateFormat('MMMM');
  DateTime date;
  String leftButtonText;
  String rightButtonText;
  String middleText;
  Function onLeftButtonPressed;
  Function onRightButtonPressed;
  bool shouldNextButtonBeVisible;
  String headerText;

  StreamSubscription<DateTime> dateSubscription;

  @override
  void initState() {
    date = DateTime.now();
    dateSubscription = bloc.date.listen((newDate) {
      setState(() {
        date = newDate;
      });
    });

    super.initState();
  }

  Widget middle() {
    return Opacity(
      opacity: widget.tabElement == TabElement.AddDelete ? 0 : 1,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              middleText,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: MyColors.darkBlue,
              ),
            ),
            Text(date.year.toString(), style: TextStyle(fontWeight: FontWeight.w300, color: MyColors.darkBlue)),
          ],
        ),
      ),
    );
  }

  Widget previousButton() {
    return Opacity(
      opacity: widget.tabElement == TabElement.AddDelete ? 0 : 1,
      child: Container(
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.arrow_back_ios,
                color: MyColors.darkBlue,
              ),
              Flexible(
                child: Text(
                  leftButtonText,
                  style: TextStyle(fontSize: 10, color: MyColors.darkBlue, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          onPressed: () => onLeftButtonPressed(),
        ),
      ),
    );
  }

  Widget nextButton() {
    return Opacity(
      opacity: (widget.tabElement == TabElement.AddDelete || shouldNextButtonBeVisible) ? 0 : 1,
      child: Container(
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                rightButtonText,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10, color: MyColors.darkBlue, fontWeight: FontWeight.w300),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: MyColors.darkBlue,
              ),
            ],
          ),
          onPressed: shouldNextButtonBeVisible ? null : () => onRightButtonPressed(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tabElement) {
      case TabElement.AddDelete:
        leftButtonText = "";
        rightButtonText = "";
        middleText = "";
        onLeftButtonPressed = null;
        onRightButtonPressed = null;
        headerText = "Manage the activities to track";
        break;
      case TabElement.Pick:
        leftButtonText = "Previous\nDay";
        rightButtonText = "Next\nDay";
        middleText = "${date.day.toString()} ${monthFormatter.format(date)}";
        headerText = "Toggle the activities you have done";
        onLeftButtonPressed = () {
          bloc.changeDate(date.add(Duration(days: -1)));
        };
        onRightButtonPressed = () {
          bloc.changeDate(date.add(Duration(days: 1)));
        };
        setState(() {
          shouldNextButtonBeVisible = (date.difference(DateTime.now()).inDays == 0);
        });
        break;
      case TabElement.Track:
        leftButtonText = "Previous\nMonth";
        rightButtonText = "Next\nMonth";
        middleText = "${monthFormatter.format(date)}";
        headerText = "Monthly counts of activities";
        onLeftButtonPressed = () {
          bloc.changeDate(DateTime(date.year, date.month - 1, date.day));
        };
        onRightButtonPressed = () {
          bloc.changeDate(DateTime(date.year, date.month + 1, date.day));
        };
        setState(() {
          shouldNextButtonBeVisible = (date.month == DateTime.now().month && date.year == DateTime.now().year);
        });
        break;
      case TabElement.Calendar:
        leftButtonText = "Previous\nMonth";
        rightButtonText = "Next\nMonth";
        middleText = "${monthFormatter.format(date)}";
        headerText = "Calendar";
        onLeftButtonPressed = () {
          bloc.changeDate(DateTime(date.year, date.month - 1, date.day));
        };
        onRightButtonPressed = () {
          bloc.changeDate(DateTime(date.year, date.month + 1, date.day));
        };
        setState(() {
          shouldNextButtonBeVisible = (date.month == DateTime.now().month && date.year == DateTime.now().year);
        });
        break;

    }

    return Container(
      decoration: BoxDecoration(
        color: MyColors.darkBlue,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 60,
              color: MyColors.darkBlue,
              child: Align(
                alignment: Alignment(-1, 0.2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    headerText,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Offstage(
              offstage: widget.tabElement == TabElement.AddDelete ? true : false,
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.lightGrey,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      offset: Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    previousButton(),
                    middle(),
                    nextButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    dateSubscription.cancel();
    super.dispose();
  }
}
