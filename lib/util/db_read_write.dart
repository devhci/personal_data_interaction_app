import 'dart:async';
import 'dart:io';


import 'package:path_provider/path_provider.dart';

class DBStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    print("path"+ path.toString());
    return File('$path/db.json');
  }

  Future<String> readJson() async {

    print("path"+_localFile.toString());

    try {
      final file = await _localFile;

      // Read the file
      String json = await file.readAsString();


      print("Json: "+json);

      return json;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
/*
  Future<File> writeJson(String newEntry) {
    final file = await  _localFile;

    print("Writing to flie "+ newEntry);

    // Write the file
    return file.writeAsString('$newEntry');
  }*/
}