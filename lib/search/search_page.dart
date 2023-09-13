import 'search_exports.dart';

final selectedSearchId =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final selectedSearchResultId =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final _searchResultsSancDocRef =
    StateNotifierProvider<GenericStateNotifier<DR?>, DR?>(
        (ref) => GenericStateNotifier<DR?>(null));

const MINIMUM_SEARCH_LENGTH = 5;

final SNP<bool> isSearchButtonEnabledProvider = snp<bool>(false);

class SearchPage extends ConsumerWidget {
  static String get routeName => 'search';
  static String get routeLocation => '/$routeName';

  final TextEditingController searchCtrl = TextEditingController();

  final now = DateTime.now(); //

  final _formKey = GlobalKey<FormState>();

  // final _regexp = RegExp('.*');

  bool isValid() {
    return searchCtrl.text.length >= MINIMUM_SEARCH_LENGTH;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearchButtonEnabled = ref.watch(isSearchButtonEnabledProvider);

    void setSearchValue() async {
      if (!isValid()) return;
      if (searchCtrl.text.isEmpty ||
          searchCtrl.text.length < MINIMUM_SEARCH_LENGTH) return;
      var text = searchCtrl.text;
      final newSearchDocRef = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('search')
          .add({
        'target': text,
        'timeCreated': FieldValue.serverTimestamp(),
        'author': FirebaseAuth.instance.currentUser!.uid,
      });
      ref.read(selectedSearchId.notifier).value = newSearchDocRef.id;
      searchCtrl.clear();
    }

    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  //CustomNavRail.getNavRail(),
                  Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  "Sanction Search",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  "Enter known information on an individual or entity to find the closest match and review their information.",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      child: TextFormField(
                                        validator: (value) {
                                          String message =
                                              "Please input $MINIMUM_SEARCH_LENGTH or more characters";
                                          return isValid() &&
                                                  searchCtrl.text.length <
                                                      MINIMUM_SEARCH_LENGTH &&
                                                  searchCtrl.text.isNotEmpty
                                              ? message
                                              : isValid()
                                                  ? null
                                                  : message;
                                        },
                                        onChanged: (v) {
                                          _formKey.currentState?.validate();

                                          ref
                                              .read(
                                                  isSearchButtonEnabledProvider
                                                      .notifier)
                                              .state = v
                                                  .length >=
                                              MINIMUM_SEARCH_LENGTH;
                                        },
                                        controller: searchCtrl,
                                        onFieldSubmitted: (value) async =>
                                            setSearchValue(),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                          hintText: 'Enter Name Here',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text(
                                        "Search",
                                      ),
                                      onPressed: isSearchButtonEnabled == true
                                          ? () async {
                                              // if (searchCtrl.text.isEmpty) return;
                                              // var url = Uri.parse(
                                              //     'https://screen-od6zwjoy2a-an.a.run.app/?name=${searchCtrl.text.toLowerCase()}');
                                              // var response = await http.post(url, body: {
                                              //   // 'name': 'doodle',
                                              //   // 'color': 'blue'
                                              // });
                                              // print(
                                              //     'Response status: ${response.statusCode}');
                                              // print('Response body: ${response.body}');

                                              // FirebaseFirestore.instance
                                              //     .collection('search')
                                              //     .doc(searchCtrl.text)
                                              //     .set({
                                              //   'target': searchCtrl.text,
                                              //   'timeCreated':
                                              //       FieldValue.serverTimestamp(),
                                              //   'author': FirebaseAuth
                                              //       .instance.currentUser!.uid,
                                              // });

                                              setSearchValue();
                                            }
                                          : null),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Matches section
                                  Expanded(
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                "Matches",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              )),
                                          Expanded(
                                            child: ref.watch(
                                                        selectedSearchId) ==
                                                    null
                                                ? Container(
                                                    height: double.maxFinite)
                                                : SearchDetails(
                                                    FirebaseFirestore.instance.doc(
                                                        'search/${ref.watch(selectedSearchId)}'),
                                                    _searchResultsSancDocRef,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                      child: Card(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                        Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              "Profile Information",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            )),
                                        Flexible(
                                            flex: 3,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: ref.watch(
                                                                  _searchResultsSancDocRef) ==
                                                              null
                                                          ? Container()
                                                          : SearchResultsItem(
                                                              ref.watch(
                                                                  _searchResultsSancDocRef)!,
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .doc(
                                                                'user/${FirebaseAuth.instance.currentUser!.uid}/search/${ref.watch(selectedSearchId)}/res/${ref.watch(selectedSearchResultId)}',
                                                              )))
                                                ],
                                              ),
                                            ))
                                      ]))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Search History",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          SearchHistory(_searchResultsSancDocRef),
                        ],
                      ),
                    ),
                  ),
                ])));
  }
}
