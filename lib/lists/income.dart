import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:widgets/doc_field_drop_down.dart';
import 'package:widgets/doc_field_text_edit.dart';

class Income extends ConsumerWidget {
  final String entityId;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>
      incomeTypeNP =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));
  Income(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: DocFieldDropDown(
          FirebaseFirestore.instance.doc('entity/${entityId}'),
          'incomeType',
          incomeTypeNP,
          ['salary', 'centrelink'],
        )),
        Expanded(
            child: DocFieldTextEdit(
                FirebaseFirestore.instance.doc('entity/${entityId}'),
                'incomeAmount',
                decoration: InputDecoration(hintText: "Income Amount")))
      ]);
}
