import '_exports.dart';

final activeSort =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class Lists extends ConsumerWidget {
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>
      activeList;

  const Lists(this.activeList);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          // Row(
          //   children: [
          //     Text('sort by: '),
          //     DropdownButton<String>(
          //       value: ref.watch(activeSort) ?? 'id',
          //       icon: const Icon(Icons.arrow_downward),
          //       elevation: 16,
          //       // style: const TextStyle(color: Colors.deepPurple),
          //       underline: Container(
          //         height: 2,
          //         // color: Colors.deepPurpleAccent,
          //       ),
          //       onChanged: (String? newValue) {
          //         ref.read(activeSort.notifier).value = newValue;
          //       },
          //       items: <String>['name', 'id', 'time Created']
          //           .map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(value.toUpperCase()),
          //         );
          //       }).toList(),
          //     ),
          //     FilterMyEntities(),
          //   ],
          // ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: ref.watch(colSP('list')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) => (((ref.watch(filterMine) ?? false)
                          ? entities.docs
                              .where((d) =>
                                  d['author'] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                              .toList()
                          : entities.docs)
                        ..sort(((a, b) => (a.data()['name']?.toLowerCase() ??
                                '')
                            .compareTo(b.data()['name']?.toLowerCase() ?? '')))
                      // ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
                      //     .compareTo(b[ref.watch(activeSort) ?? 'id']))
                      )
                      .map((entity) => ListItemTile(entity.id, activeList))
                      .toList()))
        ],
      );
}
