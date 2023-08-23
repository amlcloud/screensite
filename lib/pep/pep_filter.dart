import 'pep_exports.dart';

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
