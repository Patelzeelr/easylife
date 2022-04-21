import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../style/app_style.dart';
import '../../widgets/custom_text_form_field.dart';


class ViewDairyScreen extends StatefulWidget {
  ViewDairyScreen(this.doc,{Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<ViewDairyScreen> createState() => _ViewDairyScreenState();
}

class _ViewDairyScreenState extends State<ViewDairyScreen> {
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();

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
        .doc(FirebaseAuth.instance.currentUser?.email).collection("Dairy").doc(widget.doc.id).update(
      {
        "note_title": _titleController.text,
        "note_content": _mainController.text,
      },
    );
    Navigator.of(context).pop();
  }

  void deleteData() {
    FirebaseFirestore.instance.collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email).collection("Dairy").doc(widget.doc.id).delete();
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customTextFormField(_titleController, "Add note title", AppStyle.mainTitle),
            const Padding(padding: EdgeInsets.only(bottom: 28.0)),
            customTextFormField(_mainController, "Add note content", AppStyle.mainContent),
          ],
        ),
      ),
    );
  }
}
