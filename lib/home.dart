import 'package:flutter/material.dart';
import 'UI Elements/ui_elements.dart';
import 'dart:async';
import 'blocs.dart';
import 'Aspect.dart';

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
  TabElement selectedTab;

  List<Aspect> aspects;

  @override
  initState() {
    // TODO: download the required set of aspects
    aspects = [
      Aspect("Did I go climbing?", 10, Colors.redAccent),
      Aspect("I didn't use my phone before going to bed", 10, Colors.deepPurpleAccent),
      Aspect("Did I have a good meal today?", 10, Colors.greenAccent),
    ];

    selectedTab = TabElement.Pick;

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animatedPosition = Tween(begin: Offset(0, 0), end: Offset(0, 1)).animate(animationController);

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

//    switch (selectedTab) {
//      case TabElement.AddDelete:
//        return PreferredSize(
//          child: MyAppBar(mode: AppBarMode.Blank),
//          preferredSize: Size.fromHeight(80),
//        );
//      case TabElement.Pick:
//        return PreferredSize(
//          child: MyAppBar(mode: AppBarMode.Date),
//          preferredSize: Size.fromHeight(80),
//        );
//      case TabElement.Track:
//        return PreferredSize(
//          child: MyAppBar(mode: AppBarMode.Month),
//          preferredSize: Size.fromHeight(80),
//        );

//    }
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
    return Container();
  }

  Widget trackView() {
    return Chart();
  }

  Widget pickView() {
    return ListView.builder(
      itemBuilder: aspectCellBuilder,
      // Add one more for the "add cell"
      itemCount: selectedTab == TabElement.AddDelete ? aspects.length + 1 : aspects.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppBar(),
      body: setBodyView(),
      bottomNavigationBar: SlideTransition(
        child: setBottomBar(),
        position: animatedPosition,
      ),
    );
  }

  @override
  void dispose() {
    selectedTabSubscription.cancel();
    addAspectSubscription.cancel();
    deleteAspectSubscription.cancel();
    super.dispose();
  }
}
