import 'package:flutter/material.dart';
import 'MyColors.dart';

class TextAppBar extends StatelessWidget {
  final String text;

  TextAppBar({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: MyColors.darkBlue),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
