import 'package:flutter/cupertino.dart';

class AddNoteModel {
  bool checkBoxValue;
  List<dynamic> title;

  AddNoteModel({required this.title, this.checkBoxValue = false});
}