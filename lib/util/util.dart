import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:personal_data_interaction_app/firebase/DB.dart';

class Util {
  DB _db = DB();

  Future<List<String>> giveListOfDateForCalenderVisualization() async {
    List<String> dates = List<String>();
    DocumentSnapshot documentSnapshot =
        await _db.getDatesFor("koriawas@dtu.dk", "Playing football");

    var a = documentSnapshot.data.remove("timestemp");

    print(a);

    List<String> list =
        a.toString().replaceAll("[", "").replaceAll("]", "").split(",");

    print(list);

    return list;
  }

  Future<List<HashMap<String, String>>> getAllData() async {
    List<HashMap<String, String>> list = List<HashMap<String, String>>();

    QuerySnapshot querySnapshot = await _db.getData("koriawas@dtu.dk");

    for (var u in querySnapshot.documents) {
      HashMap<String, String> items = HashMap<String, String>();

      items["name"] = u.documentID;

      int count = 0;

      for (var value in u.data.remove("timestemp")) {
        //print(value);

        count++;
      }

      items["count"] = count.toString();

      list.add(items);
    }

    return list;
  }
}
