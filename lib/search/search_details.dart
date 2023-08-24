import 'search_exports.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class SearchDetails extends ConsumerWidget {
  final DocumentReference entityId;
  final StateNotifierProvider<GenericStateNotifier<DocumentReference?>,
      DocumentReference?> _selectedItemNotifier;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  SearchDetails(this.entityId, this._selectedItemNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return ref
        .watch(docSP('user/${auth.currentUser!.uid}/${entityId.path}'))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (searchDoc) {
              Timestamp? timeCreated = searchDoc.data()!['timeCreated'];
              return Container(
                  decoration: RoundedCornerContainer.containerStyle,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                    'Searched Target: ${searchDoc.data()!['target']}'),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, top: 15.5),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text("Copy"),
                                        onPressed: () async {
                                          await Clipboard.setData(ClipboardData(
                                              text: searchDoc
                                                  .data()!['target']
                                                  .toString()));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Copied: ${searchDoc.data()!['target']}')));
                                        })))
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Search Time: ${timeCreated != null ? Jiffy(timeCreated.toDate()).format("h:mm a, do MMM, yyyy") : ''}'),
                      Expanded(
                        // Add this to make the SingleChildScrollView take the remaining space
                        child: SingleChildScrollView(
                          child:
                              SearchResults(searchDoc, _selectedItemNotifier),
                        ),
                      ),
                    ],
                  ));
            });
  }
}
