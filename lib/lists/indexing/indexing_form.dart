import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/generic_state_notifier.dart';
import '../list_indexing.dart';

abstract class IndexingForm extends ConsumerWidget {
  final String entityId;
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
      Map<String, bool>> editings;

  const IndexingForm(this.entityId, this.document, this.editings);

  void _setEditing(WidgetRef ref, bool editing) {
    Map<String, bool> map = ref.read(editings);
    map[document.id] = editing;
    Map<String, bool> newMap = {};
    map.forEach((key, value) => {newMap[key] = value});
    ref.read(editings.notifier).value = newMap;
  }

  void changeType(String? type) {
    CollectionReference collectionRef =
        document.reference.collection('entityIndexFields');
    collectionRef.get().then((x) {
      int length = x.docs.length;
      if (length == 0) {
        collectionRef.add({
          'value': '',
          'createdTimestamp': DateTime.now().millisecondsSinceEpoch
        });
        document.reference.update({'type': type});
      } else {
        x.docs.forEach((y) {
          y.reference.delete().then((_) {
            length = length - 1;
            if (length == 0) {
              collectionRef.add({
                'value': '',
                'createdTimestamp': DateTime.now().millisecondsSinceEpoch
              });
              document.reference.update({'type': type});
            }
          });
        });
      }
    });
  }

  Widget inputType() {
    return Row(children: [
      Container(
        width: 80,
        child: Text('Input Type'),
      ),
      Flexible(
          flex: 1,
          child: DropdownButton<String>(
              isExpanded: true,
              value: document.data()['type'],
              items: indexTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                changeType(value);
              }))
    ]);
  }

  void _delete() {
    document.reference.collection('entityIndexFields').get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
    document.reference.delete();
  }

  Widget read(WidgetRef ref);
  Widget edit(WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? editing = ref.watch(editings)[document.id];
    return editing != null && editing
        ? Column(children: [
            inputType(),
            edit(ref),
            Row(children: [
              Expanded(
                  child: TextButton(
                      onPressed: () => {_setEditing(ref, false)},
                      child: Text('Done'))),
              Expanded(
                  child: TextButton(onPressed: _delete, child: Text('Delete')))
            ])
          ])
        : Column(children: [
            read(ref),
            Row(children: [
              Expanded(
                  child: TextButton(
                      onPressed: () => {_setEditing(ref, true)},
                      child: Text('Edit'))),
            ])
          ]);
  }
}
