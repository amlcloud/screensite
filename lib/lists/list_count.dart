import 'list_exports.dart';

class ListCount extends ConsumerWidget {
  final String entityId;

  const ListCount(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ref.watch(colCount('list/${entityId}/item')).when(
            loading: () => Text(''),
            error: (e, s) => Text(''),
            data: ((data) => Text('${data.count} records')))
      ],
    );
  }
}
