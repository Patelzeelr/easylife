import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/localization/languages/languages.dart';
import '../../utils/style/app_style.dart';
import '../../widgets/custom_text_form_field.dart';
import 'dairy_screen.dart';

class AddDairyScreen extends StatefulWidget {
  const AddDairyScreen({Key? key}) : super(key: key);

  @override
  State<AddDairyScreen> createState() => _AddDairyScreenState();
}

class _AddDairyScreenState extends State<AddDairyScreen> {
  int color_id = Random().nextInt(AppStyle.cardColor.length);
  final _titleController = TextEditingController();
  final _mainController = TextEditingController();
  final _passwordController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String dairy = "";

  void _addDairy() async {
    Map<String, dynamic> dairyData = {
      "note_title": _titleController.text,
      "note_content": _mainController.text,
      "color_id": color_id,
    };
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('Dairy')
        .add(dairyData);
  }

  void _clear() {
    _titleController.clear();
    _mainController.clear();
  }

  Future _getCurrentUser() async {
    final snapshots = await FirebaseFirestore.instance
        .collection("user")
        .doc(user?.email)
        .get();

    setState(() {
      dairy = snapshots.get('dairy');
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _floatingButton(),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Center(child: foldedNoteCard()),
            ],
          ),
        ));
  }

  Widget foldedNoteCard() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipPath(
          clipper: Clip1Clipper(),
          child: Container(
            height: 500,
            width: 500,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            color: AppStyle.cardColor[color_id],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customTextFormField(
                    _titleController,
                    Languages.of(context)!.addDiaryTitle,
                    AppStyle.mainTitle,
                    1),
                const Padding(padding: EdgeInsets.only(bottom: 28.0)),
                customTextFormField(
                    _mainController,
                    Languages.of(context)!.addDiaryContent,
                    AppStyle.mainContent,
                    20),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: ClipClipper(),
          child: Container(
            margin: const EdgeInsets.all(8.1),
            height: 100,
            width: 100,
            color: Colors.grey.withOpacity(0.5),
            child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    _addDairy();
                    _clear();
                  },
                  icon: const Icon(Icons.save_alt),
                )),
          ),
        ),
      ],
    );
  }

  Widget _floatingButton() => FloatingActionButton(
    backgroundColor: Colors.grey,
    onPressed: (){_showPasswordDialog();},
    child: const Icon(Icons.note, color: Colors.white),
  );

  _showPasswordDialog() => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(Languages.of(context)!.labelPassword,
              style: const TextStyle(color: Colors.white)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Languages.of(context)!.addDiaryPassword,
                hintStyle: const TextStyle(color: Colors.white),
              ),
              style: AppStyle.mainContent.copyWith(color: Colors.white),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white54)),
                onPressed: () {
                  if (_passwordController.text == dairy) {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DairyScreen()))
                        .then((value) => Navigator.pop(context));
                    _passwordController.clear();
                  } else {
                    Navigator.pop(context);
                    _passwordController.clear();
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ))
          ]),
        );
      });
}

class ClipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 114);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Clip1Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width / 1.5, size.height);
    path.lineTo(size.width, 400);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
