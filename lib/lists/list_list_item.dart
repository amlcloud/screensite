import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              : ListTile(
                  tileColor: Color.fromARGB(255, 44, 44, 44),
                  focusColor: Color.fromARGB(255, 133, 116, 116),
                  title: Text(
                    entityDoc.data()!['name'] ?? 'name',
                  ),
                  trailing: Column(children: <Widget>[
                    Text(entityDoc.data()!['id'] ?? 'id'),
                  ]),
                  subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                  onTap: () {
                    ref.read(activeList.notifier).value = entityId;
                  },
                ),
        );
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
