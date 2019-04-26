import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/Screens/screens.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getTutorialCompletion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.get("tutorialCompletion") != null) {
    return prefs.getBool("tutorialCompletion");
  }
  return false;
}

void main() {
  getTutorialCompletion().then((value) => runApp(MyApp(isTutorialCompleted: value)));
}

class MyApp extends StatelessWidget {
  final bool isTutorialCompleted;

  MyApp({this.isTutorialCompleted});

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
      initialRoute: 'tutorial',//isTutorialCompleted ? 'home' : 'tutorial',
    );
  }
}

//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}

//class _MyAppState extends State<MyApp> {
//  bool tutorialCompletion = false;
//
//  @override
//  void initState() {
//    getTutorialCompletion().then((value) {
//      setState(() {
//        tutorialCompletion = value;
//      });
//    });
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      routes: {
//        'tutorial': (context) => Tutorial(),
//        'home': (context) => Home(),
//      },
//      theme: ThemeData.light().copyWith(
//        primaryColor: MyColors.darkBlue,
//        canvasColor: Colors.transparent,
//      ),
//      // TODO: check if user has been through tutorial
//      initialRoute: tutorialCompletion ? 'home' : 'tutorial',
//    );
//  }
//
//  Future<bool> getTutorialCompletion() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//
//    if (prefs.get("tutorialCompletion") != null) {
//      return prefs.getBool("tutorialCompletion");
//    }
//    return false;
//  }
//}
