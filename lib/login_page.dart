import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:screensite/main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please Login',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  signInWithGoogle().whenComplete(() {
                    //ref.read(isLogedIn.notifier).value = true;
                  });
                },
                child: const Text(
                  "LogIn with Google",
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color(0xFF0255ec),
                      fontWeight: FontWeight.w500),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 25.0, 1.0, 1.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    ref.read(isLoading.notifier).value = true;
                    await FirebaseAuth.instance
                        .signInAnonymously()
                        .then((a) => {
                              ref.read(isLoggedIn.notifier).value = true,
                              ref.read(isLoading.notifier).value = false,
                            });
                  },
                  child: Text(
                    'log-in Anonymous',
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Color(0xFF0255ec),
                        fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

// void signOutGoogle() async{
//   await googleSignIn.signOut();
// }
