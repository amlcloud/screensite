import 'package:auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends ConsumerWidget {
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build login page');
    return Scaffold(
        body: LoginScreen(
            SplashScreen(),
            // SizedBox(
            //     height: 400,
            //     width: 300,
            //     child: Center(
            //         child: Text("AML Cloud",
            //             style: TextStyle(
            //               fontSize: 40,
            //               fontWeight: FontWeight.bold,
            //             )))),
            "Login",
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

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: Color.fromARGB(255, 55, 55, 55),
        child: Center(
            child: Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Sanctions Screener",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                    SizedBox(
                        width: 150,
                        height: 150,
                        child: SvgPicture.asset(
                          'assets/Logo_Dark.svg',
                        ))
                  ],
                ))));
  }
}
