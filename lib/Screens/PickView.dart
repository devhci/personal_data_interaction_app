import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import 'package:personal_data_interaction_app/aspect.dart';
import 'dart:async';
import 'package:personal_data_interaction_app/util/util.dart';

class PickView extends StatefulWidget {
  final TabElement mode;
  PickView({this.mode});

  @override
  _PickViewState createState() => _PickViewState();
}

class _PickViewState extends State<PickView> {
  List<Aspect> allAspects;
  List<Aspect> aspects;
  DateTime date;
  bool _loading;

  StreamSubscription<DateTime> dateSubscription;
  StreamSubscription<bool> addAspectStatusSubscription;
  StreamSubscription<Aspect> deleteAspectSubscription;

  void getAllData() async {
    util.getAllData(Util.username).then((allData) {
      setState(() {
        aspects = [];
        allAspects = [];
        _loading = false;
      });
      for (var aspect in allData) {
        Aspect a = Aspect(
          name: aspect['name'],
          stringDates: aspect['listOfDates'],
          stringColor: aspect['color'],
          stringDeleteDate: aspect['delete_date'],
          stringCreateDate: aspect['create_date'],
        );
        setState(() {
          allAspects.add(a);
        });
      }
      setState(() {
        aspects = getAspectsAfterGivenDate(util.formatter.parse(date.toString()));
      });
    });
  }

  List<Aspect> getAspectsAfterGivenDate(DateTime date) {
    List<Aspect> aspectsAfterGivenDate = [];
    for (Aspect aspect in allAspects) {
      if (aspect.createDate.isAfter(date)) {
        continue;
      }
      if (aspect.deleteDate == null) {
        aspectsAfterGivenDate.add(aspect);
        continue;
      }
      if (aspect.deleteDate.isAfter(date)) {
        aspectsAfterGivenDate.add(aspect);
      }
    }
    return aspectsAfterGivenDate;
  }

  @override
  void initState() {
    _loading = true;

    dateSubscription = bloc.date.listen((newDate) {
      setState(() {
        date = newDate;
      });
      _loading = true;
      getAllData();
    });

    addAspectStatusSubscription = bloc.addAspectStatus.listen((a) {
      getAllData();
    });

    deleteAspectSubscription = bloc.aspectsToDelete.listen((a) {
      getAllData();
    });

    super.initState();
  }

  Widget aspectCellBuilder(BuildContext context, int index) {
    if (widget.mode == TabElement.AddDelete) {
      if (index == aspects.length) {
        return AddNewAspectCell();
      }
    }
    return AspectCell(
      aspect: aspects[index],
      isEditMode: (widget.mode == TabElement.AddDelete),
      date: this.date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.darkBlue)))
        : ListView.builder(
            itemBuilder: aspectCellBuilder,
            // Add one more for the "add cell"
            itemCount: widget.mode == TabElement.AddDelete ? aspects.length + 1 : aspects.length,
          );
  }

  @override
  void dispose() {
    dateSubscription.cancel();
    addAspectStatusSubscription.cancel();
    deleteAspectSubscription.cancel();
    super.dispose();
  }
}
