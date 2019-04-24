import 'package:flutter/material.dart';
import 'UI Elements/ui_elements.dart';
import 'dart:async';
import 'blocs.dart';
import 'Aspect.dart';
import 'package:personal_data_interaction_app/util/util.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  Animation<Offset> animatedPosition;
  AnimationController animationController;

  StreamSubscription<TabElement> selectedTabSubscription;
  StreamSubscription<Aspect> deleteAspectSubscription;
  StreamSubscription<Aspect> addAspectSubscription;
  StreamSubscription<DateTime> dateSubscription;
  TabElement selectedTab;

  List<Aspect> aspects = [];

  void getAllData() async {
    util.getAllData("koriawas@dtu.dk").then((allData) {
      for (var aspect in allData) {
        Aspect a =
            Aspect(aspect['name'], aspect['listOfDates'], aspect['color']);
        setState(() {
          aspects.add(a);
        });
      }
    });
  }

  @override
  initState() {
    getAllData();
    getDeviceId();

    selectedTab = TabElement.Pick;

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animatedPosition = Tween(begin: Offset(0, 0), end: Offset(0, 1))
        .animate(animationController);

    selectedTabSubscription = bloc.tabElement.listen((tabElement) {
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

    addAspectSubscription = bloc.aspectsToAdd.listen((aspectToAdd) {
      setState(() {
        aspects.add(aspectToAdd);
      });
      print(aspects);
    });

    deleteAspectSubscription = bloc.aspectsToDelete.listen((aspectToDelete) {
      try {
        setState(() {
          aspects.remove(aspectToDelete);
        });
        print(aspects);
      } catch (e) {
        print(e);
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

  Widget aspectCellBuilder(BuildContext context, int index) {
    if (selectedTab == TabElement.AddDelete) {
      if (index == aspects.length) {
        return AddNewAspectCell();
      }
    }
    return AspectCell(
      aspect: aspects[index],
      isEditMode: (selectedTab == TabElement.AddDelete),
    );
  }

  Widget setBottomBar() {
    if (selectedTab == TabElement.AddDelete) {
      return EditModeBottomBar();
    } else {
      return BottomBar();
    }
  }

  PreferredSize setAppBar() {
    return PreferredSize(
      child: MyAppBar(tabElement: this.selectedTab),
      preferredSize: Size.fromHeight(80),
    );
  }

  Widget setBodyView() {
    switch (selectedTab) {
      case TabElement.AddDelete:
        return pickView();
      case TabElement.Pick:
        return pickView();
      case TabElement.Track:
        return trackView();
    }
  }

  Widget trackView() {
    return Chart();
  }

  Widget pickView() {
    return ListView.builder(
      itemBuilder: aspectCellBuilder,
      // Add one more for the "add cell"
      itemCount: selectedTab == TabElement.AddDelete
          ? aspects.length + 1
          : aspects.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: setAppBar(),
        body: setBodyView(),
        bottomNavigationBar: SlideTransition(
          child: setBottomBar(),
          position: animatedPosition,
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          getDeviceId();
          util.getAllData("koriawas@dtu.dk");
        }),
      ),
    );
  }

  @override
  void dispose() {
    selectedTabSubscription.cancel();
    addAspectSubscription.cancel();
    deleteAspectSubscription.cancel();
    dateSubscription.cancel();
    super.dispose();
  }

  void getDeviceId() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.get("deviceId")==null) {
      print("Setting Shared preferences");
      String deviceId = await UniqueIdentifier.serial;
      prefs.setString( "deviceId", deviceId );
    }

    print("device Id from Shared pref" + prefs.get("deviceId"));
  }
}
