import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/firestore.dart';
import '../list_indexing.dart';

abstract class IndexingForm extends ConsumerWidget {
  final String entityId;
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  const IndexingForm(this.entityId, this.document);

  void _setEditing(WidgetRef ref, bool editing) {
    Map<String, bool> map = ref.read(editings);
    map[document.id] = editing;
    Map<String, bool> newMap = {};
    map.forEach((key, value) => {newMap[key] = value});
    ref.read(editings.notifier).value = newMap;
  }

  void _add(String? type, CollectionReference collectionRef) {
    Query query;
    CollectionReference ref =
        FirebaseFirestore.instance.collection('list/$entityId/fields/');
    if (type == 'Array of values') {
      query = ref.where('type', isEqualTo: 'array');
    } else {
      query = ref.where('type', isNotEqualTo: 'array');
    }
    query.get().then((data) {
      if (data.docs.isNotEmpty) {
        collectionRef.add({
          'value': data.docs[0].id,
          'createdTimestamp': DateTime.now().millisecondsSinceEpoch,
          'valid': true
        });
      }
    });
  }

  void changeType(String? type) {
    CollectionReference collectionRef =
        document.reference.collection('entityIndexFields');
    collectionRef.get().then((x) {
      int length = x.docs.length;
      if (length == 0) {
        _add(type, collectionRef);
        document.reference.update({'type': type});
      } else {
        x.docs.forEach((y) {
          y.reference.delete().then((_) {
            length = length - 1;
            if (length == 0) {
              _add(type, collectionRef);
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

  void validator(
      MapEntry<int, QueryDocumentSnapshot<Map<String, dynamic>>> doc,
      QuerySnapshot<Map<String, dynamic>> data,
      String text,
      bool needArray,
      void Function(bool) callback) {
    if (text.isEmpty) {
      doc.value.reference.update({'valid': false});
      callback(false);
    } else {
      bool duplicated = false;
      for (int i = 0; i < data.docs.length; i++) {
        if (doc.value.reference != data.docs[i].reference &&
            text == data.docs[i].data()['value']) {
          duplicated = true;
          break;
        }
      }
      if (duplicated) {
        doc.value.reference.update({'valid': false});
        callback(false);
      } else {
        FirebaseFirestore.instance
            .collection('list/${entityId}/item')
            .orderBy(text)
            .limit(1)
            .snapshots()
            .listen((event) {
          bool valid = event.docs.isNotEmpty;
          if (valid) {
            try {
              List _ = event.docs.first.data()[text];
              if (!needArray) {
                valid = false;
              }
            } catch (e) {
              if (needArray) {
                valid = false;
              }
            }
          }
          doc.value.reference.update({'valid': valid});
          callback(valid);
        });
      }
    }
  }

  Widget read(WidgetRef ref);
  Widget edit(WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? editing = ref.watch(editings)[document.id];

    print("user id: ${FirebaseAuth.instance.currentUser!.uid}");
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
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            read(ref),
            Row(children: [
              ref
                  .watch(
                      docSP('admin/${FirebaseAuth.instance.currentUser!.uid}'))
                  .when(
                      loading: () => Container(),
                      error: (e, s) => ErrorWidget(e),
                      data: (doc) {
                        return doc.exists
                            ?
                            // Expanded(
                            //     child: Align(
                            //         alignment: Alignment.centerRight,
                            //         child:
                            TextButton(
                                onPressed: () => {_setEditing(ref, true)},
                                child: Text('Edit'))
                            // ))
                            : Container();
                      })
            ])
          ]);
  }
}
