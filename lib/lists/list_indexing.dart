import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';

import 'indexing/indexing_array_of_values_field_form.dart';
import 'indexing/indexing_multiple_fields_form.dart';
import 'indexing/indexing_single_field_form.dart';
import 'indexing/indexing_array_of_objects_field_form.dart';

const List<String> indexTypes = <String>[
  'Single field',
  'Multiple fields',
  'Array of values',
  'Array of objects'
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
        //.where('type', isNotEqualTo: 'array')
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
            // 'valid': true
          });
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text(
                      'No fields dictionary available. Please contact system administrator.'),
                  content: Text(
                      'No fields dictionary is available for the list $entityId. Please contact system administrator.'),
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
    } else if (type == indexTypes[2]) {
      widget = IndexingArrayOfValuesFieldForm(entityId, document);
    } else {
      widget = IndexingArrayOfObjectsFieldForm(entityId, document);
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
                    data: (entities) {
                      List<Widget> widgets = [];
                      if (entities.size == 0) {
                        widgets.add(Text('No index'));
                      } else {
                        for (int i = 0; i < entities.size; i++) {
                          Widget widget;
                          if (i == 0) {
                            widget = Column(children: [
                              Card(
                                  child: ListTile(
                                      hoverColor: Theme.of(context).hoverColor,
                                      textColor: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      selectedTileColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onTap: () => {},
                                      subtitle: content(entities.docs[i])))
                            ]);
                          } else {
                            widget = Column(children: [
                              Divider(),
                              Card(
                                  child: ListTile(
                                      hoverColor: Theme.of(context).hoverColor,
                                      textColor: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      selectedTileColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onTap: () => {},
                                      subtitle: content(entities.docs[i])))
                            ]);
                          }
                          widgets.add(widget);
                        }
                      }
                      return widgets;
                    })),
        ref
            .watch(docSP('admin/${FirebaseAuth.instance.currentUser!.uid}'))
            .when(
                loading: () => Container(),
                error: (e, s) => ErrorWidget(e),
                data: (doc) {
                  return doc.exists
                      ? Column(children: [
                          Divider(),
                          TextButton(
                              onPressed: () => {add(context)},
                              child: Text('Add'))
                        ])
                      : Container();
                })
      ]),
    );
  }
}
