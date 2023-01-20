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
import 'package:screensite/lists/list_entitylistview.dart';

final selectedListItem =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class ListItemView extends ConsumerStatefulWidget {
  const ListItemView(this.entityId);
  final String entityId;

  @override
  ConsumerState<ListItemView> createState() => _ListItemState();
}

class _ListItemState extends ConsumerState<ListItemView> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(docSP('list/${widget.entityId}')).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  selected: ref.watch(selectedListItem) == widget.entityId
                      ? true
                      : false,
                  selectedTileColor: Theme.of(context).colorScheme.secondary,
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
                  onTap: () {
                    ref.read(selectedEntityList.notifier).value = null;
                    ref.read(selectedListItem.notifier).value = widget.entityId;
                    ref.read(activeList.notifier).value = widget.entityId;
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
          .doc(widget.entityId)
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
