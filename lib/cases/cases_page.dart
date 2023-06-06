import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/drawer.dart';
import 'package:widgets/doc_field_text.dart';
import 'package:widgets/doc_stream_widget.dart';

import 'case_chat_widget.dart';
import 'investigation_widget.dart';
import 'matches_widget.dart';

final SNP<DR?> activeSearchResDocRef = snp(null);

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // CustomNavRail.getNavRail(),
                  Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 1,
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
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                'Value',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
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
                                                    DataCell(Text(
                                                        e.value.toString())),
                                                  ],
                                                ))
                                            .toList());
                                    // return Text(doc.id);
                                  })),
                                ],
                              )),
                          Spacer(),
                          Flexible(
                              flex: 1,
                              child: SizedBox(
                                  height: 300, child: CaseChatWidget())),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Expanded(child: MatchesWidget(kDB.doc('/case/123')))
                          ]))),
                  Expanded(
                      flex: 1,
                      child: ref.watch(activeSearchResDocRef) == null
                          ? Container()
                          : InvestigationWidget(kDB.doc('/case/123'),
                              ref.watch(activeSearchResDocRef)!
                              // kDB.doc(
                              //     '/case/123/search/Aamir Ali Choudry/res/dfat.gov.au|Aamir Ali Choudry')
                              ))
                ])));
  }
}
