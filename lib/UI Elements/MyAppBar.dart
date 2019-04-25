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
//  Duration durationForVisibility;
//  bool shouldNextButtonBeVisible;

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

  @override
  void dispose() {
    dateSubscription.cancel();
    super.dispose();
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
        break;
      case TabElement.Pick:
        leftButtonText = "Previous\nDay";
        rightButtonText = "Next\nDay";
        middleText = "${date.day.toString()} ${monthFormatter.format(date)}";
        onLeftButtonPressed = () {
          bloc.changeDate(date.add(Duration(days: -1)));
        };
        onRightButtonPressed = () {
          bloc.changeDate(date.add(Duration(days: 1)));
        };
        break;
      case TabElement.Track:
        leftButtonText = "Previous\nMonth";
        rightButtonText = "Next\nMonth";
        middleText = "${monthFormatter.format(date)}";
        onLeftButtonPressed = () {
          bloc.changeDate(date.add(Duration(days: -31)));
        };
        onRightButtonPressed = () {
          bloc.changeDate(date.add(Duration(days: 31)));
        };
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            previousButton(),
            middle(),
            nextButton(),
          ],
        ),
      ),
    );
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
                color: Colors.white,
              ),
            ),
            Text(date.year.toString(), style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white)),
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
                color: Colors.white,
              ),
              Flexible(
                child: Text(
                  leftButtonText,
                  style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w100),
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
      opacity: (widget.tabElement == TabElement.AddDelete || date.difference(DateTime.now()).inDays == 0) ? 0 : 1,
      child: Container(
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                rightButtonText,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w100),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
          onPressed: date.difference(DateTime.now()).inDays == 0 ? null : () => onRightButtonPressed(),
        ),
      ),
    );
  }
}
