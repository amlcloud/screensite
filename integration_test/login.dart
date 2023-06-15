import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screensite/main.dart';

Future<void> loginTest(WidgetTester tester) async {
  print('starting login test');
  log('starting login test');
  //app.main();
  await tester.pumpWidget(ProviderScope(child: MainApp()));

  print('Firebase APP is: ${Firebase.app().name}');

  print('pumpAndSettle...');

  await tester.pumpAndSettle();

  print('check welcome back');
  expect(find.text('Welcome back'), findsOneWidget);

  print('enter email');
  await tester.enterText(
      find.byKey(Key('email_field')), 'auto_admin@amlcloud.io');
  print('enter password');
  await tester.enterText(find.byKey(Key('password_field')), 'qwer1234');
  await tester.tap(find.byKey(Key('login_btn')));

  await tester.pumpAndSettle(const Duration(seconds: 1));

  log("User profile expect!");
  expect(find.byKey(Key('edit_user_profile')), findsOneWidget);

  print('end of login test');
}
