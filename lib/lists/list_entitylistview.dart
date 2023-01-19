import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:screensite/state/generic_state_notifier.dart';

//creating new Widget of ConsumerStatefulWidget which takes two args
//creating new Widget of ConsumerStatefulWidget which takes two args
class EntityListView extends ConsumerStatefulStatefulWidget {
  const EntityListView(this.entityId, this.selectedItem);
  const EntityListView(this.entityId, this.selectedItem);
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
      selectedItem;

  @override
  ConsumerState<EntityListView> createState() => _EntityListViewState();
}

class _EntityListViewState extends ConsumerState<EntityListView> {
  //creating int to keep information about selected item and function to write index of selected item
  int? selected;
  void isSelected(dynamic key) {
    selected = key;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: ref.watch(docSP('list/${widget.entityId}')).when(
          children: ref.watch(docSP('list/${widget.entityId}')).when(
              loading: () => [],
              error: (e, s) => [],
              data: (entityDoc) => ref
                  .watch(colSP('list/${widget.entityId}/item'))
                  .when(
                      loading: () => [],
                      error: (e, s) => [ErrorWidget(e)],
                      data: (entities) => entities.docs
                          .asMap()
                          .entries
                          .map((entity) => ListTile(
                              selected: selected == entity.key ? true : false,
                              selectedTileColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Text((entityDoc.data()!['entitiesName1'] == null
                                      ? ''
                                      : entity.value.get(
                                          entityDoc.data()!['entitiesName1'])) +
                                  (entityDoc.data()!['entitiesName2'] == null
                                      ? ''
                                      : entity.value.get(
                                          entityDoc.data()!['entitiesName2'])) +
                                  (entityDoc.data()!['entitiesName3'] == null
                                      ? ''
                                      : entity.value.get(
                                          entityDoc.data()!['entitiesName3']))),
                              subtitle: Text((entity.value.data()[entityDoc.data()!['entitiesAddress']] != null)
                                  ? 'Location: ' +
                                      entity.value.data()[entityDoc.data()!['entitiesAddress']]
                                  : 'Location: undefined'),
                              isThreeLine: true,
                              onTap: () {
                                isSelected(entity.key);
                                ref.read(widget.selectedItem).value =
                                    Map.fromEntries(
                                        entity.value.data().entries.toList()
                                          ..sort((e1, e2) =>
                                              e1.key.compareTo(e2.key)));
                              }))
                          .toList())))
              data: (entityDoc) => ref
                  .watch(colSP('list/${widget.entityId}/item'))
                  .when(
                      loading: () => [],
                      error: (e, s) => [ErrorWidget(e)],
                      data: (entities) => entities.docs
                          .asMap()
                          .entries
                          .map((entity) => ListTile(
                              selected: selected == entity.key ? true : false,
                              selectedTileColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Text((entityDoc.data()!['entitiesName1'] == null
                                      ? ''
                                      : entity.value.get(
                                          entityDoc.data()!['entitiesName1'])) +
                                  (entityDoc.data()!['entitiesName2'] == null
                                      ? ''
                                      : entity.value.get(
                                          entityDoc.data()!['entitiesName2'])) +
                                  (entityDoc.data()!['entitiesName3'] == null
                                      ? ''
                                      : entity.value.get(
                                          entityDoc.data()!['entitiesName3']))),
                              subtitle: Text((entity.value.data()[entityDoc.data()!['entitiesAddress']] != null)
                                  ? 'Location: ' +
                                      entity.value.data()[entityDoc.data()!['entitiesAddress']]
                                  : 'Location: undefined'),
                              isThreeLine: true,
                              onTap: () {
                                isSelected(entity.key);
                                ref.read(widget.selectedItem).value =
                                    Map.fromEntries(
                                        entity.value.data().entries.toList()
                                          ..sort((e1, e2) =>
                                              e1.key.compareTo(e2.key)));
                              }))
                          .toList())))
    ]);
  }
}
