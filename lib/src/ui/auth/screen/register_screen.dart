import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/localization/languages/languages.dart';
import '../../dashboard/home_screen.dart';
import '../method/validation_method.dart';
import '../widgets/button.dart';
import '../widgets/text_form_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _dairyNumberController = TextEditingController();
  late bool isIndicate = false;

  void _addUser() {
    Map<String, dynamic> userData = {
      'name': _userNameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'dairy': _dairyNumberController.text
    };
    _firestore.collection('user').doc(_emailController.text).set(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: isIndicate
            ? const CircularProgressIndicator(color: Colors.white)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.event_note_sharp,
                          color: Colors.white, size: 100.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(Languages.of(context)!.labelSignup,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: textFormField(
                            validateUsername,
                            _userNameController,
                            false,
                            Languages.of(context)!.labelUserName,
                            Icons.account_circle,
                            (value) {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: textFormField(
                            validateEmail,
                            _emailController,
                            false,
                            Languages.of(context)!.labelEmail,
                            Icons.email,
                            (value) {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: textFormField(
                            validatePassword,
                            _passwordController,
                            true,
                            Languages.of(context)!.labelAuthPassword,
                            Icons.lock,
                            (value) {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: textFormField(
                            validateDairyPassword,
                            _dairyNumberController,
                            true,
                            Languages.of(context)!.labelProtectDiary,
                            Icons.key,
                            (value) {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: button(() async {
                          try {
                            if (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              setState(() {
                                isIndicate = true;
                              });
                            }
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            _addUser();
                            if (newUser != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            }
                          } catch (e) {
                            setState(() {
                              isIndicate = false;
                            });
                          }
                        }, Languages.of(context)!.labelSignupButton),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _row(),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _row() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Languages.of(context)!.labelAlreadyHaveAnAccount,
              style: const TextStyle(color: Colors.white)),
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: Text(Languages.of(context)!.labelSignin,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      );
}
