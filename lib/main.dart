import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/Screens/screens.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'tutorial': (context) => Tutorial(),
        'home': (context) => Home(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: MyColors.darkBlue,
        canvasColor: Colors.transparent,
      ),
      // TODO: check if user has been through tutorial
      initialRoute: 'tutorial',
    );
  }
}
