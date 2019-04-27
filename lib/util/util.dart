import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_data_interaction_app/firebase/DB.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static String username = "julia";
  var formatter = new DateFormat('yyyy-MM-dd');

  Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.get("deviceId") != null) {
      return prefs.getString("deviceId");
    }
    return "";
  }

  Future<HashMap<String, dynamic>> giveListOfDateForCalenderVisualization(String username, String itemName) async {
    HashMap<String, dynamic> map = HashMap<String, String>();

    DocumentSnapshot documentSnapshot = await db.getDatesFor(username, itemName);
    var a = documentSnapshot.data.remove("timestemp");

    var color = documentSnapshot.data.remove("color");

    map["list"] = a.toString();
    map["color"] = color;

    return map;
  }

  Future<List<HashMap<String, dynamic>>> getAllData(String userName) async {
    List<HashMap<String, dynamic>> list = List<HashMap<String, dynamic>>();

    QuerySnapshot querySnapshot = await db.getData(userName);

    for (var u in querySnapshot.documents) {
      HashMap<String, dynamic> items = HashMap<String, dynamic>();

      items["name"] = u.documentID;
      items["color"] = u.data.remove("color");
      items["delete_date"] = u.data.remove("delete_date");
      items["create_date"] = u.data.remove("create_date");

      items["listOfDates"] = u.data.remove("timestemp");

      list.add(items);
    }

    return list;
  }
}

final Util util = Util();
