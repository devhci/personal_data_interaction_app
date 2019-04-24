import 'dart:async';
import 'Aspect.dart';
import 'package:rxdart/rxdart.dart';

class Bloc {
  final _selectedTabController = StreamController<TabElement>.broadcast();
  final _addAspectController = StreamController<Aspect>.broadcast();
  final _deleteAspectController = StreamController<Aspect>.broadcast();
  final _dateController = BehaviorSubject<DateTime>();

  // Add data to stream
  Function(TabElement) get changeSelectedTabElement => _selectedTabController.sink.add;
  Function(Aspect) get addAspect => _addAspectController.sink.add;
  Function(Aspect) get deleteAspect => _deleteAspectController.sink.add;
  Function(DateTime) get changeDate => _dateController.sink.add;

  // Retrieve data from stream
  Stream<TabElement> get tabElement => _selectedTabController.stream;
  Stream<Aspect> get aspectsToAdd => _addAspectController.stream;
  Stream<Aspect> get aspectsToDelete => _deleteAspectController.stream;
  Stream<DateTime> get date => _dateController.stream;

  dispose() {
    _selectedTabController.close();
    _addAspectController.close();
    _deleteAspectController.close();
    _dateController.close();
  }
}

final bloc = Bloc();

enum TabElement { Pick, Track, AddDelete }
