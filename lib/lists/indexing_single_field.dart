import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'dart:async';

//ignore: must_be_immutable
class IndexingSingleField extends ConsumerWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
      Map<String, bool>> editings;
  final Map<String, TextSelection> textSelections;
  final TextEditingController textEditingController = TextEditingController();
  Timer? timer;

  IndexingSingleField(this.document, this.editings, this.textSelections);

  void onChanged(String value) {
    textSelections[document.id] = textEditingController.selection;
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(const Duration(milliseconds: 500), () {
      document.reference.update({
        'entityIndexFields': [value]
      });
    });
  }

  void editing(WidgetRef ref, bool editing) {
    Map<String, bool> map = ref.read(editings);
    map[document.id] = editing;
    Map<String, bool> newMap = {};
    map.forEach((key, value) => {newMap[key] = value});
    ref.read(editings.notifier).value = newMap;
  }

  Widget read(WidgetRef ref) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    return Column(children: [
      Row(children: [
        Container(
            width: 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text('Full Name'))),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(entityIndexFields.isEmpty ? '' : entityIndexFields[0]))
      ]),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            width: 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text('Index by'))),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(entityIndexFields.isEmpty ? '' : entityIndexFields[0]))
      ]),
      Row(children: [
        Expanded(
            child: TextButton(
                onPressed: () => {editing(ref, true)}, child: Text('Edit'))),
      ])
    ]);
  }

  Widget edit(WidgetRef ref) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    if (entityIndexFields.isNotEmpty) {
      textEditingController.text = entityIndexFields[0];
      if (textSelections[document.id] != null) {
        textEditingController.selection = textSelections[document.id]!;
      }
    }
    return Column(children: [
      Row(children: [
        Container(
            width: 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text('Full Name'))),
        Flexible(
            flex: 1,
            child: TextField(
              controller: textEditingController,
              onChanged: (value) => {onChanged(value)},
            ))
      ]),
      Row(children: [
        Container(
            width: 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text('Index by'))),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(entityIndexFields.isEmpty ? '' : entityIndexFields[0]))
      ]),
      Row(children: [
        Expanded(
            child: TextButton(
                onPressed: () => {editing(ref, false)}, child: Text('Back'))),
        Expanded(
            child: TextButton(
                onPressed: () => {document.reference.delete()},
                child: Text('Delete')))
      ])
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? editing = ref.watch(editings)[document.id];
    return editing != null && editing ? edit(ref) : read(ref);
  }
}
