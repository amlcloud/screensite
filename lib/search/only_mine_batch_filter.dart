import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/state/generic_state_notifier.dart';

final isMineBatchNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<bool>, bool>(
        (ref) => GenericStateNotifier<bool>(false));

class OnlyMineBatchFilter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(children: [
        Text('Mine Only'),
        Switch(
            value: ref.watch(isMineBatchNotifierProvider) ?? false,
            onChanged: (value) {
              ref.read(isMineBatchNotifierProvider.notifier).value = value;
            })
      ]);
}
