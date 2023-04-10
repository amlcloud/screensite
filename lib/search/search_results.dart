import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';

class SearchResults extends ConsumerWidget {
  final DocumentSnapshot searchDoc;
  final AlwaysAliveProviderBase<GenericStateNotifier<DocumentReference?>>
      _selectedItemNotifier;

  SearchResults(this.searchDoc, this._selectedItemNotifier);

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
      children: ref
          .watch(colSP(
              'user/${FirebaseAuth.instance.currentUser!.uid}/search/${searchDoc.id}/res'))
          .when(
            loading: () => [],
            error: (e, s) => [ErrorWidget(e)],
            data: (results) {
              if (results.docs.isEmpty) {
                return [
                  Center(
                    child: Text(
                        "Nothing was found to match ${searchDoc['target']}"),
                  ),
                ];
              }
              return sortedMapbyFieldName(results.docs, 'levScore').map((res) {
                return GestureDetector(
                    onTap: () {
                      ref.read(_selectedItemNotifier).value = res.data()['ref'];
                    },
                    child: ListTile(
                      title: Text("Name: " + res.data()['target']),
                      subtitle: Text(
                          "Levscore: " + res.data()['levScore'].toString()),
                    ));
              }).toList();
            },
          ));
}
