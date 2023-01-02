import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/theme.dart';

import '../../state/generic_state_notifier.dart';
import 'indexing_form.dart';
import 'indexing_textfield.dart';

class IndexingArrayOfValuesFieldForm extends IndexingForm {
  const IndexingArrayOfValuesFieldForm(
      String entityId,
      QueryDocumentSnapshot<Map<String, dynamic>> document,
      StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
              Map<String, bool>>
          editings,
      Map<String, Map<String, TextSelection>> textSelections)
      : super(entityId, document, editings, textSelections);

  @override
  Widget read(WidgetRef ref) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(width: 80, child: CustomPadding(child: Text('Index by'))),
        CustomPadding(
            child: Text(
                entityIndexFields.isEmpty ? '' : '[${entityIndexFields[0]}]'))
      ])
    ]);
  }

  @override
  Widget edit(WidgetRef ref) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    return Column(children: [
      Row(children: [
        Container(width: 80, child: CustomPadding(child: Text('Array Field'))),
        Flexible(
            flex: 1,
            child: IndexingTextField(entityId, document, 0, textSelections))
      ]),
      Row(children: [
        Container(width: 80, child: CustomPadding(child: Text('Index by'))),
        CustomPadding(
            child: Text(
                entityIndexFields.isEmpty ? '' : '[${entityIndexFields[0]}]'))
      ])
    ]);
  }
}
