import 'package:flutter/material.dart';
import 'MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import '../aspect.dart';
import 'package:personal_data_interaction_app/firebase/DB.dart';
import 'dart:async';

class AspectCell extends StatefulWidget {
  final Aspect aspect;
  final bool isEditMode;
  final DateTime date;
  AspectCell({this.aspect, this.isEditMode, this.date});

  @override
  _AspectCellState createState() => _AspectCellState();
}

class _AspectCellState extends State<AspectCell> {
  bool selected;

  @override
  void initState() {
    selected = false;
    for (DateTime dateOfAspect in widget.aspect.dates) {
      if (dateOfAspect.difference(widget.date).inDays == 0) {
        selected = true;
      }
    }
    super.initState();
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
                    db.update("koriawas@dtu.dk", widget.aspect.name, widget.date);
                  } else {
                    db.remove("koriawas@dtu.dk", widget.aspect.name, widget.date);
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
                          db.deleteItem("koriawas@dtu.dk", widget.aspect.name);
                          bloc.deleteAspect(widget.aspect);
                        })
                    : CupertinoSwitch(
                        value: selected,
                        onChanged: (value) {
                          if (!selected) {
                            db.update("koriawas@dtu.dk", widget.aspect.name, widget.date);
                          } else {
                            db.remove("koriawas@dtu.dk", widget.aspect.name, widget.date);
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
