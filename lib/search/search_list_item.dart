import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/search/search_page.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class SearchListItem extends ConsumerWidget {
  final DocumentReference searchRef;
  final AlwaysAliveProviderBase<GenericStateNotifier<DocumentReference?>>
      _selectedItemNotifier;
  const SearchListItem(this.searchRef, this._selectedItemNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.doc(searchRef.path).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        } else {
          final searchDoc = snapshot.data;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(searchDoc?.data()!['target'] ?? ''),
                  trailing: searchDoc == null
                      ? CircularProgressIndicator()
                      : Text(searchDoc.data()!['resultsCount']?.toString() ??
                          'loading'),

                  // ? CircularProgressIndicator()
                  // : Text(
                  //     searchDoc.data()!['resultsCount'].toString(),
                  //   ),
                  onTap: () {
                    ref.read(selectedSearchResult.notifier).value =
                        searchRef.id;
                    ref.read(_selectedItemNotifier).value = null;
                  },
                )
              ],
            ),
          );
        }
      },
    );
  }
}
