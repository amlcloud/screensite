import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';

final filterMine = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class FilterMyEntities extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(children: [
        Text('Mine Only'),
        Switch(
            value: ref.watch(filterMine) ?? false,
            onChanged: (value) {
              ref.read(filterMine.notifier).value = value;
            })
      ]);
}
