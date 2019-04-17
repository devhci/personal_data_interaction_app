import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DB {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  List<String> dates = List<String>();

  List<HashMap<String, String>> list;

  Future<dynamic> getDoc() {}

  Future<void> createNewItem(String username, String itemName) {
    HashMap<String, dynamic> map = HashMap<String, dynamic>();

    map["timestemp"] = Timestamp.now();

    List dtLst = new List();

    //dtLst.add(Timestamp.now());

    map["timestemp"] = dtLst;

    // Firestore.instance.collection('users').document(username).collection('data').document(itemName).setData(map);
    //Firestore.instance.collection('testusers').document(itemName).setData(map);

    print("Inside create");

    Firestore.instance
        .collection('users')
        .document(username)
        .collection('data')
        .document(itemName)
        .setData(map);
  }

  Future<void> deleteItem(String username, String itemName) {
    HashMap<String, dynamic> map = HashMap<String, dynamic>();

    Firestore.instance
        .collection('users')
        .document(username)
        .collection('data')
        .document(itemName)
        .delete();
  }

  Future<QuerySnapshot> getData(String username) async {
    list = List<HashMap<String, String>>();

    return Firestore.instance
        .collection("users")
        .document(username)
        .collection("data")
        .getDocuments();
  }

  Future<DocumentSnapshot> getDatesFor(String username, String itemName) async {
    print("inside DB getDates");

    return await Firestore.instance
        .collection("users")
        .document(username)
        .collection("data")
        .document(itemName)
        .get();
  }

  Future<void> remove(String username, String documentName) {
    final DocumentReference postRef = Firestore.instance
        .collection('users')
        .document(username)
        .collection('data')
        .document(documentName);

    //final DocumentReference postRef = Firestore.instance.collection('auto-id').document(documentName);

    if (postRef != null)
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.data.containsKey("timestemp")) {
          await tx.update(postRef, <String, dynamic>{
            'timestemp': FieldValue.arrayRemove([formatter.format(now)])
          });
        }
      });
  }

  Future<void> update(String username, String documentName) {
    final DocumentReference postRef = Firestore.instance
        .collection('users')
        .document(username)
        .collection('data')
        .document(documentName);

    //final DocumentReference postRef = Firestore.instance.collection('auto-id').document(documentName);

    if (postRef != null)
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.data.containsKey("timestemp")) {
          await tx.update(postRef, <String, dynamic>{
            'timestemp': FieldValue.arrayUnion([formatter.format(now)])
          });
        }
      });
  }
}
