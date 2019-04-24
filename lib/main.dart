import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: MyColors.darkBlue,
        canvasColor: Colors.transparent,
      ),
      home: Home(),
    );
  }
}
