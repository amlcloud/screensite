import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/controls/doc_field_text_edit.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/gestures.dart';
import '../extensions/string_validations.dart';
import '../search/search_details.dart';
import 'package:screensite/state/generic_state_notifier.dart';

final selectedList =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class ListItem extends ConsumerWidget {
  final String entityId;
  const ListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('list/' + entityId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  title: Text(
                    (entityDoc.data()!['uiName'] != null)
                        ? entityDoc.data()!['uiName']
                        : (entityDoc.data()!['name'] != null)
                            ? entityDoc.data()!['name']
                            : 'undefined list name',
                  ),
                  subtitle: Text('Last changed: ' +
                      Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                              ? DateTime(0001, 1, 1, 00, 00)
                              : entityDoc.data()!['lastUpdateTime'].toDate())
                          .format() +
                      '\n' +
                      'Last updated: ' +
                      Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                              ? DateTime(0001, 1, 1, 00, 00)
                              : entityDoc.data()!['lastUpdateTime'].toDate())
                          .format()),
                  isThreeLine: true,
                  tileColor: ref.watch(selectedList) == entityId
                      ? Colors.blue[200]
                      : null,
                  onTap: () {
                    ref.read(selectedList.notifier).value = entityId;
                    ref.read(activeList.notifier).value = entityId;
                  },
                ),
              ])));
  }

  Future<bool> CheckSelected() async {
    var batchRef = await FirebaseFirestore.instance.collection('batch').get();
    for (var element in batchRef.docs) {
      var selectList = await FirebaseFirestore.instance
          .collection('batch')
          .doc(element.id)
          .collection('SelectedEntity')
          .doc(entityId)
          .get();
      if (selectList.exists) {
        print("sample data temp1: ${selectList.exists}");
        //temp = false;
        return selectList.exists;
      }
    }
    return false;
  }
}
