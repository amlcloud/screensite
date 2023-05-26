import 'package:auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoginPage extends ConsumerWidget {
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build login page');
    return Scaffold(
        body: LoginScreen(
            SizedBox(
                height: 400,
                width: 300,
                child: Center(
                    child: Text("AML Cloud",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        )))),
            "Sanctions Screener",
            {
          "loginGitHub": true,
          "loginGoogle": true,
          "loginEmail": true,
          "loginSSO": true,
          "loginAnonymous": true,
          "signupOption": true,
        }));
  }
}
