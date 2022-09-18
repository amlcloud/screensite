import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:login/login.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: LoginScreen(
      screenTitle: "Log in",
      loginOptions: {
        "loginGitHub": true,
        "loginGoogle": true,
        "loginEmail": true,
        "loginSSO": true,
        "loginAnonymous": true,
        "signupOption": true,
      },
      mainTitle: "AML Cloud",
    ));
  }
}
