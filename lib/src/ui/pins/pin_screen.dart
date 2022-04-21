import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:take_notes/src/ui/pins/view_pin_screen.dart';

import '../../widgets/note_card.dart';

class PinScreen extends StatelessWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("user")
                    .doc(FirebaseAuth.instance.currentUser?.email).collection("Pins").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } if(snapshot.hasData){
                    return GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: snapshot.data!.docs.map((note) => noteCard((){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPinScreen(note)));
                      }, note)).toList(),
                    );
                  }
                  return const Text("TODO");
                },
              ),
            ),
          ],
        )
    );
  }
}
