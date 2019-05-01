import 'dart:async';
import 'aspect.dart';
import 'package:rxdart/rxdart.dart';
import 'package:personal_data_interaction_app/util/util.dart';

class Bloc {
  final _selectedTabController = StreamController<TabElement>.broadcast();
  final _addAspectStatusController = StreamController<bool>.broadcast();
  final _deleteAspectController = StreamController<Aspect>.broadcast();
  final _dateController = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _selectedAspectNameController = StreamController<String>.broadcast();

  // Add data to stream
  Function(TabElement) get changeSelectedTabElement => _selectedTabController.sink.add;
  Function(bool) get sendAddAspectStatus => _addAspectStatusController.sink.add;
  Function(Aspect) get deleteAspect => _deleteAspectController.sink.add;
  Function(DateTime) get changeDate => _dateController.sink.add;
  Function(String) get sendSelectedAspectName => _selectedAspectNameController.sink.add;

  // Retrieve data from stream
  Stream<TabElement> get tabElement => _selectedTabController.stream;
  Stream<bool> get addAspectStatus => _addAspectStatusController.stream;
  Stream<Aspect> get aspectsToDelete => _deleteAspectController.stream;
  Stream<DateTime> get date => _dateController.stream.map((date) => util.formatter.parse(date.toString()));
  Stream<String> get selectedAspectName => _selectedAspectNameController.stream.map((name) {
    changeSelectedTabElement(TabElement.Calendar);
    return name;
  });

  dispose() {
    _selectedTabController.close();
    _addAspectStatusController.close();
    _deleteAspectController.close();
    _dateController.close();
    _selectedAspectNameController.close();
  }
}

final bloc = Bloc();

enum TabElement { Pick, Track, AddDelete, Calendar }
