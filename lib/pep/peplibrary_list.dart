import 'pep_exports.dart';
/*final activeSort =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));*/

class PepLibrarylists extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [
        ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: ref.watch(colSP('pepSource')).when(
                loading: () => [Container()],
                error: (e, s) => [ErrorWidget(e)],
                data: (entities) => (((ref.watch(filterPep) ?? false)
                        ? entities.docs
                            .where((d) =>
                                d['author'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                            .toList()
                        : entities.docs)
                    // ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
                    //     .compareTo(b[ref.watch(activeSort) ?? 'id']))
                    )
                    .map((entity) => PepListItem(entity.id))
                    .toList()))
      ]);
}
