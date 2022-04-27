import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/localization/languages/languages.dart';
import '../../dashboard/home_screen.dart';
import '../method/validation_method.dart';
import '../widgets/button.dart';
import '../widgets/text_form_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isIndicate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: isIndicate
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event_note_sharp,
                        color: Colors.white, size: 100.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(Languages.of(context)!.labelSignin,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: textFormField(
                          validateEmail,
                          _emailController,
                          false,
                          Languages.of(context)!.labelEmail,
                          Icons.email,
                          (value) {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: textFormField(
                          validatePassword,
                          _passwordController,
                          true,
                          Languages.of(context)!.labelAuthPassword,
                          Icons.lock,
                          (value) {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _forgotPassword(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: button(() async {
                        try {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            setState(() {
                              isIndicate = true;
                            });
                          }
                          final user = await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);

                          if (user != null) {
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          }
                        } catch (e) {
                          setState(() {
                            isIndicate = false;
                          });
                        }
                      }, Languages.of(context)!.labelSigninButton),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _row(),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _forgotPassword() => GestureDetector(
        onTap: () {},
        child: Align(
            alignment: Alignment.topRight,
            child: Text(Languages.of(context)!.labelForgotPassword,
                style: const TextStyle(color: Colors.white))),
      );

  Widget _row() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Languages.of(context)!.labelDoNotHaveAnAccount,
              style: const TextStyle(color: Colors.white)),
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: Text(Languages.of(context)!.labelSignup,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      );
}
