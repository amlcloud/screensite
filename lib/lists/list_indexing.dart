import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'indexing_single_field.dart';
import '../providers/firestore.dart';
import 'package:screensite/state/generic_state_notifier.dart';

const List<String> indexTypes = <String>[
  'Single field',
  'Multiple fields',
  'Array of values'
];

final editings = StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
    Map<String, bool>>((ref) => GenericStateNotifier<Map<String, bool>>({}));

class ListIndexing extends ConsumerWidget {
  final String listId;
  final Map<String, TextSelection> textSelections = {};

  ListIndexing(this.listId);

  add(WidgetRef ref) {
    FirebaseFirestore.instance
        .collection('list/$listId/index')
        .add({'type': indexTypes[0], 'entityIndexFields': []});
  }

  Widget inputType(QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return Row(children: [
      Container(
        width: 80,
        child: Text('Input Type'),
      ),
      Flexible(
          flex: 1,
          child: DropdownButton<String>(
              isExpanded: true,
              value: map.data()['type'],
              items: indexTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                map.reference.update({'type': value, 'entityIndexFields': []});
              }))
    ]);
  }

  Widget content(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    String type = document.data()['type'];
    Widget widget;
    if (type == indexTypes[0]) {
      widget = IndexingSingleField(document, editings, textSelections);
    } else if (type == indexTypes[1]) {
      widget = Text('BBB');
    } else {
      widget = Text('CCC');
    }
    return widget;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        width: double.infinity,
        // color: Colors.red,
        child: Column(children: [
          Column(
              children: ref.watch(colSP('list/$listId/index')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) => entities.docs.map((entry) {
                        return Column(children: [
                          inputType(entry),
                          content(entry),
                          Divider()
                        ]);
                      }).toList())),
          TextButton(onPressed: () => {add(ref)}, child: Text('Add'))
        ]),
      );
}
