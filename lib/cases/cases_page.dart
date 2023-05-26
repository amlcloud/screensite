import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/drawer.dart';
import 'package:widgets/doc_field_text.dart';
import 'package:widgets/doc_stream_widget.dart';

import 'case_chat_widget.dart';
import 'matches_widget.dart';

class CasesPage extends ConsumerWidget {
  static String get routeName => 'cases';
  static String get routeLocation => '/$routeName';
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < 600)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // CustomNavRail.getNavRail(),
                  Flexible(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child:
                                  // CaseTableWidget('2')
                                  //DocPrintWidget(kDB.doc('/case/123'))
                                  DocStreamWidget(
                                      docSP(kDB.doc('/case/123').path),
                                      (c, doc) {
                            return DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Value',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: (doc.data()?['content']
                                        as Map<String, dynamic>)
                                    .entries
                                    .map((e) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(e.key)),
                                            DataCell(Text(e.value.toString())),
                                          ],
                                        ))
                                    .toList());
                            // return Text(doc.id);
                          })),
                        ],
                      )),
                      Expanded(child: CaseChatWidget()),
                      Expanded(
                          child: DocFieldText(kDB.doc('/case/123'), 'error',
                              style: TextStyle(color: Colors.red)))
                    ],
                  )),
                  Expanded(
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Expanded(child: MatchesWidget(kDB.doc('/case/123')))
                      ])))
                ])));
  }
}
