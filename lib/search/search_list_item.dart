import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/search/search_page.dart';
import 'package:jiffy/jiffy.dart';

class SearchListItem extends ConsumerWidget {
  final DocumentReference searchRef;
  final StateNotifierProvider<GenericStateNotifier<DocumentReference?>,
      DocumentReference?> _selectedItemNotifier;

  const SearchListItem(this.searchRef, this._selectedItemNotifier);

  bool isLessThan24HoursAgo(DateTime timeCreated) {
    Duration difference = DateTime.now().difference(timeCreated);

    if (difference.inHours < 24) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(searchRef.path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (searchDoc) => Card(
                child: Column(
              children: [
                ListTile(
                  title: Text(searchDoc.data()!['target'] ?? ''),
                  trailing: Text(
                      "${searchDoc.data()!['resultsCount'].toString()} Results"),
                  subtitle: isLessThan24HoursAgo(
                          searchDoc.data()!['timeCreated'].toDate())
                      ? Text(Jiffy(
                              Jiffy(searchDoc.data()!['timeCreated'].toDate())
                                  .format())
                          .fromNow())
                      : Text(Jiffy(searchDoc.data()!['timeCreated'].toDate())
                          .format("hh:mm a, do MMM, yyyy")),
                  onTap: () {
                    ref.read(selectedSearchId.notifier).value = searchRef.id;
                    ref.read(_selectedItemNotifier.notifier).value = null;
                  },
                )
              ],
            )));
  }
}
