import 'package:flutter/material.dart';

Widget button(VoidCallback onPressed, String label) => Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: FlatButton(
        height: 42,
        minWidth: double.infinity,
        color: Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
    );
