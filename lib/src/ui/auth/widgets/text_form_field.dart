import 'package:flutter/material.dart';

Widget textFormField(final validator,TextEditingController controller,bool textShow,String hintText,IconData icon,Function(String) onChange) => TextFormField(
  autovalidateMode: AutovalidateMode.onUserInteraction,
  keyboardType: TextInputType.emailAddress,
  cursorColor: Colors.white,
  obscureText: textShow,
  decoration: InputDecoration(
    enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54,width: 2.0)
    ),
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white,width: 2.0)
    ),
    hintText: hintText,
    hintStyle: const TextStyle(
        color: Colors.white
    ),
    prefixIcon: Icon(icon,color: Colors.white),
  ),
  controller: controller,
  validator: validator,
  onChanged: onChange,
  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
);