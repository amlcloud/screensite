import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';

class EntityList extends ConsumerWidget {
  final String entityId;

  const EntityList(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colSP('list/$entityId/item')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (trnCol) => trnCol.size == 0
              ? Text('no records')
              : Column(
                  children: [
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: trnCol.docs.first
                    //         .data()
                    //         .entries
                    //         .map((e) => Text(e.key.toString()))
                    //         .toList()),
                    Expanded(
                        child:
                            //  ListView(
                            //     padding: EdgeInsets.zero,
                            //     shrinkWrap: true,
                            //     children: trnCol.docs
                            //         .map((trnDoc) => Transaction(trnDoc))
                            //         .toList()),
                            Column(
                      children: [
                        DataTable(
                            columns: (trnCol.docs.first.data().entries.toList()
                                  ..sort((a, b) => a.key.compareTo(b.key)))
                                .map((value) => DataColumn(
                                      label: Row(
                                        children: [
                                          Text(
                                            value.key,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                            overflow: TextOverflow.fade,
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                            rows: []),
                        Expanded(
                            child: SingleChildScrollView(
                                child: DataTable(
                                    headingRowHeight: 0,
                                    columns: (trnCol.docs.first.data().entries.toList()
                                          ..sort(
                                              (a, b) => a.key.compareTo(b.key)))
                                        .map((value) => DataColumn(
                                              label: Text(
                                                value.key,
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ))
                                        .toList(),
                                    rows: trnCol.docs
                                        .map((trnDoc) => DataRow(
                                            cells: (trnCol.docs.first.data().entries.toList()
                                                  ..sort((a, b) =>
                                                      a.key.compareTo(b.key)))
                                                .map((cell) => DataCell(
                                                    GestureDetector(
                                                        onTap: () {
                                                          final txt = trnDoc
                                                                          .data()[
                                                                      cell
                                                                          .key] ==
                                                                  null
                                                              ? ''
                                                              : trnDoc
                                                                  .data()[
                                                                      cell.key]
                                                                  .toString();
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: txt));

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "Copied '${txt}'"),
                                                          ));
                                                        },
                                                        child: Text(trnDoc.data()[cell.key] == null
                                                            ? ''
                                                            : trnDoc
                                                                .data()[cell.key]
                                                                .toString()))))
                                                .toList()))
                                        .toList())))
                      ],
                    ))
                  ],
                ));
}
