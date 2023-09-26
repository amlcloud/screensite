import 'list_exports.dart';

class ListIndexingWidget extends ConsumerWidget {
  ListIndexingWidget({
    Key? key,
    required this.listId,
  }) : super(key: key);

  final indexButtonClicked =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));
  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => colWatch(
          colSPfiltered('indexStatus/', queries: [
            QueryParam('listId', {Symbol('isEqualTo'): listId})
          ]),
          ref, (indexStatus) {
        final isIndexing = indexStatus.docs.isNotEmpty &&
            indexStatus.docs.first['indexing'] == true;
        final isButtonDisabled =
            ref.watch(indexButtonClicked.notifier).value || isIndexing;
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [IndexingStatus(indexStatus), IndexingProgress(listId)],
            ),
            ref
                .watch(docSP('admin/${FirebaseAuth.instance.currentUser!.uid}'))
                .when(
                    loading: () => Container(),
                    error: (e, s) => ErrorWidget(e),
                    data: (doc) {
                      return doc.exists
                          ? Flexible(
                              child: ElevatedButton(
                                onPressed: isButtonDisabled
                                    ? null
                                    : () {
                                        if (ref
                                                    .read(indexButtonClicked
                                                        .notifier)
                                                    .value ==
                                                false &&
                                            (indexStatus.docs.isEmpty ||
                                                indexStatus.docs
                                                        .first['indexing'] ==
                                                    false)) {
                                          ref
                                              .read(indexButtonClicked.notifier)
                                              .value = true;
                                          HttpsCallable callable =
                                              FirebaseFunctions
                                                  .instance
                                                  .httpsCallable(
                                                      'index_list2?list=$listId');
                                          callable().then((_) {
                                            ref
                                                .read(
                                                    indexButtonClicked.notifier)
                                                .value = false;
                                          });
                                        }
                                      },
                                child: Text('Reindex'),
                              ),
                            )
                          : Container();
                    }),
          ],
        );
      });
}
