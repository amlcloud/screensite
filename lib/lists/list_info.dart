import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/controls/doc_field_text_edit.dart';
import 'package:screensite/providers/firestore.dart';

class ListInfo extends ConsumerWidget {
  final String entityId;
  const ListInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('list/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Flexible(
                  //     child: DocFieldTextEdit(
                  //         FirebaseFirestore.instance.doc('list/${entityId}'), 'id',
                  //         decoration: InputDecoration(hintText: "ID"))),
                  Flexible(child: Text(entityDoc.data()!['name'])
                      // DocFieldTextEdit(
                      //     FirebaseFirestore.instance.doc('list/${entityId}'), 'id',
                      //     decoration: InputDecoration(hintText: "ID"))
                      ),
                  Flexible(
                      child: Text('Last updated: ' +
                          Jiffy(entityDoc.data()!['lastUpdateTime'].toDate())
                              .format())
                      //     DocFieldTextEdit(
                      //   FirebaseFirestore.instance.doc('list/${entityId}'),
                      //   'name',
                      //   decoration: InputDecoration(hintText: "Name"),
                      // )
                      ),
                  Flexible(
                      child: Text('Last changed: ' +
                          Jiffy(entityDoc.data()!['lastUpdateTime'].toDate())
                              .format())
                      //     DocFieldTextEdit(
                      //   FirebaseFirestore.instance.doc('list/${entityId}'),
                      //   'name',
                      //   decoration: InputDecoration(hintText: "Name"),
                      // )
                      ),
                  // Flexible(
                  //     child: DocFieldTextEdit(
                  //   FirebaseFirestore.instance.doc('list/${entityId}'),
                  //   'desc',
                  //   decoration: InputDecoration(hintText: "Description"),
                  // ))
                ],
              ));
}
