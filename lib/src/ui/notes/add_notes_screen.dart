import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../style/app_style.dart';

import '../../widgets/custom_text_form_field.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({Key? key}) : super(key: key);

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  int color_id = Random().nextInt(AppStyle.cardColor.length);
  DateTime date = DateTime.now();
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  bool pinBool = false;

  void _addNotes() {
    Map<String, dynamic> noteData = {
      "note_title": _titleController.text,
      "note_content": _mainController.text,
      "creation_date":
          "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
      "color_id": color_id,
      "pinned": false
    };
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('Notes')
        .add(noteData);
  }

  void _addPinNotes() {
    Map<String, dynamic> pinNoteData = {
      "note_title": _titleController.text,
      "note_content": _mainController.text,
      "creation_date":
          "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
      "color_id": color_id,
      "pinned": false
    };
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Pins")
        .add(pinNoteData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  pinBool = !pinBool;
                });
              },
              icon: pinBool == false
                  ? const Icon(Icons.push_pin_outlined)
                  : const Icon(Icons.push_pin)),
        ],
        title: const Text(
          "Add a new note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextFormField(
                _titleController, "Add note title", AppStyle.mainTitle),
            const Padding(padding: EdgeInsets.only(bottom: 8.0)),
            Text('${date}', style: AppStyle.dateTitle),
            const Padding(padding: EdgeInsets.only(bottom: 28.0)),
            customTextFormField(
                _mainController, "Add note content", AppStyle.mainContent),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pinBool == false) {
            _addNotes();
          } else {
            _addPinNotes();
          }
          Navigator.pop(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.save_alt),
      ),
    );
  }
}
