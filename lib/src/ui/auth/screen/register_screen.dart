import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                      const Padding(padding: EdgeInsets.only(top: 10.0)),
                      const Text("Register",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                      const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                      textFormField(
                          validateUsername,
                          _userNameController,
                          false,
                          "Enter your Username",
                          Icons.account_circle,
                          (value) {}),
                      const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      textFormField(validateEmail, _emailController, false,
                          "Enter your email", Icons.email, (value) {}),
                      const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      textFormField(validatePassword, _passwordController, true,
                          "Enter your password", Icons.lock, (value) {}),
                      const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      textFormField(
                          validateDairyPassword,
                          _dairyNumberController,
                          true,
                          "Enter password to protect dairy",
                          Icons.key,
                          (value) {}),
                      const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                      button(() async {
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                          _addUser();
                          if (newUser != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          }
                        } catch (e) {
                          print(e);
                        }
                      }, "Register"),
                      const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                      _row()
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
          const Text('Already have an acoount?',
              style: TextStyle(color: Colors.white)),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Text('Login',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      );
}
