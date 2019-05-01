import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_data_interaction_app/util/util.dart';

class DB {
  var now = new DateTime.now();

  List<String> dates = List<String>();

  List<HashMap<String, String>> list;

  void createNewItem(String username, String itemName, String color, String create_date) {
    print("we are inside createNewItem with this username: $username");
    HashMap<String, dynamic> map = HashMap<String, dynamic>();

    map["timestemp"] = Timestamp.now();
    map["color"] = color;
    map["delete_date"] = "";
    map["create_date"] = create_date;

    List dtLst = new List();

    //dtLst.add(Timestamp.now());

    map["timestemp"] = dtLst;

    // Firestore.instance.collection(‘users’).document(username).collection(‘data’).document(itemName).setData(map);
    //Firestore.instance.collection(‘testusers’).document(itemName).setData(map);

    Firestore.instance.collection('users').document(username).collection('data').document(itemName).setData(map);
  }

  void deleteItem(String username, String itemName) {
    HashMap<String, dynamic> map = HashMap<String, dynamic>();

    map["delete_date"] = util.formatter.format(now);

    Firestore.instance.collection('users').document(username).collection('data').document(itemName).updateData(map);
  }

  Future<QuerySnapshot> getData(String username) async {
    list = List<HashMap<String, String>>();

    return Firestore.instance.collection("users").document(username).collection("data").getDocuments();
  }

  Future<DocumentSnapshot> getDatesFor(String username, String itemName) async {
    print("inside DB getDates");

    return await Firestore.instance.collection("users").document(username).collection("data").document(itemName).get();
  }

  void remove(String username, String documentName, DateTime datetime) {
    final DocumentReference postRef =
        Firestore.instance.collection('users').document(username).collection('data').document(documentName);

    //final DocumentReference postRef = Firestore.instance.collection('auto-id').document(documentName);

    if (postRef != null)
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.data.containsKey("timestemp")) {
          await tx.update(postRef, <String, dynamic>{
            'timestemp': FieldValue.arrayRemove([util.formatter.format(datetime)])
          });
        }
      });
  }

  void update(String username, String documentName, DateTime datetime) {
    final DocumentReference postRef =
        Firestore.instance.collection('users').document(username).collection('data').document(documentName);

    //final DocumentReference postRef = Firestore.instance.collection('auto-id').document(documentName);

    if (postRef != null)
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.data.containsKey("timestemp")) {
          await tx.update(postRef, <String, dynamic>{
            'timestemp': FieldValue.arrayUnion([util.formatter.format(datetime)])
          });
        }
      });
  }
}

final DB db = DB();
