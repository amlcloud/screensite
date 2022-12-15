import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/state/generic_state_notifier.dart';

import 'indexing_textfield.dart';

class IndexingMultipleFieldsForm extends ConsumerWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
      Map<String, bool>> editings;
  final Map<String, Map<String, TextSelection>> textSelections;

  const IndexingMultipleFieldsForm(
      this.document, this.editings, this.textSelections);

  void editing(WidgetRef ref, bool editing) {
    Map<String, bool> map = ref.read(editings);
    map[document.id] = editing;
    Map<String, bool> newMap = {};
    map.forEach((key, value) => {newMap[key] = value});
    ref.read(editings.notifier).value = newMap;
  }

  void updateNumberOfNames(int numberOfNames) {
    List<dynamic> newList = [];
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    for (int i = 0; i < numberOfNames; i++) {
      if (i < entityIndexFields.length) {
        newList.add(entityIndexFields[i]);
      }
    }
    document.reference
        .update({'numberOfNames': numberOfNames, 'entityIndexFields': newList});
  }

  Widget preview(WidgetRef ref) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          width: 80,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Text('Index by'))),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Text(entityIndexFields.join(' ')))
    ]);
  }

  Widget read(WidgetRef ref) {
    List<Widget> children = [];
    int numberOfNames = document.data()['numberOfNames'];
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    for (int i = 0; i < numberOfNames; i++) {
      children.add(Row(children: [
        Container(
            width: 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text('Name ${i + 1}'))),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child:
                Text(i < entityIndexFields.length ? entityIndexFields[i] : ''))
      ]));
    }
    children.add(preview(ref));
    children.add(Row(children: [
      Expanded(
          child: TextButton(
              onPressed: () => {editing(ref, true)}, child: Text('Edit'))),
    ]));
    return Column(children: children);
  }

  Widget edit(WidgetRef ref) {
    List<Widget> children = [];
    int numberOfNames = document.data()['numberOfNames'];
    children.add(Row(children: [
      Container(
        width: 128,
        child: Text('Number of names'),
      ),
      Flexible(
          flex: 1,
          child: DropdownButton<String>(
              isExpanded: true,
              value: '$numberOfNames',
              items: [for (int i = 1; i <= 10; i++) '$i']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  updateNumberOfNames(int.parse(value));
                }
              }))
    ]));
    for (int i = 0; i < numberOfNames; i++) {
      children.add(Row(children: [
        Container(
            width: 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text('Name ${i + 1}'))),
        Flexible(flex: 1, child: IndexingTextField(document, i, textSelections))
      ]));
    }
    children.add(preview(ref));
    children.add(Row(children: [
      Expanded(
          child: TextButton(
              onPressed: () => {editing(ref, false)}, child: Text('Back'))),
      Expanded(
          child: TextButton(
              onPressed: () => {document.reference.delete()},
              child: Text('Delete')))
    ]));
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? editing = ref.watch(editings)[document.id];
    return editing != null && editing ? edit(ref) : read(ref);
  }
}
