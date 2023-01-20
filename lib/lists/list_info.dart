import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:http/http.dart' as http;

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
                          child: Text('Last updated: ' +
                              Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                                      ? DateTime(0001, 1, 1, 00, 00)
                                      : entityDoc
                                          .data()!['lastUpdateTime']
                                          .toDate())
                                  .format())),
                      Flexible(
                          child: Text('Last changed: ' +
                              Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                                      ? DateTime(0001, 1, 1, 00, 00)
                                      : entityDoc
                                          .data()!['lastUpdateTime']
                                          .toDate())
                                  .format())),
                      Flexible(
                        child: TextButton(
                            onPressed: () {
                              String path =
                                  'https://us-central1-screener-9631e.cloudfunctions.net/index_list2?list=$entityId';
                              http.get(Uri.parse(path));
                            },
                            child: Text('Reindex')),
                      )
                    ]),
              ]));
}
