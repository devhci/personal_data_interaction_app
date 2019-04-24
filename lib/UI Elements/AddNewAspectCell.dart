import 'package:flutter/material.dart';
import 'MyColors.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'RoundedButton.dart';
import 'package:personal_data_interaction_app/blocs.dart';
import '../aspect.dart';

import 'package:personal_data_interaction_app/firebase/DB.dart';

class AddNewAspectCell extends StatefulWidget {
  @override
  _AddNewAspectCellState createState() => _AddNewAspectCellState();
}

class _AddNewAspectCellState extends State<AddNewAspectCell> {
  Color color;
  TextEditingController textEditingController;
  bool validate;

  @override
  void initState() {
    validate = false;
    textEditingController = TextEditingController();

    int rnd = Random().nextInt(Colors.accents.length);
    color = Colors.accents[rnd];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = 45;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 80,
        decoration: BoxDecoration(
            color: MyColors.lightGrey,
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(2, 4), blurRadius: 10),
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(-1, -1), blurRadius: 5)
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 7,
              child: TextField(
                maxLength: maxLength,
                controller: textEditingController,
                onChanged: (s) {
                  setState(() {
                    textEditingController.text.isEmpty ? validate = false : validate = true;
                  });
                },
              ),
            ),
            Flexible(
              flex: 3,
              child: RoundedButton(
                color: MyColors.darkBlue,
                onPressed: validate
                    ? () {
                        db.createNewItem(
                          "koriawas@dtu.dk",
                          textEditingController.value.text,
                          color.value.toRadixString(16),
                        );
                        print("this is the place where I should create the new aspect");
                        print("with this title: ${textEditingController.value.text}");
                        print("and this color: $color");
                        bloc.addAspect(
                          Aspect(textEditingController.value.text, [], color.value.toRadixString(16)),
                        );
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    : null,
                text: "Add",
              ),
            )
          ],
        ),
      ),
    );
  }
}
