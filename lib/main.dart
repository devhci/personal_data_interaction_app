import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/Screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  getTutorialCompletion().then((isTutorialCompleted) => runApp(MyApp(isTutorialCompleted: isTutorialCompleted)));
}

class MyApp extends StatelessWidget {
  final bool isTutorialCompleted;

  MyApp({this.isTutorialCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'tutorial': (context) => Tutorial(),
        'home': (context) => Home(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: MyColors.darkBlue,
        canvasColor: Colors.transparent,
      ),
      // TODO: check if user has been through tutorial
      initialRoute: isTutorialCompleted ? 'home' : 'tutorial',
    );
  }
}

Future<bool> getTutorialCompletion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.get("tutorialCompletion") != null) {
    return prefs.getBool("tutorialCompletion");
  }
  return false;
}

//void getDeviceId() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//
//  if (prefs.get("deviceId") == null) {
//    print("Setting Shared preferences");
//    String deviceId = await UniqueIdentifier.serial;
//    prefs.setString("deviceId", deviceId);
//  }
//
//  print("device Id from Shared pref" + prefs.get("deviceId"));
//}
