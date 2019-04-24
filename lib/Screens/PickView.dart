import 'package:flutter/material.dart';
import 'package:personal_data_interaction_app/UI Elements/ui_elements.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import 'package:personal_data_interaction_app/aspect.dart';

class PickView extends StatefulWidget {
  final TabElement mode;
  final List<Aspect> aspects;

  PickView({this.mode, this.aspects});

  @override
  _PickViewState createState() => _PickViewState();
}

class _PickViewState extends State<PickView> {
  Widget aspectCellBuilder(BuildContext context, int index) {
    if (widget.mode == TabElement.AddDelete) {
      if (index == widget.aspects.length) {
        return AddNewAspectCell();
      }
    }
    return AspectCell(
      aspect: widget.aspects[index],
      isEditMode: (widget.mode == TabElement.AddDelete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: aspectCellBuilder,
      // Add one more for the "add cell"
      itemCount: widget.mode == TabElement.AddDelete ? widget.aspects.length + 1 : widget.aspects.length,
    );
  }
}
