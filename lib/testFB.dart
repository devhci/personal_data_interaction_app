import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:personal_data_interaction_app/firebase/DB.dart';

class TestClass extends StatelessWidget {
  HashMap<String, String> itemsWithCount = HashMap<String, String>();

  /* List<HashMap<String, String>> list = List();*/

  DB _db = DB();

  void add() {
    _db.update("koriawas@dtu.dk", "Playing football");
  }

  void remove() {
    _db.remove("koriawas@dtu.dk", "Playing football");
  }

  void create() {
    _db.createNewItem("koriawas@dtu.dk", "Playing football");
  }

  void deleteItem() {
    _db.deleteItem("koriawas@dtu.dk", "Playing football");
  }

  void listAllForAMonth() async {
    List<HashMap<String, String>> list = await _db.getData("koriawas@dtu.dk");

    for (var u in list) {
      print("Name " + u.remove("name") + " count  " + u.remove("count"));
      //print(u.remove("count"));
    }
  }

  void giveListOfDateForCalenderVisualization() async {
    DocumentSnapshot documentSnapshot =
        await _db.getDatesFor("koriawas@dtu.dk", "Playing football");

    var a = documentSnapshot.data.remove("timestemp");

    print(a);
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
            onPressed: () => add(),
            child: Icon(
              Icons.add,
            ),
            mini: false,
          ),
          FloatingActionButton(
            onPressed: () => remove(),
            child: Icon(
              Icons.remove,
            ),
          ),
          FloatingActionButton(
            onPressed: () => create(),
            child: Icon(
              Icons.create,
            ),
          ),
          FloatingActionButton(
            onPressed: () => deleteItem(),
            child: Icon(
              Icons.delete,
            ),
          ),
          FloatingActionButton(
            onPressed: () => listAllForAMonth(),
            child: Icon(
              Icons.list,
            ),
          ),
          FloatingActionButton(
            onPressed: () => giveListOfDateForCalenderVisualization(),
            child: Icon(
              Icons.calendar_view_day,
            ),
          ),
        ],
      ),
    );
  }
}
