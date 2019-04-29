import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  PageController pageController = PageController();
  int position;
  static const double _horizontalTextPadding = 20;

  @override
  void initState() {
    position = 0;
    super.initState();
  }

  Container page1() {
    return Container(
      color: Colors.lightBlueAccent,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: _horizontalTextPadding),
            child: Text(
              "Hello",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "Welcome to the Good Day app",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "According to psychologists, doing pleasant activites is a key factor for happiness.",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "By actively trying to do things that you enjoy, you can improve their well-being.",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "So, this is how you can begin to find bliss on a daily basis...",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container page2() {
    return Container(
      color: Colors.amberAccent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 120, bottom: 20.0, left: _horizontalTextPadding, right: _horizontalTextPadding),
            child: Text(
              "1. Think about activities that you truly enjoy doing",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "2. Create a list of these activities using the app",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "3. Everyday, keep track and mark the activities you did",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "4. Check all joyful activities you have done every month",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container page3() {
    return Container(
      color: Colors.greenAccent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 120, bottom: 20.0, left: _horizontalTextPadding, right: _horizontalTextPadding),
            child: Text(
              "If you change your mind, you can always edit your list of activities.",
//              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "You should feel free to do any activity, any day... but it is fine to do nothing too!",
//              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: _horizontalTextPadding),
            child: Text(
              "Doing simple and pleasant activities can help on your self-care: just focus on that",
//              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setTutorialCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("tutorialCompletion", true);
    print("tutorial completion has been set to true");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGrey,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          page1(),
          page2(),
          page3(),
        ],
      ),
      persistentFooterButtons: footerButtons(position),
    );
  }

  List<Widget> footerButtons(int position) {
    if (position == 0) {
      return [
        RoundedButton(
            text: "Next",
            color: MyColors.darkGrey,
            onPressed: () {
              setState(() {
                this.position++;
              });
              pageController.animateToPage(
                1,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              );
            }),
      ];
    } else if (position == 1) {
      return [
        RoundedButton(
            text: "Back",
            color: MyColors.darkGrey,
            onPressed: () {
              setState(() {
                this.position--;
              });
              pageController.animateToPage(
                0,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              );
            }),
        RoundedButton(
            text: "Next",
            color: MyColors.darkGrey,
            onPressed: () {
              setState(() {
                this.position++;
              });
              pageController.animateToPage(
                2,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              );
            })
      ];
    } else if (position == 2) {
      return [
        RoundedButton(
            text: "Back",
            color: MyColors.darkGrey,
            onPressed: () {
              setState(() {
                this.position--;
              });
              pageController.animateToPage(
                1,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              );
            }),
        RoundedButton(
            text: "Start",
            color: MyColors.darkGrey,
            onPressed: () {
              setTutorialCompletion();
              Navigator.of(context).pushNamed('home');
            })
      ];
    }
    return [Container()];
  }
}
