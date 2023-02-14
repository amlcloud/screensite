import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/search/search_results.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/theme.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class SearchDetails extends ConsumerWidget {
  final DocumentReference entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<DocumentReference?>>
      _selectedItemNotifier;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  SearchDetails(this.entityId, this._selectedItemNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return ref
        .watch(docSP('user/${auth.currentUser!.uid}/${entityId.path}'))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (searchDoc) {
              return Container(
                  decoration: RoundedCornerContainer.containerStyle,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Text('Searched Target:${searchDoc.id}'),
                      Text(
                          'Search Time:${Jiffy(searchDoc.data()!['timeCreated'].toDate()).format("h:mm a, do MMM, yyyy")}'),
                      SearchResults(searchDoc.id, _selectedItemNotifier),
                    ],
                  )));
            });
  }
}
