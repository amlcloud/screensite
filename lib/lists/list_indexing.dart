import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/firestore.dart';
import 'package:screensite/state/generic_state_notifier.dart';

import 'indexing/indexing_array_of_values_field_form.dart';
import 'indexing/indexing_multiple_fields_form.dart';
import 'indexing/indexing_single_field_form.dart';

const List<String> indexTypes = <String>[
  'Single field',
  'Multiple fields',
  'Array of values'
];

class ListIndexing extends ConsumerWidget {
  final String listId;
  final Map<String, Map<String, TextSelection>> textSelections = {};
  final editings = StateNotifierProvider<
      GenericStateNotifier<Map<String, bool>>,
      Map<String, bool>>((ref) => GenericStateNotifier<Map<String, bool>>({}));

  ListIndexing(this.listId);

  void add(WidgetRef ref) {
    FirebaseFirestore.instance
        .collection('list/$listId/index')
        .add({'type': indexTypes[0], 'entityIndexFields': []});
  }

  void changeType(
      QueryDocumentSnapshot<Map<String, dynamic>> map, String? type) {
    if (type == indexTypes[0]) {
      map.reference.update({'type': type, 'entityIndexFields': []});
    } else if (type == indexTypes[1]) {
      map.reference
          .update({'type': type, 'entityIndexFields': [], 'numberOfNames': 1});
    } else {
      map.reference.update({'type': type, 'entityIndexFields': []});
    }
  }

  Widget edit(QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return DropdownButton<String>(
        isExpanded: true,
        value: map.data()['type'],
        items: indexTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          changeType(map, value);
        });
  }

  Widget inputType(QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return Row(children: [
      Container(
        width: 80,
        child: Text('Input Type'),
      ),
      Flexible(flex: 1, child: edit(map))
    ]);
  }

  Widget content(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    String type = document.data()['type'];
    Widget widget;
    if (type == indexTypes[0]) {
      widget = IndexingSingleFieldForm(document, editings, textSelections);
    } else if (type == indexTypes[1]) {
      widget = IndexingMultipleFieldsForm(document, editings, textSelections);
    } else {
      widget =
          IndexingArrayOfValuesFieldForm(document, editings, textSelections);
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
