import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;

  RoundedButton({this.color, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: color, width: 1),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 18),
      ),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      onPressed: onPressed,
    );
  }
}
