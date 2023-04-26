import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/lists/list_entitylistview.dart';
import 'package:screensite/lists/lists_page.dart';

import '../common.dart';

final selectedListItem =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class ListItemTile extends ConsumerStatefulWidget {
  final String entityId;

  final StateNotifierProvider<GenericStateNotifier<String?>, String?>
      activeList;

  const ListItemTile(this.entityId, this.activeList);

  @override
  ConsumerState<ListItemTile> createState() => _ListItemState();
}

class _ListItemState extends ConsumerState<ListItemTile> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(docSP('list/${widget.entityId}')).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => (entityDoc.exists == false)
            ? Center(child: Text('No entity data exists'))
            : (entityDoc.data()?.containsKey('isVisible') == true &&
                    entityDoc.data()?['isVisible'] == false)
                ? Container()
                : Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                        ListTile(
                          selected:
                              ref.watch(selectedListItem) == widget.entityId
                                  ? true
                                  : false,
                          selectedTileColor:
                              Theme.of(context).colorScheme.secondary,
                          title: Text(
                            (entityDoc.data()!['uiName'] != null)
                                ? entityDoc.data()!['uiName']
                                : (entityDoc.data()!['name'] != null)
                                    ? entityDoc.data()!['name']
                                    : 'undefined list name',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                style: Theme.of(context).textTheme.bodySmall,
                                'Changed: ${Jiffy(entityDoc.data()!['lastUpdateTime'].toDate()).format("yy/MM/dd HH:mm")}',
                              ),
                              Text(
                                  style: Theme.of(context).textTheme.bodySmall,
                                  'Updated: ${Jiffy(entityDoc.data()!['lastUpdateTime'].toDate()).format("yy/MM/dd HH:mm")}'),
                              // style: Theme.of(context).textTheme.caption,
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            ref.read(selectedItem.notifier).value = null;
                            ref.read(selectedEntityList.notifier).value = null;
                            ref.read(selectedListItem.notifier).value =
                                widget.entityId;
                            ref.read(widget.activeList.notifier).value =
                                widget.entityId;
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
