import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:screensite/state/generic_state_notifier.dart';

final selectedEntity = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

class EntityListView extends ConsumerWidget {
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
      selectedItem;

  const EntityListView(this.entityId, this.selectedItem);

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
                          tileColor: ref.watch(selectedEntity).toString() ==
                                  entity.data().toString()
                              ? Colors.blue[200]
                              : null,
                          onTap: () {
                            ref.read(selectedEntity.notifier).value = entity.data();
                            ref.read(selectedItem).value = Map.fromEntries(
                                entity.data().entries.toList()
                                  ..sort((e1, e2) => e1.key.compareTo(e2.key)));
                          }))
                      .toList())))
    ]);
  }
}
