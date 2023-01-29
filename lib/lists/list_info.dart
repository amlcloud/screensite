import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:http/http.dart' as http;

import '../state/generic_state_notifier.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ListInfo extends ConsumerWidget {
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<bool?>>
      _indexButtonClicked;
  const ListInfo(this.entityId, this._indexButtonClicked);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('list/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Column(children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: Text(
                        (entityDoc.data()!['uiName'] != null)
                            ? entityDoc.data()!['uiName']
                            : (entityDoc.data()!['name'] != null)
                                ? entityDoc.data()!['name']
                                : 'undefined list name',
                      )),
                      Flexible(
                          child: Text('Last updated: ' +
                              Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                                      ? DateTime(0001, 1, 1, 00, 00)
                                      : entityDoc
                                          .data()!['lastUpdateTime']
                                          .toDate())
                                  .format())),
                      Flexible(
                          child: Text('Last changed: ' +
                              Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                                      ? DateTime(0001, 1, 1, 00, 00)
                                      : entityDoc
                                          .data()!['lastUpdateTime']
                                          .toDate())
                                  .format())),
                      Flexible(
                        child: TextButton(
                            onPressed: () {
                              HttpsCallable callable = FirebaseFunctions
                                  .instance
                                  .httpsCallable('index_list2?list=$entityId');
                              callable();
                              ref.read(_indexButtonClicked).value = true;
                            },
                            child: Text('Reindex')),
                      ),
                    ]),
                Row(
                  children: [
                    Flexible(
                        child: TextButton(
                      child: Text("API"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final _formKey = GlobalKey<FormState>();
                              return AlertDialog(
                                scrollable: true,
                                title: Text('API Details'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                      key: _formKey,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("curl: "),
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                                "${dotenv.env['API_URL']}/GetSanctionListEntities"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        ElevatedButton(
                                                          child: Text("copy"),
                                                          onPressed: () => {},
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("url: "),
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                                "${dotenv.env['API_URL']}/GetSanctionListEntities"),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          child: Text("copy"),
                                                          onPressed: () => {},
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Done'),
                                  )
                                ],
                              );
                            });
                      },
                    ))
                  ],
                )
              ]));
}
