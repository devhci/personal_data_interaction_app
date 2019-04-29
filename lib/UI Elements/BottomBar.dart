import 'package:flutter/material.dart';
import 'MyColors.dart';
import 'package:personal_data_interaction_app/blocs.dart';

class BottomBar extends StatefulWidget {
  final TabElement tabElement;

  BottomBar({this.tabElement});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 80,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    offset: Offset(0, -4),
                    blurRadius: 10,
                  )
                ],
                color: MyColors.lightGrey,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Center(
                  child: addDeleteButton(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      offset: Offset(0, -4),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(-4, 0),
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    )
                  ]),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    pickButton(),
                    trackButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addDeleteButton() {
    return FlatButton(
      onPressed: () => bloc.changeSelectedTabElement(TabElement.AddDelete),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image(
              image: AssetImage("assets/Add_delete_icon.png"),
              height: 35,
            ),
          ),
          Text(
            "Add/Delete",
            style: TextStyle(color: MyColors.darkBlue),
          )
        ],
      ),
    );
  }

  Widget pickButton() {
    return Opacity(
      opacity: widget.tabElement == TabElement.Pick ? 1 : 0.6,
      child: FlatButton(
        onPressed: () => bloc.changeSelectedTabElement(TabElement.Pick),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image(
                image: AssetImage("assets/Pick_icon.png"),
                height: 35,
              ),
            ),
            Text(
              "Pick",
              style: TextStyle(color: MyColors.darkBlue),
            )
          ],
        ),
      ),
    );
  }

  Widget trackButton() {
    return Opacity(
      opacity: widget.tabElement == TabElement.Track ? 1 : 0.6,
      child: FlatButton(
        onPressed: () => bloc.changeSelectedTabElement(TabElement.Track),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.sort,
                color: MyColors.darkGrey,
                size: 35,
              ),
            ),
            Text(
              "Charts",
              style: TextStyle(color: MyColors.darkBlue),
            )
          ],
        ),
      ),
    );
  }
}
