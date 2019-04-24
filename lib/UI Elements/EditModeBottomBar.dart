import 'package:flutter/material.dart';
import 'MyColors.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import 'RoundedButton.dart';

class EditModeBottomBar extends StatefulWidget {
  @override
  _EditModeBottomBarState createState() => _EditModeBottomBarState();
}

class _EditModeBottomBarState extends State<EditModeBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(0, -4),
            blurRadius: 10,
          )
        ],
        color: MyColors.darkBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: RoundedButton(
            color: Colors.white,
            text: "Done",
            onPressed: () => bloc.changeSelectedTabElement(TabElement.Pick),
          ),
        ),
      ),
    );
  }
}
