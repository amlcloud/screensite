import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/search/search_page.dart';

class SearchListItem extends ConsumerWidget {
  final DocumentReference searchRef;
  const SearchListItem(this.searchRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(searchRef.path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (searchDoc) => Card(
                child: Column(
              children: [
                ListTile(
                  title: Text(searchDoc.id
                      //(searchDoc.data()!['target'] ?? ''),
                      ),
                  trailing: Text(searchDoc.data()!['resultsCount'].toString()),
                  // subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                  // trailing: Column(children: <Widget>[
                  //   Text(searchDoc.data()!['target'] ?? ''),
                  //   // buildDeleteEntityButton(
                  //   //     context,
                  //   //     FirebaseFirestore.instance
                  //   //         .collection('batch')
                  //   //         .doc(batchId),
                  //   //     Icon(Icons.delete))
                  // ]),
                  onTap: () {
                    ref.read(activeBatch.notifier).value = searchRef.id;
                  },
                )
              ],
            )));
  }
}
