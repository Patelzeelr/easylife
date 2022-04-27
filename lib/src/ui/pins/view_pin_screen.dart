import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/localization/languages/languages.dart';
import '../../utils/style/app_style.dart';
import '../../widgets/custom_text_form_field.dart';

class ViewPinScreen extends StatefulWidget {
  ViewPinScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<ViewPinScreen> createState() => _ViewPinScreenState();
}

class _ViewPinScreenState extends State<ViewPinScreen> {
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  DateTime date = DateTime.now();
  List<dynamic> data = [];

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

  void _updateData() {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Pins")
        .doc(widget.doc.id)
        .update(
      {
        "note_title": _titleController.text,
        "note_content": _mainController.text,
      },
    );
    Navigator.of(context).pop();
  }

  void _deleteData() {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection("Pins")
        .doc(widget.doc.id)
        .delete();
    Navigator.pop(context);
  }

  bool pinBool = true;

  Future _getPinBool() async {
    final snapshots = await FirebaseFirestore.instance
        .collection("Pins")
        .doc(widget.doc.id)
        .get();

    setState(() {
      pinBool = snapshots.get('pinned');
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColor[color_id],
        elevation: 0.0,
        title: Text(Languages.of(context)!.appBarPinNotes,
            style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          _pinIconButton(context),
          _iconButton(() {
            _updateData();
          }, Icons.update),
          _iconButton(() {
            _deleteData();
          }, Icons.delete),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('${date}', style: AppStyle.dateTitle),
              ),
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
                  20),
              _checkList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkList() => SizedBox(
        height: 100,
        child: ListView.builder(
          itemCount: widget.doc["list"].length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.check),
              title: Text("${widget.doc["list"][index]}"),
            );
          },
        ),
      );

  Widget _pinIconButton(BuildContext context) => IconButton(
      onPressed: () async {
        setState(() {
          pinBool = !pinBool;
        });
        if (pinBool == false) {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(FirebaseAuth.instance.currentUser?.email)
              .collection("Pins")
              .doc(widget.doc.id)
              .delete();
          String url = widget.doc["image"];
          Map<String, dynamic> noteData = {
            "note_title": _titleController.text,
            "note_content": _mainController.text,
            "creation_date":
                "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
            "color_id": widget.doc['color_id'],
            "pinned": false,
            "list": data,
            "image": url
          };
          await FirebaseFirestore.instance
              .collection("user")
              .doc(FirebaseAuth.instance.currentUser?.email)
              .collection('Notes')
              .add(noteData);
          Navigator.pop(context);
        } else {
          _getPinBool();
        }
      },
      icon: pinBool == false
          ? const Icon(Icons.push_pin_outlined)
          : const Icon(Icons.push_pin));

  Widget _iconButton(VoidCallback onPress, IconData icons) =>
      IconButton(onPressed: onPress, icon: Icon(icons));
}
