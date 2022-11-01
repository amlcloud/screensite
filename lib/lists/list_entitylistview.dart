import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntityListView extends ConsumerWidget {
  final String entityId;
  const EntityListView(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: ref.watch(docSP('list/${entityId}')).when(
              loading: () => [],
              error: (e, s) => [],
              data: (entityDoc) => ref.watch(colSP('list/$entityId/item')).when(
                  loading: () => [],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) => entities.docs
                      .map((entity) => ListTile(
                          title: Text((entityDoc.data()!['entitiesName1'] == null
                                  ? ''
                                  : entity.get(
                                      entityDoc.data()!['entitiesName1'])) +
                              (entityDoc.data()!['entitiesName2'] == null
                                  ? ''
                                  : entity.get(
                                      entityDoc.data()!['entitiesName2'])) +
                              (entityDoc.data()!['entitiesName3'] == null
                                  ? ''
                                  : entity.get(
                                      entityDoc.data()!['entitiesName3']))),
                          subtitle: Text((entity.data()[
                                      entityDoc.data()!['entitiesAddress']] !=
                                  null)
                              ? 'Location: ' +
                                  entity.data()[
                                      entityDoc.data()!['entitiesAddress']]
                              : 'Location: undefined'),
                          isThreeLine: true,
                          onTap: () {
                            //....
                          }))
                      .toList())))
    ]);
  }
}
