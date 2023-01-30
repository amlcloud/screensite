import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/theme.dart';
import 'package:jiffy/jiffy.dart'; //used for date time format

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
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(entityId.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (searchDoc) {
            return Container(
                decoration: RoundedCornerContainer.containerStyle,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text(searchDoc.id),
                    Text(
                        'Search Time:${Jiffy().format("h:mm a, do MMM, yyyy")}'), // datetime format using jiffy                 SearchResults(searchDoc.id, _selectedItemNotifier)
                  ],
                )));
          });
}
