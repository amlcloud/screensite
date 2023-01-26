import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/jsonview_switch.dart';

class SearchResultsItem extends ConsumerWidget {
  final DocumentReference _documentReference;

  const SearchResultsItem(this._documentReference);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: _documentReference.get().asStream(),
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.data == null) {
            widget = Container();
          } else {
            DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;
            widget = SwitchJSON(documentSnapshot.data());
          }
          return widget;
        });
  }
}
