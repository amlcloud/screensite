import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/controls/doc_field_text_edit.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:screensite/providers/firestore.dart';

class ListInfo extends ConsumerWidget {
  final String entityId;
  const ListInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('list/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Column(children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: Text(
                        (entityDoc.data()!['uiName'] != null)
                            ? entityDoc.data()!['uiName']
                            : (entityDoc.data()!['name'] != null)
                                ? entityDoc.data()!['name']
                                : 'undefined list name',
                      )),
                      Flexible(
                          child: Text('Last updated on ' +
                              Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                                      ? DateTime(0001, 1, 1)
                                      : entityDoc
                                          .data()!['lastUpdateTime']
                                          .toDate())
                                  .format('MMM d, y'))),
                      Flexible(
                          child: Text('Last changed on ' +
                              Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                                      ? DateTime(0001, 1, 1)
                                      : entityDoc
                                          .data()!['lastUpdateTime']
                                          .toDate())
                                  .format('MMM d, y'))),
                    ]),
              ]));
}
