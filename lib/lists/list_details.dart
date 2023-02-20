import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/list_info.dart';
import 'package:screensite/lists/list_entitylistview.dart';
import 'package:screensite/lists/list_indexing.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/theme.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/controls/doc_field_text_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'indexing/indexing_status.dart';
import 'indexing/indexing_progress.dart';
import 'list_count.dart';

class ListDetails extends ConsumerWidget {
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
      selectedItem;

  //TODO: move button logic to inner widget where it is used.
  final _indexButtonClicked =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));

  final _afterIndexButtonClicked =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  ListDetails(this.entityId, this.selectedItem);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(colSPfiltered('indexStatus/', queries: [
          QueryParam('listId', {Symbol('isEqualTo'): entityId})
        ]))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (indexStatus) {
              return Container(
                  decoration: RoundedCornerContainer.containerStyle,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "List id: " + entityId,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        ListInfo(entityId, _indexButtonClicked.notifier,
                            indexStatus),
                        Divider(),
                        Container(
                            child: ref.watch(docSP('list/' + entityId)).when(
                                loading: () => Container(),
                                error: (e, s) => ErrorWidget(e),
                                data: (entityDoc) => entityDoc.exists == false
                                    ? Center(
                                        child: Text('No entity data exists'))
                                    : buildListItemDetails(
                                        entityDoc, context, indexStatus, ref))),

                        Divider(),
                        ListIndexing(entityId),
                        Divider(),
                        //Timeline(entityId),
                        /*Expanded(
              flex: 10,
              child: EntityList(entityId),
            ),*/
                        //DataExportButton(entityId),
                        Expanded(
                            flex: 10,
                            child: SingleChildScrollView(
                              child: EntityListView(entityId, selectedItem),
                            )),
                        Divider(),
                        ListCount(entityId),
                      ]));
            });
  }

  Widget buildListItemDetails(
      DocumentSnapshot<Map<String, dynamic>> entityDoc,
      BuildContext context,
      QuerySnapshot<Map<String, dynamic>> indexStatus,
      WidgetRef ref) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [IndexingStatus(indexStatus), IndexingProgress(entityId)]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            padding: EdgeInsets.all(8.0),
            child: Text.rich(TextSpan(
                style: TextStyle(decoration: TextDecoration.underline),
                //make link underline
                text: "View source page",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    //on tap code here, you can navigate to other page or URL
                    final url =
                        Uri.parse(entityDoc.data()!['domainURL'] ?? '#');
                    var urllaunchable = await canLaunchUrl(
                        url); //canLaunch is from url_launcher package
                    if (urllaunchable) {
                      await launchUrl(
                          url); //launch is from url_launcher package to launch URL
                    } else {
                      print("URL can't be launched.");
                    }
                  })))
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Container(
            padding: EdgeInsets.all(8.0),
            child: Text.rich(TextSpan(
                style: TextStyle(decoration: TextDecoration.underline),
                //make link underline
                text: "View source list",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    //on tap code here, you can navigate to other page or URL
                    final url = Uri.parse(entityDoc.data()!['listURL'] ?? '#');
                    var urllaunchable = await canLaunchUrl(
                        url); //canLaunch is from url_launcher package
                    if (urllaunchable) {
                      await launchUrl(
                          url); //launch is from url_launcher package to launch URL
                    } else {
                      print("URL can't be launched.");
                    }
                  }))),
        InkWell(
            child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final _formKey = GlobalKey<FormState>();
                        return AlertDialog(
                          scrollable: true,
                          title: Text('Sanction list settings'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  DocFieldTextEdit(
                                      FirebaseFirestore.instance
                                          .doc('list/${entityId}'),
                                      'entitiesName1',
                                      decoration: InputDecoration(
                                          hintText: "Entity Name 1")),
                                  DocFieldTextEdit(
                                      FirebaseFirestore.instance
                                          .doc('list/${entityId}'),
                                      'entitiesName2',
                                      decoration: InputDecoration(
                                          hintText: "Entity Name 2")),
                                  DocFieldTextEdit(
                                      FirebaseFirestore.instance
                                          .doc('list/${entityId}'),
                                      'name',
                                      decoration: InputDecoration(
                                          hintText: "List Name")),
                                  DocFieldTextEdit(
                                      FirebaseFirestore.instance
                                          .doc('list/${entityId}'),
                                      'entitiesAddress',
                                      decoration: InputDecoration(
                                          hintText: "Entity address")),
                                  DocFieldTextEdit(
                                      FirebaseFirestore.instance
                                          .doc('list/${entityId}'),
                                      'dataSource',
                                      decoration: InputDecoration(
                                          hintText: "Data Source")),
                                  DocFieldTextEdit(
                                      FirebaseFirestore.instance
                                          .doc('list/${entityId}'),
                                      'website',
                                      decoration:
                                          InputDecoration(hintText: "Website")),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Done'),
                            )
                          ], //actions
                        );
                      } // Builder Widget
                      ); //show dialog
                })),
      ]),
    ]);
  }
}
