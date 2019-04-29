import 'package:flutter/material.dart';
import 'UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/Screens/screens.dart';
import 'dart:async';
import 'blocs.dart';
import 'aspect.dart';
import 'package:personal_data_interaction_app/util/util.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabElement selectedTab;

  Animation<Offset> animatedPosition;
  AnimationController animationController;

  StreamSubscription<TabElement> selectedTabSubscription;

  @override
  initState() {
    selectedTab = TabElement.Pick;

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animatedPosition = Tween(begin: Offset(0, 0), end: Offset(0, 1)).animate(animationController);

    selectedTabSubscription = bloc.tabElement.listen((tabElement) {
      // Set the date today so every screen will start from today
      bloc.changeDate(DateTime.now());
      switch (tabElement) {
        case TabElement.Pick:
          if (selectedTab == TabElement.Pick) {
            break;
          }
          if (selectedTab == TabElement.Track) {
            setState(() {
              selectedTab = TabElement.Pick;
            });
            break;
          }
          animateBottomBar();
          break;
        case TabElement.Track:
          if (selectedTab == TabElement.Track) {
            break;
          }
          setState(() {
            selectedTab = TabElement.Track;
          });
          break;
        case TabElement.AddDelete:
          if (selectedTab == TabElement.AddDelete) {
            break;
          }
          animationController.forward().then((f) {
            setState(() {
              selectedTab = TabElement.AddDelete;
            });
          }).then((f) {
            animationController.reverse();
          });
          break;
      }
    });

    super.initState();
  }

  void animateBottomBar() {
    animationController.forward().then((f) {
      setState(() {
        selectedTab = TabElement.Pick;
      });
    }).then((f) {
      animationController.reverse();
    });
  }

  Widget setBottomBar() {
    if (selectedTab == TabElement.AddDelete) {
      return EditModeBottomBar();
    }
    return BottomBar(tabElement: selectedTab);
  }

  Widget setBodyView() {
    if (selectedTab == TabElement.Track) {
      return Chart();
    }
    return PickView(mode: selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: selectedTab == TabElement.AddDelete
            ? PreferredSize(
                child: MyAppBar(tabElement: this.selectedTab),
                preferredSize: Size.fromHeight(60),
              )
            : PreferredSize(
                child: MyAppBar(tabElement: this.selectedTab),
                preferredSize: Size.fromHeight(130),
              ),
        body: setBodyView(),
        bottomNavigationBar: SlideTransition(
          child: setBottomBar(),
          position: animatedPosition,
        ),
      ),
    );
  }

  @override
  void dispose() {
    selectedTabSubscription.cancel();
    super.dispose();
  }
}
