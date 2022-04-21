import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class NoteProvider extends ChangeNotifier {
  void addNotePin(
      {required String note_title,
      required String note_content,
      required DateTime creation_date,
      required int color_id}) async {
    Map<String, dynamic> pinNoteData = {
      "note_title": note_title,
      "note_content": note_content,
      "creation_date": creation_date,
      "color_id": color_id,
      "pinned": true
    };
    await FirebaseFirestore.instance.collection("Pins").add(pinNoteData);
  }

  /*void updateNote(Notes note, String title, String content) {
    note.note_title = title;
    note.note_content = content;

    notifyListeners();
  }*/

  void updateNote({
    required String title,
    required String content,
  }) async {
    FirebaseFirestore.instance.collection("Notes").doc().update(
      {
        "note_title": title,
        "note_content": content,
      },
    );
    notifyListeners();
  }
}
