import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:screensite/search/search_list_item.dart';
import 'package:screensite/state/generic_state_notifier.dart';

final sortStateNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class SearchHistory extends ConsumerWidget {
  final AlwaysAliveProviderBase<GenericStateNotifier<DocumentReference?>>
      _selectedItemNotifier;

  const SearchHistory(this._selectedItemNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref
          .watch(colSPfiltered(
              'user/${FirebaseAuth.instance.currentUser!.uid}/search',
              orderBy: 'timeCreated',
              isOrderDesc: true))
          .when(
              loading: () => [Container()],
              error: (e, s) => [ErrorWidget(e)],
              data: (data) {
                // bool onlyMineSwitchStatus =
                //     ref.watch(isMineBatchNotifierProvider) ?? false;
                // var all_batches = data.docs;
                // var authors_only_batch = data.docs
                //     .where((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                //         doc.data()['author'] ==
                //         FirebaseAuth.instance.currentUser!.uid)
                //     .toList();
                // var author_filtered_batches = (onlyMineSwitchStatus == true
                //     ? authors_only_batch
                //     : all_batches);
                // var sorted_batches = author_filtered_batches
                //   ..sort((a, b) {
                //     var sortedBy = ref.watch(sortStateNotifierProvider) ?? 'id';
                //     // print(sortedBy);
                //     return a[sortedBy].compareTo(b[sortedBy]);
                //   });

                return (data.docs
                    .map((e) =>
                        SearchListItem(e.reference, _selectedItemNotifier))
                    .toList());
              }));
}
