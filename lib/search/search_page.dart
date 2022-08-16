import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/search/search_details.dart';
import 'package:screensite/search/search_list.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:http/http.dart' as http;

final activeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class SearchPage extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TextField(
                                      onChanged: (v) {},
                                      controller: searchCtrl)),
                              ElevatedButton(
                                  child: Text("Search"),
                                  onPressed: () async {
                                    if (searchCtrl.text.isEmpty) return;

                                    // var url = Uri.parse(
                                    //     'https://screen-od6zwjoy2a-an.a.run.app/?name=${searchCtrl.text.toLowerCase()}');
                                    // var response = await http.post(url, body: {
                                    //   // 'name': 'doodle',
                                    //   // 'color': 'blue'
                                    // });
                                    // print(
                                    //     'Response status: ${response.statusCode}');
                                    // print('Response body: ${response.body}');

// print(await http.read(Uri.parse('https://example.com/foobar.txt')));

                                    FirebaseFirestore.instance
                                        .collection('search')
                                        .add({
                                      'target': searchCtrl.text,
                                      'timeCreated':
                                          FieldValue.serverTimestamp(),
                                      'author': FirebaseAuth
                                          .instance.currentUser!.uid,
                                    });
                                  })
                            ],
                          ),
                          Expanded(child: SearchHistory()),
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: ref.watch(activeBatch) == null
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.all(8),
                              child: SearchDetails(
                                FirebaseFirestore.instance
                                    .doc('search/${ref.watch(activeBatch)}'),
                              )))
                ])));
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
}
