import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Transaction extends ConsumerWidget {
  final DocumentSnapshot<Map<String, dynamic>> trnDoc;

  Transaction(this.trnDoc);

  @override
  Widget build(BuildContext context, WidgetRef ref) => !trnDoc.exists
      ? Container()
      : ListTile(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: trnDoc
                  .data()!
                  .entries
                  .map((e) => Text(e.value.toString()))
                  .toList()));
}
