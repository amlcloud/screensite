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
      tcLinks: {
        "termsOfServiceLink":
            "https://docs.github.com/en/site-policy/github-terms/github-terms-of-service",
        "privacyPolicyLink":
            "https://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement",
      },
      mainTitle: "AML Cloud",
    ));
  }
}
