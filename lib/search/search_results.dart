import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';

import '../state/generic_state_notifier.dart';

class SearchResults extends ConsumerWidget {
  final String searchId;
  final AlwaysAliveProviderBase<GenericStateNotifier<DocumentReference?>>
      _selectedItemNotifier;

  SearchResults(this.searchId, this._selectedItemNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
      children: ref.watch(colSP('search/$searchId/res')).when(
          loading: () => [],
          error: (e, s) => [ErrorWidget(e)],
<<<<<<< HEAD
          data: (results) => results.docs
              .map((res) => ListTile(
                    title: Text("Name: " + res.data()['target']),
                    subtitle:
                        Text("Levscore: " + res.data()['levScore'].toString()),
                  ))
              .toList()));
=======
          data: (results) => results.docs.map((res) {
                return GestureDetector(
                    onTap: () {
                      ref.read(_selectedItemNotifier).value = res.data()['ref'];
                    },
                    child: ListTile(title: Text(res.data()['target'])));
              }).toList()));
>>>>>>> 250f58bbabfa447b301bda26e5a7edd2059659f5
}
