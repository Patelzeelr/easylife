import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';

import '../../dashboard/home_screen.dart';
import '../method/validation_method.dart';
import '../widgets/button.dart';
import '../widgets/text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool isIndicate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: isIndicate
            ? const CircularProgressIndicator(color: Colors.white)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_note_sharp,
                      color: Colors.white, size: 100.0),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  const Text("Login",
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                  const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                  textFormField(validateEmail, _emailController, false,
                      "Enter your email", Icons.email, (value) {}),
                  const Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  textFormField(validatePassword, _passwordController, true,
                      "Enter your password", Icons.lock, (value) {}),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  _forgotPassword(),
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  button(() async {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                      if (user != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      }
                    } catch (e) {}
                  }, "Login"),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  _row()
                ],
              ),
      ),
    );
  }

  Widget _forgotPassword() => GestureDetector(
        onTap: () {},
        child: const Align(
            alignment: Alignment.topRight,
            child: Text('Forgot Password?',
                style: TextStyle(color: Colors.white))),
      );

  Widget _row() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Dont have an acoount?',
              style: TextStyle(color: Colors.white)),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: const Text('Regiser',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      );
}
