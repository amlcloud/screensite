import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/main.dart';

class ThemeStateNotifier extends StateNotifier<bool> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;
  ThemeStateNotifier(bool loginState) : super(false) {
    if (loginState == true && auth.currentUser != null) {
      dbInstance
          .collection('user')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        String theme = value['themeMode'];
        bool isDark = theme == 'light' ? false : true;
        state = isDark;
      });
    }
  }
  void changeTheme() {
    state = !state;
    String themeMode = state == false ? 'light' : 'dark';
    if (auth.currentUser != null) {
      dbInstance
          .collection('user')
          .doc(auth.currentUser!.uid)
          .set({'themeMode': themeMode});
    }
  }
}

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotifier, bool>((ref) {
  bool loginState = ref.watch(isLoggedIn);
  return ThemeStateNotifier(loginState);
}, dependencies: [isLoggedIn]);
