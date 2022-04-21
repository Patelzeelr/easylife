import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) {
      _titleController.text = widget.doc["note_title"];
      _mainController.text = widget.doc["note_content"];
    } else {
      _titleController.text = "";
      _mainController.text = "";
    }
  }

  void updateData() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Notes")
        .doc(widget.doc.id)
        .update(
      {
        "note_title": _titleController.text,
        "note_content": _mainController.text,
      },
    );
    Navigator.of(context).pop();
  }

  void deleteData() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Notes")
        .doc(widget.doc.id)
        .delete();
    Navigator.pop(context);
  }

  bool pinBool = false;

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                updateData();
              },
              icon: const Icon(Icons.update)),
          IconButton(
              onPressed: () {
                deleteData();
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                setState(() {
                  pinBool = !pinBool;
                });
                if (pinBool == false) {
                  deleteData();
                  Navigator.pop(context);
                } else {
                  deleteData();
                  Map<String, dynamic> pinNoteData = {
                    "note_title": _titleController.text,
                    "note_content": _mainController.text,
                    "creation_date":
                        "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
                    "color_id": color_id,
                    "pinned": false
                  };
                  await FirebaseFirestore.instance
                      .collection("user")
                      .doc(FirebaseAuth.instance.currentUser?.email)
                      .collection("Pins")
                      .add(pinNoteData);
                  Navigator.pop(context);
                  //getPinBool();
                }
              },
              icon: pinBool == false
                  ? const Icon(Icons.push_pin_outlined)
                  : const Icon(Icons.push_pin)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Add note title"),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 8.0),
            Text(widget.doc["creation_date"], style: AppStyle.dateTitle),
            const SizedBox(height: 28.0),
            TextFormField(
              controller: _mainController,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Add note description"),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
