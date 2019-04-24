import 'package:flutter/material.dart';
import 'MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import '../Aspect.dart';
import 'package:personal_data_interaction_app/firebase/DB.dart';
import 'dart:async';

class AspectCell extends StatefulWidget {
  final Aspect aspect;
  final bool isEditMode;
  AspectCell({this.aspect, this.isEditMode});

  @override
  _AspectCellState createState() => _AspectCellState();
}

class _AspectCellState extends State<AspectCell> {
  bool selected;
//  Color color;

  @override
  void initState() {
//    int rnd = Random().nextInt(Colors.accents.length);
//    color = Colors.accents[rnd];

    StreamSubscription<DateTime> dateSubscription;
    selected = false;
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: MyColors.lightGrey,
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(2, 4), blurRadius: 10),
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(-1, -1), blurRadius: 5)
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: FlatButton(
          splashColor: widget.aspect.color,
          onPressed: widget.isEditMode
              ? null
              : () {
                  if (!selected) {
                    db.update("koriawas@dtu.dk", widget.aspect.name, DateTime.now());
                  } else {
                    db.remove("koriawas@dtu.dk", widget.aspect.name, DateTime.now());
                  }
                  setState(() {
                    selected = !selected;
                  });
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 8,
                child: Text(
                  widget.aspect.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Flexible(
                flex: 2,
                child: widget.isEditMode
                    ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 32,
                          color: MyColors.darkGrey,
                        ),
                        onPressed: () {
                          //TODO delete
                          db.deleteItem("koriawas@dtu.dk", widget.aspect.name);
                          bloc.deleteAspect(widget.aspect);
                        })
                    : CupertinoSwitch(
                        value: selected,
                        onChanged: (value) {
                          if (!selected) {
                            db.update("koriawas@dtu.dk", widget.aspect.name, DateTime.now());
                          } else {
                            db.remove("koriawas@dtu.dk", widget.aspect.name, DateTime.now());
                          }
                          print("switcher new value is: $value");
                          setState(() {
                            selected = !selected;
                          });
                        },
                        activeColor: widget.aspect.color,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
