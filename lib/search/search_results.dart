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

  //Sort List of results
  //Parameter: unsorted list and fieldname to sort
  List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedMapbyFieldName(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList,
      String fieldName) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDataList = dataList
        .toList()
      ..sort((a, b) => a.data()[fieldName].compareTo(b.data()[fieldName]));
    return sortedDataList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
      children: ref.watch(colSP('search/$searchId/res')).when(
          loading: () => [],
          error: (e, s) => [ErrorWidget(e)],
          data: (results) =>
              sortedMapbyFieldName(results.docs, 'levScore').map((res) {
                return GestureDetector(
                    onTap: () {
                      ref.read(_selectedItemNotifier).value = res.data()['ref'];
                    },
                    child: ListTile(
                      title: Text("Name: " + res.data()['target']),
                      subtitle: Text(
                          "Levscore: " + res.data()['levScore'].toString()),
                    ));
              }).toList()));
}
