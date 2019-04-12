import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:personal_data_interaction_app/firebase/DB.dart';

class TestClass  extends StatelessWidget{


  DB _db = DB();



  void test(){


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
    _db.getData("koriawas@dtu.dk");


    /* _db.createNewItem("koriawas@dtu.dk","sleep");*/
    /* _db.deleteItem("koriawas@dtu.dk","morning walk");*/

    // _db.update("new@dtu.dk","gym");



  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(

      appBar: AppBar(
        title: Text("Testing Firebase"),

      ),

      body: Center(

        child: Container(

          child: Text(" Hello"),




      ),



    ),


      floatingActionButton: FloatingActionButton(
        onPressed:()=> test(),
        child: Icon(Icons.add,),
        mini: true,
      ),

    );
  }




}