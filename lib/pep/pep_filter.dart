import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';

final filterPep = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class FilterPep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(children: [
        Switch(
            value: ref.watch(filterPep) ?? false,
            onChanged: (value) {
              ref.read(filterPep.notifier).value = value;
            })
      ]);
}
