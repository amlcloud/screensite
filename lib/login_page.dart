import 'package:auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:screensite/search/search_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: LoginScreen("AML Cloud", "Sanctions Screener", {
      "loginGitHub": true,
      "loginGoogle": true,
      "loginEmail": true,
      "loginSSO": true,
      "loginAnonymous": true,
      "signupOption": true,
    }));
  }
}
