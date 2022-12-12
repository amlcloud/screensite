import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade100,
    // primaryColor: Colors.grey[600],
    // backgroundColor: Color.fromARGB(255, 201, 201, 201),
    colorScheme: const ColorScheme(
        primary: Color.fromARGB(255, 165, 165, 165),
        secondary: Color.fromARGB(255, 255, 153, 10),
        onPrimary: Colors.white,
        onSecondary: Color(0xff303035),
        background: Color(0xffcdcbc9),
        surface: Colors.white,
        onSurface: Color(0xffcdcbc9),
        onBackground: Colors.white,
        error: Colors.red,
        brightness: Brightness.light,
        onError: Colors.white),
    textTheme: const TextTheme(
        // bodyText1: TextStyle(
        //   color: Colors.white,
        // ),
        bodyText2: TextStyle(
      color: Color.fromARGB(255, 255, 153, 10), //change link color to orange
    )));

final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    backgroundColor: Color(0xff181a1b),
    colorScheme: const ColorScheme(
        primary: Color(0xffcdcbc9),
        secondary: Colors.grey,
        onPrimary: Colors.blueGrey,
        onSecondary: Color(0xff303035),
        background: Color(0xff303035),
        surface: Colors.black54,
        onSurface: Color(0xffcdcbc9),
        onBackground: Color(0xffcdcbc9),
        error: Colors.red,
        brightness: Brightness.dark,
        onError: Color(0xffcdcbc9)),
    textTheme: const TextTheme(
        bodyText2: TextStyle(
      color: Color.fromARGB(255, 255, 153, 10), //change link color to orange
    )));

//style static class for login_page
class LoginStyle {
  static ButtonStyle buttonStyle = ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(350, 50)),
      maximumSize: MaterialStateProperty.all(Size(350, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.white));
  static TextStyle buttontextStyle = TextStyle(
      fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500);
  static TextStyle titleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  static TextStyle linkStyle = TextStyle(fontSize: 18, color: Colors.blueGrey);
  static BoxDecoration containerStyle = BoxDecoration(
      border: Border(
          right: BorderSide(
    color: Colors.grey,
  )));
  static BoxDecoration seperatedLine = BoxDecoration(
      border: Border(
          top: BorderSide(
    color: Color.fromARGB(255, 208, 208, 208),
  )));
}

class EntityContainerStyle {
  static BoxDecoration containerStyle = BoxDecoration(
      border: Border.all(color: Color.fromARGB(255, 236, 238, 240)));
}
