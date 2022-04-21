import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../style/app_style.dart';
import '../../widgets/custom_text_form_field.dart';

class ViewPinScreen extends StatefulWidget {
  ViewPinScreen(this.doc,{Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<ViewPinScreen> createState() => _ViewPinScreenState();
}

class _ViewPinScreenState extends State<ViewPinScreen> {
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if(widget.doc != null){
      _titleController.text = widget.doc["note_title"];
      _mainController.text = widget.doc["note_content"];
    } else {
      _titleController.text = "";
      _mainController.text = "";
    }

  }
  void updateData() {
    FirebaseFirestore.instance.collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email).collection("Pins").doc(widget.doc.id).update(
      {
        "note_title": _titleController.text,
        "note_content": _mainController.text,
      },
    );
    Navigator.of(context).pop();
  }

  void deleteData() {
    FirebaseFirestore.instance.collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email).collection("Pins").doc(widget.doc.id).delete();
    Navigator.pop(context);
  }

  bool wishListBool = true;

  Future getPinBool() async {
    final snapshots = await FirebaseFirestore.instance
        .collection("Pins")
        .doc(widget.doc.id)
        .get();

    setState(() {
      wishListBool = snapshots.get('pinned');
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
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: () {updateData();}, icon: const Icon(Icons.update)),
          IconButton(onPressed: () {deleteData();}, icon: const Icon(Icons.delete)),
          IconButton(onPressed: () async{
            setState(() {
              wishListBool = !wishListBool;
            });
            if(wishListBool == false) {
              await FirebaseFirestore.instance.collection("user")
                  .doc(FirebaseAuth.instance.currentUser?.email).collection("Pins").doc(widget.doc.id).delete();
              Map<String, dynamic> noteData = {
                "note_title": _titleController.text,
                "note_content": _mainController.text,
                "creation_date": "${date.day}-${date.month}-${date.hour} ${date.hour}:${date.minute}",
                "color_id": color_id,
                "pinned": false
              };
              await FirebaseFirestore.instance.collection("user")
                  .doc(FirebaseAuth.instance.currentUser?.email).collection('Notes').add(noteData);
              Navigator.pop(context);
            } else {
              getPinBool();
            }
          },
              icon: wishListBool == false ? const Icon(Icons.push_pin_outlined) : const Icon(Icons.push_pin)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}
