import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarAvatar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isUserHasAvatar = FirebaseAuth.instance.currentUser?.photoURL != null;
    return Tooltip(
      message: 'Edit Profile',
      child: Padding(
          padding: EdgeInsets.only(right: 4),
          child: Center(
              child: CircleAvatar(
                  radius: 14,
                  backgroundImage: isUserHasAvatar
                      ? Image.network(
                              FirebaseAuth.instance.currentUser!.photoURL!)
                          .image
                      : null,
                  child: isUserHasAvatar ? null : Icon(Icons.person)))),
    );
  }
}
