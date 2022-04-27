import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:take_notes/src/ui/pins/pin_screen.dart';
import '../../utils/localization/languages/languages.dart';
import '../../utils/localization/locale_constants.dart';
import '../dairy/add_dairy_screen.dart';
import '../auth/screen/login_screen.dart';
import '../notes/screen/note_screen.dart';

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
          title: Text(Languages.of(context)!.mainAppBar),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                color: Colors.black,
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () async{
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const Padding(padding: EdgeInsets.only(left: 10.0)),
                          Text(Languages.of(context)!.popUpLogout,style: const TextStyle(color: Colors.white))
                        ],
                      ),
                  ),
                  PopupMenuItem(
                    onTap: (){
                      Future.delayed(
                          const Duration(seconds: 0),
                              () => _showLanguageDialog(context),
                      );
                      print("object");
                    },
                      child: Row(
                        children: [
                          const Icon(Icons.language),
                          const Padding(padding: EdgeInsets.only(left: 10.0)),
                          Text(Languages.of(context)!.popUpLanguage,style: const TextStyle(color: Colors.white))
                        ],
                      ),
                  ),
                ]
            ),
          ],
          bottom: TabBar(
            indicator: const BoxDecoration(
              color: Colors.white24,
            ),
            tabs: [
              Tab(text: Languages.of(context)!.labelNotes),
              Tab(text: Languages.of(context)!.labelPin),
              Tab(text: Languages.of(context)!.labelDairy),
            ],
          ),
        ),
        body: const TabBarView(
          children: [NoteScreen(), PinScreen(), AddDairyScreen()],
        ),
      ),
    );
  }
  _showLanguageDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(Languages.of(context)!.labelSelectLanguage,style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  changeLanguage(context, 'en');
                  Navigator.pop(context);
                },
                child: Row(
                  children: const [
                    Text('🇺🇸'),
                    SizedBox(width: 10.0),
                    Text('English',style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  changeLanguage(context, 'hi');
                  Navigator.pop(context);
                },
                child: Row(
                  children: const [
                    Text('🇮🇳'),
                    SizedBox(width: 10.0),
                    Text('हिन्दी', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
