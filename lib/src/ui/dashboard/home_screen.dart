import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:take_notes/src/ui/pins/pin_screen.dart';
import '../dairy/add_dairy_screen.dart';
import '../auth/screen/login_screen.dart';
import '../notes/note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          title: const Text("Maintain Your Life"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
          bottom: const TabBar(
            indicator: BoxDecoration(
              color: Colors.white24,
            ),
            tabs: [
              Tab(text: 'Notes'),
              Tab(text: 'Pin'),
              Tab(text: 'Dairy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [NoteScreen(), PinScreen(), AddDairyScreen()],
        ),
      ),
    );
  }
}
