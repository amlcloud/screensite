import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade100,
  hoverColor: Colors.white.withOpacity(0.2),
  //primaryColor: Color.fromARGB(255, 41, 27, 27),
  //backgroundColor: Colors.grey.shade100,
  colorScheme: const ColorScheme(
      primary: Color.fromARGB(255, 117, 117, 117),
      secondary: Color.fromARGB(255, 255, 153, 10),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      background: Color.fromARGB(255, 245, 245, 245),
      surface: Color.fromARGB(255, 225, 219, 219),
      onSurface: Color(0xff303035),
      onBackground: Color(0xff303035),
      error: Colors.red,
      brightness: Brightness.light,
      onError: Colors.white),
  textTheme: TextTheme(
      titleSmall: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255), //for text widget in appbar
      ),
      bodyMedium: TextStyle(
        color: Color.fromARGB(255, 255, 153, 10), //change link color to orange
      )),
);

final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    hoverColor: Colors.white.withOpacity(0.2),
    //primaryColor: Colors.white,
    //backgroundColor: Color(0xff181a1b),
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
    textTheme: TextTheme(
        titleSmall: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255), //for text widget in appbar
        ),
        bodyMedium: TextStyle(
          color:
              Color.fromARGB(255, 255, 153, 10), //change link color to orange
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

//static style for the rounded container
class RoundedCornerContainer {
  static BoxDecoration containerStyle = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      border: Border.all(color: Colors.grey));
}

//custom padding widget for indexing
class CustomPadding extends StatelessWidget {
  final Widget? child;

  const CustomPadding({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: child,
    );
  }
}
