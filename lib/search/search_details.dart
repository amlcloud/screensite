import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/search/search_results.dart';
import 'package:screensite/state/generic_state_notifier.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class SearchDetails extends ConsumerWidget {
  final DocumentReference entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  SearchDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(entityId.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (searchDoc) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: SingleChildScrollView(
                  child: Column(
                children: [Text(searchDoc.id), SearchResults(searchDoc.id)],
              ))));
}
