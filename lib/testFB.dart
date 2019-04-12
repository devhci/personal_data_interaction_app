import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:personal_data_interaction_app/firebase/DB.dart';

class TestClass extends StatelessWidget {
  HashMap<String, String> itemsWithCount = HashMap<String, String>();

  List<HashMap<String, String>> list = List();

  DB _db = DB();


  void test() {
    Firestore.instance
        .collection('auto-id')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => print(doc)));

    HashMap<String, dynamic> map = HashMap<String, dynamic>();

    List dtLst = new List();

    dtLst.add(Timestamp.now());

    map["timestemp"] = dtLst;

    print("test clicked");

    //_db.createNewItem("koriawas@dtu.dk","criket");
    _db.update("koriawas@dtu.dk", "criket");

    _db.getData("koriawas@dtu.dk").then(onValue);

    /* _db.createNewItem("koriawas@dtu.dk","sleep");*/
    /* _db.deleteItem("koriawas@dtu.dk","morning walk");*/

    // _db.update("new@dtu.dk","gym");
  }

  void onValue(QuerySnapshot value) {
    //value.documents.single.exists;

    print("last " + value.documents.length.toString());

    for (var u in value.documents) {
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

    for (var u in list) {
      print(u.remove("name"));
      print(u.remove("count"));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing Firebase"),
      ),
      body: Center(
        child: Container(
          child: Text(" Hello"),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          FloatingActionButton(
            onPressed: () => test(),
            child: Icon(
              Icons.add,
            ),
            mini: false,
          ),
          FloatingActionButton(
            onPressed: () => test(),
            child: Icon(
              Icons.update,
            ),

          ),

    FloatingActionButton(
    onPressed: () => test(),
    child: Icon(
    Icons.remove,
    ),

    ),
FloatingActionButton(
    onPressed: () => test(),
    child: Icon(
    Icons.calendar_today,
    ),

    ),


        ],
      ),
    );
  }
}
