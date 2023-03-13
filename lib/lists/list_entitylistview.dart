import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:screensite/state/generic_state_notifier.dart';

final selectedEntityList =
    StateNotifierProvider<GenericStateNotifier<int?>, int?>(
        (ref) => GenericStateNotifier<int?>(null));

//creating new Widget of ConsumerStatefulWidget which takes two args
class EntityListView extends ConsumerStatefulWidget {
  const EntityListView(this.entityId, this.selectedItem);
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
      selectedItem;

  @override
  ConsumerState<EntityListView> createState() => _EntityListViewState();
}

class _EntityListViewState extends ConsumerState<EntityListView> {
  //creating int to keep information about selected item and function to write index of selected item
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: ref.watch(docSP('list/${widget.entityId}')).when(
            loading: () => [],
            error: (e, s) => [],
            data: (entityDoc) => ref
                .watch(
                    colSPfiltered('list/${widget.entityId}/item', limit: 500))
                .when(
                    loading: () => [],
                    error: (e, s) => [ErrorWidget(e)],
                    data: (entities) {
                      entities.docs.sort((a, b) =>
                          (a.data()['entitiesName1'] ?? '')
                              .compareTo(b.data()['entitiesName1'] ?? ''));
                      return entities.docs
                          .asMap()
                          .entries
                          .map((entity) =>
                              builtEntityListTile(entity, context, entityDoc))
                          .toList();
                    })),
      )
    ]);
  }

  Card builtEntityListTile(
      MapEntry<int, QueryDocumentSnapshot<Map<String, dynamic>>> entity,
      BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> entityDoc) {
    final entityName1 = (entityDoc.data()!['entitiesName1'] == null
        ? ''
        : entity.value.get(entityDoc.data()!['entitiesName1']));

    final entityName2 = (entityDoc.data()!['entitiesName2'] == null
        ? ''
        : entity.value.get(entityDoc.data()!['entitiesName2']));
    final entityName3 = (entityDoc.data()!['entitiesName3'] == null
        ? ''
        : entity.value.get(entityDoc.data()!['entitiesName3']));
    return Card(
      child: ListTile(
          selected: ref.read(selectedEntityList.notifier).value == entity.key
              ? true
              : false,
          selectedTileColor: Theme.of(context).colorScheme.secondary,
          title: Text('$entityName1 $entityName2 $entityName3'),
          subtitle: Text(
              (entity.value.data()[entityDoc.data()!['entitiesAddress']] !=
                      null)
                  ? 'Location: ' +
                      entity.value.data()[entityDoc.data()!['entitiesAddress']]
                  : 'Location: undefined'),
          isThreeLine: true,
          onTap: () {
            ref.read(selectedEntityList.notifier).value = entity.key;
            ref.read(widget.selectedItem).value = Map.fromEntries(
                entity.value.data().entries.toList()
                  ..sort((e1, e2) => e1.key.compareTo(e2.key)));
          }),
    );
  }
}
