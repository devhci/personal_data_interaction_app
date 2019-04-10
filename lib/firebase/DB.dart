
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class DB {

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  Future<dynamic> getDoc(){




  }

  Future<void> createNewItem(String itemName){

    HashMap<String,dynamic> map=HashMap<String,dynamic>();

    map["timestemp"]= Timestamp.now() ;


    if (Firestore.instance.collection('auto-id').document(itemName).snapshots() == null) {
      Firestore.instance.collection('auto-id').document(itemName).setData(map);
}

    /*Firestore.instance.collection('auto-id').document(itemName).setData(map);
*/
  }
  Future<void> deleteItem(String itemName){

    HashMap<String,dynamic> map=HashMap<String,dynamic>();

    map["createdOn"]= Timestamp.now() ;

    Firestore.instance.collection('auto-id').document(itemName).delete();

  }

  
   getData() async{
    return Firestore.instance.collection("auto-id").getDocuments();
  }


  Future<void> remove(String documentName){

    final DocumentReference postRef = Firestore.instance.collection('auto-id').document(documentName);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.data.containsKey("timestemp")) {
        await tx.update(postRef, <String, dynamic>{'timestemp': FieldValue.arrayUnion([formatter.format(now)])});
      }
    });



  }


  Future<void> update(String documentName){

    final DocumentReference postRef = Firestore.instance.collection('auto-id').document(documentName);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.data.containsKey("timestemp")) {
        await tx.update(postRef, <String, dynamic>{'timestemp': FieldValue.arrayRemove([formatter.format(now)])});
      }
    });


  }


}