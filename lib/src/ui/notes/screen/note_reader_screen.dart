import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/localization/languages/languages.dart';
import '../../../utils/style/app_style.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../add_note_model.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;
  //final List<AddNoteModel> addNoteList;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  DateTime date = DateTime.now();
  List<AddNoteModel> addNoteList = [];
  List<dynamic> data = [];
  String url = "";
  bool onTap = false;

  @override
  void initState() {
    super.initState();
    if (widget.doc != null) {
      _titleController.text = widget.doc["note_title"];
      _mainController.text = widget.doc["note_content"];
      url = widget.doc["image"];
    } else {
      _titleController.text = "";
      _mainController.text = "";
    }
    getNoteData();
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

  void deleteData(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Notes")
        .doc(widget.doc.id)
        .delete();
    Navigator.pop(context);
  }

  void getNoteData() async {
    List<AddNoteModel> newList = [];

    QuerySnapshot noteValue = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Notes")
        .get();

    noteValue.docs.forEach((element) {
      AddNoteModel addNoteModel = AddNoteModel(title: element.get("list"));
      newList.add(addNoteModel);
    });
    addNoteList = newList;
  }

  bool pinBool = false;

  AddNoteModel? addNote;
  @override
  Widget build(BuildContext context) {
    //_value = List.generate(widget.doc["list"].length, (index) => false);
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColor[color_id],
        elevation: 0.0,
        title: Text(Languages.of(context)!.appBarEditNotes,
            style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                updateData();
              },
              icon: const Icon(Icons.update)),
          IconButton(
              onPressed: () {
                deleteData(context);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                setState(() {
                  pinBool = !pinBool;
                });
                if (pinBool == false) {
                  print("hello");
                } else {
                  deleteData(context);
                  String url = widget.doc["image"];
                  Map<String, dynamic> pinNoteData = {
                    "note_title": _titleController.text,
                    "note_content": _mainController.text,
                    "creation_date":
                        "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
                    "color_id": color_id,
                    "pinned": false,
                    "list": data,
                    "image": url
                  };
                  await FirebaseFirestore.instance
                      .collection("user")
                      .doc(FirebaseAuth.instance.currentUser?.email)
                      .collection("Pins")
                      .add(pinNoteData);
                }
                Navigator.pop(context);
              },
              icon: pinBool == false
                  ? const Icon(Icons.push_pin_outlined)
                  : const Icon(Icons.push_pin)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customTextFormField(_titleController,
                  Languages.of(context)!.addNoteTitle, AppStyle.mainTitle, 1),
              const Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Text(widget.doc["creation_date"], style: AppStyle.dateTitle),
              const Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Container(
                width: double.infinity,
                child: widget.doc["image"] == ""
                    ? const Text("")
                    : Image(image: NetworkImage(widget.doc["image"])),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10.0)),
              customTextFormField(
                  _mainController,
                  Languages.of(context)!.addNoteContent,
                  AppStyle.mainContent,
                  null),
              Container(
                height: 300,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: widget.doc["list"].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.check),
                      title: Text("${widget.doc["list"][index]}"),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
