import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controls/custom_json_viewer.dart';
import '../controls/json_viewer.dart';

// Statefull widget for JSON Viewer, shows data in JSON format or User friendly format depending on users choice

// Boolean value which will represent value of toggle
final SwitchJsonStateProvider = StateProvider<bool>((ref) {
  return false;
});

class SwitchJSON extends ConsumerWidget {
  final Map<String, dynamic>? selectedItem;

  const SwitchJSON(this.selectedItem);
// JSON viewer
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSwitched = ref.watch(SwitchJsonStateProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JSON data',
              style: TextStyle(color: Colors.black),
            ),
            Switch(
              onChanged: ((value) => ref
                  .read(SwitchJsonStateProvider.notifier)
                  .update((state) => !state)),
              value: isSwitched,
            )
          ],
        ),
        Container(
            child: (isSwitched == false)
                ? CustomJsonViewer(selectedItem)
                // Widget with prittier data should go here, so its a placeholder for now
                : JsonViewer(selectedItem)),
      ],
    );
  }
}
