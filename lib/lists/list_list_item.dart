import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                  entityDoc.data()!['uiName'] ?? 'name',
                ),
                // trailing: Column(children: <Widget>[
                //   Text(entityDoc.data()!['id'] ?? 'id'),
                // ]),
                // subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                subtitle: Material(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Text('View source page'),
                          onTap: () async {
                            if (await canLaunchUrlString(
                                entityDoc.data()!['domainURL'])) {
                              await launchUrlString(
                                  entityDoc.data()!['domainURL']);
                            } else {
                              throw 'Could not launch domain URL';
                            }
                          },
                        ),
                        InkWell(
                          child: Text('View source list'),
                          onTap: () async {
                            if (await canLaunchUrlString(
                                entityDoc.data()!['listURL'])) {
                              await launchUrlString(
                                  entityDoc.data()!['listURL']);
                            } else {
                              throw 'Could not launch list URL';
                            }
                          },
                        ),
                      ]),
                ),
                onTap: () {
                  ref.read(activeList.notifier).value = entityId;
                },
              ));
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
