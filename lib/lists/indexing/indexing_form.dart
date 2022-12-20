import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/generic_state_notifier.dart';

abstract class IndexingForm extends ConsumerWidget {
  final String entityId;
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
      Map<String, bool>> editings;
  final Map<String, Map<String, TextSelection>> textSelections;

  const IndexingForm(
      this.entityId, this.document, this.editings, this.textSelections);

  void editing(WidgetRef ref, bool editing) {
    Map<String, bool> map = ref.read(editings);
    map[document.id] = editing;
    Map<String, bool> newMap = {};
    map.forEach((key, value) => {newMap[key] = value});
    ref.read(editings.notifier).value = newMap;
  }

  Widget read(WidgetRef ref);
  Widget edit(WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? editing = ref.watch(editings)[document.id];
    return editing != null && editing ? edit(ref) : read(ref);
  }
}
