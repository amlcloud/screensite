import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:login/login.dart';
import 'package:screensite/search/search_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Clear search history from state on display of login page
    ref.read(selectedSearchResult.notifier).value = null;

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
