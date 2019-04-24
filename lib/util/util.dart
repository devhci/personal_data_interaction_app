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

  Future<List<HashMap<String, dynamic>>> getAllData(String userName) async {
    List<HashMap<String, dynamic>> list = List<HashMap<String, dynamic>>();

    QuerySnapshot querySnapshot = await _db.getData(userName);

    for (var u in querySnapshot.documents) {
      HashMap<String, dynamic> items = HashMap<String, dynamic>();

      items["name"] = u.documentID;
      items["color"]=u.data.remove("color");
      items["delete_date"]=u.data.remove("delete_date");


      //int count = 0;

      items["listOfDates"]=u.data.remove("timestemp");

     /* for (var value in u.data.remove("timestemp")) {
        //print(value);

        count++;
      }*/

     // items["count"] = count.toString();

      list.add(items);
    }

    print(list.toString());

    return list;
  }
}

Util util =Util();