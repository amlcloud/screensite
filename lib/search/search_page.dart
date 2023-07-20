import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/common.dart';
import 'package:screensite/search/search_details.dart';
import 'package:screensite/search/search_list.dart';
import 'package:screensite/search/search_results_item.dart';
import 'package:screensite/search/search_page_header.dart';
import 'package:screensite/search/search_history_ui.dart';
import 'package:screensite/search/profile_information_ui.dart';
import 'package:screensite/search/matches_ui.dart';
import 'package:screensite/drawer.dart';
import 'package:screensite/side_nav_bar.dart';

final selectedSearchResult =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final selectedRef = StateNotifierProvider<
        GenericStateNotifier<DocumentReference?>, DocumentReference?>(
    (ref) => GenericStateNotifier<DocumentReference?>(null));

const MINIMUM_SEARCH_LENGTH = 5;

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
      ref.read(selectedSearchResult.notifier).value = newSearchDocRef.id;
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
                          SearchPageHeader(),
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildSearchBar(setSearchValue),
                                buildSearchButton(context, setSearchValue)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MatchesUI(),
                                  ProfileInformationUI(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),

                  SearchHistoryUI(),
                ])));
  }

  Container buildSearchButton(BuildContext context, void setSearchValue()) {
    return Container(
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
                                    onPressed: () async {
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
                                    }),
                              );
  }

  Flexible buildSearchBar(void setSearchValue()) {
    return Flexible(
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
                              );
  }
}

// buildAddBatchButton(BuildContext context, WidgetRef ref) {
//   TextEditingController id_inp = TextEditingController();
//   TextEditingController name_inp = TextEditingController();
//   TextEditingController desc_inp = TextEditingController();
//   return ElevatedButton(
//     child: Text("Add Batch"),
//     onPressed: () {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               scrollable: true,
//               title: Text('Adding Batch...'),
//               content: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Form(
//                   child: Column(
//                     children: <Widget>[
//                       TextFormField(
//                         controller: id_inp,
//                         decoration: InputDecoration(labelText: 'ID'),
//                       ),
//                       TextFormField(
//                         controller: name_inp,
//                         decoration: InputDecoration(
//                           labelText: 'Name',
//                         ),
//                       ),
//                       TextFormField(
//                         controller: desc_inp,
//                         decoration: InputDecoration(
//                           labelText: 'Description',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                     child: Text("Submit"),
//                     onPressed: () {
//                       FirebaseFirestore.instance.collection('batch').add({
//                         'id': id_inp.text.toString(),
//                         'name': name_inp.text.toString(),
//                         'desc': desc_inp.text.toString(),
//                         'time Created': FieldValue.serverTimestamp(),
//                         'author': FirebaseAuth.instance.currentUser!.uid,
//                       }).then((value) => {
//                             if (value != null)
//                               {FirebaseFirestore.instance.collection('batch')}
//                           });

//                       Navigator.of(context).pop();
//                     })
//               ],
//             );
//           });
//     },
//   );
// }

