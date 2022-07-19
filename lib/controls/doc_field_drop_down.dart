import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/state/generic_state_notifier.dart';

class DocFieldDropDown extends ConsumerWidget {
  final DocumentReference docRef;
  final String field;

  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?> valueNP;
  final List<String> items;

  const DocFieldDropDown(this.docRef, this.field, this.valueNP, this.items,
      {this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(docRef.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (doc) => DropdownButton<String>(
                value: doc.data()![field], //ref.watch(valueNP),
                onChanged: (String? newValue) {
                  docRef.update({field: newValue});

                  ref.read(valueNP.notifier).value = newValue;

                  if (onChanged != null) onChanged!(newValue);
                },
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ));
}
