import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:screensite/firebase_options.dart';

import 'package:screensite/main.dart' as app;

import 'login.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('failing test example', (tester) async {
    expect(2 + 2, equals(5));
  });

  // group('My group description', () {
  //   setUp(() async {
  //     // This will run before each test in this group.
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //   });

  //   testWidgets('tap on the floating action button, verify counter',
  //       (tester) async {
  //     //test('My first test', (tester) async {
  //     // The first test.
  //     await tester.pumpAndSettle();
  //     expect(2 + 2, equals(6));
  //   });

  //   test('My second test', () {
  //     // The second test.
  //   });

  //   tearDown(() {
  //     // This will run after each test in this group.
  //   });
  // });

  // // await Firebase.initializeApp(
  // //   options: DefaultFirebaseOptions.currentPlatform,
  // // );
  // // FirebaseFirestore.instance.settings = const Settings(
  // //     host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);

  // // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // // FirebaseAuth.instanceFor(app: app).useEmulator('http://localhost:9099');

  // // testWidgets('failing test example', (tester) async {
  // //   expect(2 + 2, equals(5));
  // // });
  // // group('end-to-end test', () {
  // //   print('passed!');
  // //   // testWidgets('Log In', loginTest, semanticsEnabled: false);
  // //   // testWidgets('tap on the floating action button, verify counter',
  // //   //     (tester) async {
  // //   //   app.main();
  // //   //   await tester.pumpAndSettle();
  // //   //   print('***************');
  // //   //   final appUrl = Uri.base.toString();
  // //   //   print('Application URL: $appUrl');
  // //   // });
  // // });
}
