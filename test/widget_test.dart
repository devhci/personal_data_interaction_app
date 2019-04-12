// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_data_interaction_app/firebase/DB.dart';

import 'package:personal_data_interaction_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    HashMap<String, dynamic> map = HashMap<String, dynamic>();


    List dtLst = new List();

    dtLst.add(Timestamp.now());

    map["timestemp"] = dtLst;

    HashMap<String, dynamic> update = HashMap<String, dynamic>();
    update["timestemp"] = dtLst;

    DB _db= DB();

    _db.createNewItem("dk@dtu.dk","swim");


  });
}
