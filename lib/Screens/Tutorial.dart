import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  Container page1() {
    return Container(
      color: MyColors.darkBlue,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Text(
              "Hello",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
            ),
          ),
          Text("Welcome to the Good Day app"),
          Text("According to psychologists, doing pleasant activites is a key factor for happiness."),
          Text("By actively trying to do things that you enjoy, you can improve their well-being."),
          Text("So, this is how you can begin to find bliss on a daily basis..."),
        ],
      ),
    );
  }

  Container page2() {
    return Container(
      color: MyColors.lightGrey,
      child: Column(
        children: <Widget>[
          Text("1. Think about activities that you truly enjoy doing"),
          Text("2. Create a list of these activities using the app"),
          Text("3. Everyday, keep track and mark the activities you did"),
          Text("4. Check all joyful activities you have done every month"),
        ],
      ),
    );
  }

  Container page3() {
    return Container(
      color: MyColors.lightGrey,
      child: Column(
        children: <Widget>[
          Text("If you change your mind, you can always edit yourlist of activities."),
          Text("You should feel free to do any activity, any day... but it is fine to do nothing too!"),
          Text("Doing simple and pleasant activities can help on your self-care: just focus on that"),
          RoundedButton(
            color: MyColors.darkGrey,
            text: "Start",
            onPressed: () {
              // TODO: set tutorial to true
              setTutorialCompletion();
              Navigator.of(context).pushNamed('home');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          page1(),
          page2(),
          page3(),
        ],
      ),
    );
  }

  void setTutorialCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("tutorialCompletion") == null) {
      prefs.setBool("tutorialCompletion", true);
    }
    print("tutorial completion has been set to true");
  }
}
