import 'package:flutter/material.dart';

// ignore: camel_case_types
abstract class styleText {
  static const TextStyle loginText = TextStyle(
    fontSize: 20,
  );
  static const TextStyle registerText = TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 81, 69, 250),
      fontFamily: 'Urbanist');

  static const TextStyle EditHeaderText =
      TextStyle(fontSize: 22, color: Colors.white, fontFamily: 'Urbanist');

  static const TextStyle select_button_white =
      TextStyle(color: Colors.white, fontFamily: 'Urbanist');

  static const TextStyle styleNameProfile = TextStyle(
      color: Colors.black,
      fontFamily: 'Urbanist',
      fontSize: 21,
      fontWeight: FontWeight.w500);

  static const TextStyle styleIDProfile =
      TextStyle(color: Colors.black, fontFamily: 'Urbanist', fontSize: 15);
}
