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

final editings = StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
    Map<String, bool>>((ref) => GenericStateNotifier<Map<String, bool>>({}));

class ListIndexing extends ConsumerWidget {
  final String entityId;

  const ListIndexing(this.entityId);

  void add(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('list/$entityId/fields/')
        .where('type', isNotEqualTo: 'array')
        .get()
        .then((data) {
      if (data.docs.isNotEmpty) {
        db.collection('list/$entityId/indexConfigs').add({
          'type': indexTypes[0],
          'createdTimestamp': DateTime.now().millisecondsSinceEpoch
        }).then((reference) {
          CollectionReference collectionRef =
              reference.collection('entityIndexFields');
          collectionRef.add({
            'value': data.docs[0].id,
            'createdTimestamp': DateTime.now().millisecondsSinceEpoch,
            'valid': true
          });
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('No fields available'),
                  content:
                      const Text('There is no fields collection in Firestore'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]);
            });
      }
    });
  }

  Widget content(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    String type = document.data()['type'];
    Widget widget;
    if (type == indexTypes[0]) {
      widget = IndexingSingleFieldForm(entityId, document);
    } else if (type == indexTypes[1]) {
      widget = IndexingMultipleFieldsForm(entityId, document);
    } else {
      widget = IndexingArrayOfValuesFieldForm(entityId, document);
    }
    return widget;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      // color: Colors.red,
      child: Column(children: [
        Column(
            children: ref
                .watch(colSPfiltered('list/$entityId/indexConfigs',
                    orderBy: 'createdTimestamp'))
                .when(
                    loading: () => [Container()],
                    error: (e, s) => [ErrorWidget(e)],
                    data: (entities) => entities.docs.map((entry) {
                          return Column(children: [content(entry), Divider()]);
                        }).toList())),
        TextButton(onPressed: () => {add(context)}, child: Text('Add'))
      ]),
    );
  }
}
