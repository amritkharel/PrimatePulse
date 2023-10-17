import 'package:flutter/material.dart';

const backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFFF4D35E),
      Color(0xFFF3D053),
      Color(0xFFF2CB40),
      Color(0xFFF0C62D),
      Color(0xFFEFC11A),
    ],
    stops: [
      0.1,
      0.2,
      0.6,
      0.9,
      1,
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  ),
);

final textFieldProperty = InputDecoration(

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
  ),
  hintText: "Email Address",
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.circular(30.0),
  ),
);