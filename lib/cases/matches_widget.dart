import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:screensite/controls/json_viewer.dart';
import 'package:widgets/col_stream_widget.dart';
import 'package:widgets/doc_print.dart';
import 'package:widgets/doc_stream_widget.dart';
import 'package:widgets/doc_field_text.dart';

import '../controls/custom_json_viewer.dart';
import 'case_page.dart';
import 'cases_page.dart';

class MatchesWidget extends ConsumerWidget {
  final DR caseDocRef;

  MatchesWidget(this.caseDocRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: DocStreamWidget(
            docSP(caseDocRef.path),
            (context, caseDoc) => caseDoc.data()?['target'] == null
                ? Text('No matches')
                : DocStreamWidget(
                    docSP(caseDocRef
                        .collection('search')
                        .doc(caseDoc.data()?['target'])
                        .path),
                    (context, doc) => Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                'Matches found for: "${doc.data()!['target']}"'),
                            // SizedBox(
                            //     height: 1800,
                            Container(
                                child: ColStreamWidget<Widget>(
                                    colSP(doc.reference.collection('res').path),
                                    (context, snapshot, items) =>
                                        Column(children: items),
                                    (context, searchResDoc) =>
                                        SingleChildScrollView(
                                            child: // Container(

                                                GestureDetector(
                                                    onTap: () {
                                                      print(searchResDoc
                                                          .reference);
                                                      ref
                                                              .read(
                                                                  activeSearchResDocRef
                                                                      .notifier)
                                                              .value =
                                                          searchResDoc
                                                              .reference;
                                                    },
                                                    child:
                                                        // SizedBox(
                                                        //     height: 200,
                                                        //     child:
                                                        Card(
                                                            child: ListTile(
                                                                title: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            searchResDoc
                                                                .get('target'),
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "List ID: ${searchResDoc.data()!['ref'].parent.parent.id}")
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("List Name: "),
                                                            DocFieldText(
                                                                searchResDoc
                                                                    .data()![
                                                                        'ref']
                                                                    .parent
                                                                    .parent,
                                                                'name'),
                                                          ],
                                                        ),
                                                        DocStreamWidget(
                                                            docSP((searchResDoc
                                                                            .data()![
                                                                        'ref']
                                                                    as DR)
                                                                .path),
                                                            (context, sanctionDoc) => Flexible(
                                                                child: CustomJsonViewer(
                                                                    sanctionDoc
                                                                        .data())
                                                                // DocPrintWidget(
                                                                //     sanctionDoc
                                                                //         .reference)
                                                                ))
                                                      ],
                                                    )))))))
                          ],
                        )))
        // ColStreamWidget<Widget>(
        //     colSP(docRef.collection('search').path),
        //     (context, snapshot, items) => Column(children: items),
        //     (context, doc) => Column(
        //           children: [
        //             Text(doc.data()!['target']),
        //             ColStreamWidget<Widget>(
        //                 colSP(doc.reference.collection('res').path),
        //                 (context, snapshot, items) =>
        //                     Column(children: items),
        //                 (context, doc) => DocStreamWidget(
        //                     docSP((doc.data()!['ref'] as DocumentReference)
        //                         .path),
        //                     (context, sanctionDoc) =>
        //                         DocPrintWidget(sanctionDoc.reference)))
        //           ],
        //         ))
        );
  }
}
