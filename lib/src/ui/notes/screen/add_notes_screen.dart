import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../style/app_style.dart';
import '../../../widgets/custom_text_form_field.dart';

class AddNotesScreen extends StatefulWidget {
  final List<TextEditingController> controllers;

  const AddNotesScreen({Key? key, required this.controllers}) : super(key: key);

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  int color_id = Random().nextInt(AppStyle.cardColor.length);
  DateTime date = DateTime.now();
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  bool pinBool = false;

  final checkListController = TextEditingController();
  List<TextFormField> checkLists = [];
  List<String?> data = [];
  //List<bool> isChecked = [false];

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? file;

  void _addCheckListContainer(controller) {
    setState(() {
      checkLists.add(checkBoxListTile(controller));
    });
  }

  void _addNotes() async {
    String url = "";
    checkLists.forEach((element) {
      data.add(element.controller?.text);
    });
    if (file != null) {
      url = await uploadImage();
    }
    Map<String, dynamic> noteData = {
      "note_title": _titleController.text,
      "note_content": _mainController.text,
      "creation_date":
          "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
      "color_id": color_id,
      "pinned": false,
      "list": data,
      "image": url,
    };
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('Notes')
        .add(noteData);
  }

  void _addPinNotes() async {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextFormField(
                  _titleController, "Add note title", AppStyle.mainTitle, 1),
              const Padding(padding: EdgeInsets.only(bottom: 8.0)),
              Text('${date}', style: AppStyle.dateTitle),
              const Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Container(
                width: double.infinity,
                child: file != null
                    ? Image(image: FileImage(file!))
                    : const Text(""),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10.0)),
              customTextFormField(_mainController, "Add note content",
                  AppStyle.mainContent, null),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkLists.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: checkLists[i],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _floatingButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _bottomBar(context),
    );
  }

  Widget _floatingButton(context) => FloatingActionButton(
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
      );

  Widget _bottomBar(context) => Row(
        children: [
          IconButton(
              onPressed: () {
                _addOption(context);
              },
              icon: const Icon(Icons.add_box_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      );

  _addOption(context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: AppStyle.cardColor[color_id],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _customListTile(() {
                  setState(() {
                    var textEditingController = TextEditingController();
                    widget.controllers.add(textEditingController);
                    _addCheckListContainer(textEditingController);
                  });
                  Navigator.pop(context);
                }, Icons.check_box_outlined, 'List'),
                _customListTile(() {
                  chooseImage();
                }, Icons.image, 'Add Image'),
                _customListTile(() {}, Icons.brush, 'Paint'),
              ],
            ),
          ),
        );
      });

  Widget _customListTile(VoidCallback onTap, IconData icon, String text) =>
      GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(text, style: const TextStyle(color: Colors.black)),
        ),
      );

  TextFormField checkBoxListTile(controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: IconButton(
          onPressed: () {
            setState(() {
              widget.controllers.remove(controller);
              checkLists
                  .removeWhere((element) => element.controller == controller);
            });
          },
          icon: const Icon(Icons.clear, color: Colors.black),
        ),
      ),
    );
  }

  Future<String> uploadImage() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("images")
        .child(basename(file!.path))
        .putFile(file!);

    return taskSnapshot.ref.getDownloadURL();
  }

  chooseImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File(xFile!.path);
    setState(() {});
  }
}
