import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:screensite/app_bar.dart';

final activePep = StateNotifierProvider<GenericStateNotifier<String?>, String?>(
    (ref) => GenericStateNotifier<String?>(null));

class AdverseMediaPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
            )));
  }
}
