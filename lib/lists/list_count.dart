import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';

class ListCount extends ConsumerWidget {
  final String entityId;

  const ListCount(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ref.watch(count('list/${entityId}/item')).when(
        //     loading: () => Text(''),
        //     error: (e, s) => Text(''),
        //     data: ((data) => Text('${data.count} records')))
      ],
    );
  }
}
