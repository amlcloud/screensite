import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/lists/lists_page.dart';

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
              data: (listDoc) => ref
                  .watch(colSPfiltered('list/${widget.entityId}/item',
                      limit: 500, orderBy: listDoc.data()?['entitiesName1']))
                  .when(
                      loading: () => [],
                      error: (e, s) => [ErrorWidget(e)],
                      data: (entities) => entities.docs
                          .asMap()
                          .entries
                          .map((entity) => builtEntityListTile(
                              entity.value, entity.key, context, listDoc))
                          .toList())))
    ]);
  }

  String? getEntityNameField(
      DocumentSnapshot<Map<String, dynamic>> listDoc, String fieldName) {
    return listDoc.data()![fieldName];
  }

  String getNameByEntityNameField(
      DocumentSnapshot<Map<String, dynamic>> listDoc,
      DocumentSnapshot<Map<String, dynamic>> entityDoc,
      String fieldNameName) {
    String? fieldName = getEntityNameField(listDoc, fieldNameName);
    if (fieldName != null) return entityDoc.data()?[fieldName] ?? '';
    return '';
  }

  Card builtEntityListTile(
      QueryDocumentSnapshot<Map<String, dynamic>> entityDoc,
      int index,
      BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> listDoc) {
    final entityName1 =
        getNameByEntityNameField(listDoc, entityDoc, 'entitiesName1');
    final entityName2 =
        getNameByEntityNameField(listDoc, entityDoc, 'entitiesName2');
    final entityName3 =
        getNameByEntityNameField(listDoc, entityDoc, 'entitiesName3');

    // final entityName2 = (listDoc.data()!['entitiesName2'] == null
    //     ? ''
    //     : entityDoc.get(listDoc.data()!['entitiesName2']));
    // final entityName3 = (listDoc.data()!['entitiesName3'] == null
    //     ? ''
    //     : entityDoc.get(listDoc.data()!['entitiesName3']));
    return Card(
      child: ListTile(
          selected: ref.read(selectedEntityList.notifier).value == index
              ? true
              : false,
          selectedTileColor: Theme.of(context).colorScheme.secondary,
          title: Text('$entityName1 $entityName2 $entityName3'),
          subtitle: Text(
              (entityDoc.data()[listDoc.data()!['entitiesAddress']] != null)
                  ? 'Location: ' +
                      entityDoc.data()[listDoc.data()!['entitiesAddress']]
                  : 'Location: undefined'),
          isThreeLine: true,
          onTap: () {
            ref.read(selectedEntityList.notifier).value = index;
            ref.read(widget.selectedItem).value = Map.fromEntries(
                entityDoc.data().entries.toList()
                  ..sort((e1, e2) => e1.key.compareTo(e2.key)));
          }),
    );
  }
}
