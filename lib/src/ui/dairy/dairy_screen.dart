import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'view_dairy_screen.dart';
import '../../widgets/dairy_card.dart';


class DairyScreen extends StatefulWidget {
  const DairyScreen({Key? key}) : super(key: key);

  @override
  State<DairyScreen> createState() => _DairyScreenState();
}

class _DairyScreenState extends State<DairyScreen> {


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
                    .doc(FirebaseAuth.instance.currentUser?.email).collection("Dairy").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } if(snapshot.hasData){
                    return GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: snapshot.data!.docs.map((dairy) => dairyCard((){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDairyScreen(dairy)));
                      }, dairy)).toList(),
                    );
                  }
                  return const Text("Dairy");
                },
              ),
            ),
          ],
        )
    );
  }
}
