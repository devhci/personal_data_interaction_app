import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:personal_data_interaction_app/firebase/DB.dart';

class Util{

  DB _db= DB();

 Future<List<String> > giveListOfDateForCalenderVisualization() async{

     List<String> dates= List<String>();
    DocumentSnapshot documentSnapshot =
     await _db.getDatesFor("koriawas@dtu.dk", "Playing football");

    var a = documentSnapshot.data.remove("timestemp");

    print(a);



     List<String > list  = a.toString().replaceAll("[", "").replaceAll("]", "").split(",");

      print(list);

    return  list;
  }



}