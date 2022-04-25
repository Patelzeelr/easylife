import 'package:flutter/material.dart';

Widget customTextFormField(TextEditingController controller,String hint,TextStyle style,final maxLines) => TextFormField(
  controller: controller,
  decoration:  InputDecoration(
      border: InputBorder.none,
      hintText: hint
  ),
  style: style,
  maxLines: maxLines,
);