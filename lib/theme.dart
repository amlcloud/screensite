import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    // scaffoldBackgroundColor: Colors.black,
    // primaryColor: Colors.white,
    // backgroundColor: Color(0xff181a1b),
    // colorScheme: const ColorScheme(
    //     primary: Color(0xffcdcbc9),
    //     secondary: Colors.grey,
    //     onPrimary: Colors.blueGrey,
    //     onSecondary: Color(0xff303035),
    //     background: Color(0xff303035),
    //     surface: Colors.black54,
    //     onSurface: Color(0xffcdcbc9),
    //     onBackground: Color(0xffcdcbc9),
    //     error: Colors.red,
    //     brightness: Brightness.dark,
    //     onError: Color(0xffcdcbc9))
    );

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
        onError: Color(0xffcdcbc9)));

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
