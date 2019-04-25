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
  DateTime date;

  Animation<Offset> animatedPosition;
  AnimationController animationController;

  StreamSubscription<TabElement> selectedTabSubscription;
//  StreamSubscription<Aspect> deleteAspectSubscription;
//  StreamSubscription<Aspect> addAspectSubscription;
//  StreamSubscription<DateTime> dateSubscription;

//  List<Aspect> allAspects = [];
  List<Aspect> aspects = [];

//  void getAllData() async {
//    util.getAllData("koriawas@dtu.dk").then((allData) {
//      for (var aspect in allData) {
//        Aspect a = Aspect(
//            name: aspect['name'],
//            stringDates: aspect['listOfDates'],
//            stringColor: aspect['color'],
//            stringDeleteDate: aspect['delete_date']);
//        setState(() {
//          allAspects.add(a);
//        });
//      }
//      aspects = getAspectsAfterGivenDate(util.formatter.parse(DateTime.now().toString()));
//    });
//  }
//
//  List<Aspect> getAspectsAfterGivenDate(DateTime date) {
//    List<Aspect> aspectsAfterGivenDate = [];
//    for (Aspect aspect in allAspects) {
//      if (aspect.deleteDate == null) {
//        aspectsAfterGivenDate.add(aspect);
//        continue;
//      }
//      if (aspect.deleteDate.isAfter(date)) {
//        aspectsAfterGivenDate.add(aspect);
//      }
//    }
//    return aspectsAfterGivenDate;
//  }

  @override
  initState() {
    date = DateTime.now();
//    getAllData();
//    getDeviceId();

    selectedTab = TabElement.Pick;

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animatedPosition = Tween(begin: Offset(0, 0), end: Offset(0, 1)).animate(animationController);

//    dateSubscription = bloc.date.listen((newDate) {
//      print("this is the new Date: $newDate");
//      setState(() {
//        aspects = getAspectsAfterGivenDate(newDate);
//        date = newDate;
//      });
//    });

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

//    addAspectSubscription = bloc.aspectsToAdd.listen((aspectToAdd) {
//      setState(() {
//        aspects.add(aspectToAdd);
//      });
//      print(aspects);
//    });
//
//    deleteAspectSubscription = bloc.aspectsToDelete.listen((aspectToDelete) {
//      try {
//        setState(() {
//          aspects.remove(aspectToDelete);
//        });
//        print(aspects);
//      } catch (e) {
//        print(e);
//      }
//    });

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
        appBar: PreferredSize(
          child: MyAppBar(tabElement: this.selectedTab),
          preferredSize: Size.fromHeight(80),
        ),
        body: setBodyView(),
        bottomNavigationBar: SlideTransition(
          child: setBottomBar(),
          position: animatedPosition,
        ),
//        floatingActionButton: FloatingActionButton(onPressed: () {
//          getDeviceId();
//          util.getAllData("koriawas@dtu.dk");
//        }),
      ),
    );
  }

  @override
  void dispose() {
    selectedTabSubscription.cancel();
//    addAspectSubscription.cancel();
//    deleteAspectSubscription.cancel();
//    dateSubscription.cancel();
    super.dispose();
  }

  void getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.get("deviceId") == null) {
      print("Setting Shared preferences");
      String deviceId = await UniqueIdentifier.serial;
      prefs.setString("deviceId", deviceId);
    }

    print("device Id from Shared pref" + prefs.get("deviceId"));
  }
}
