import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:screensite/theme.dart';

class PepEntityList extends ConsumerWidget {
  final String entityId;

  const PepEntityList(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colSP('pepSource/$entityId/entity')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (trnCol) => trnCol.size == 0
              ? Text('no records')
              : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                      width: 500,
                      height: 300,
                      decoration: EntityContainerStyle.containerStyle,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                          child: DataTable(
                              headingRowHeight: 0,
                              columns: (trnCol.docs.first
                                      .data()
                                      .entries
                                      .toList()
                                    ..sort((a, b) => a.key.compareTo(b.key)))
                                  .map((value) => DataColumn(
                                        label: Text(
                                          value.key,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ))
                                  .toList(),
                              rows: trnCol.docs
                                  .map((trnDoc) => DataRow(
                                      cells: (trnCol.docs.first
                                              .data()
                                              .entries
                                              .toList()
                                            ..sort((a, b) =>
                                                a.key.compareTo(b.key)))
                                          .map((cell) => DataCell(
                                              GestureDetector(
                                                  onTap: () {
                                                    final txt = trnDoc.data()[
                                                                cell.key] ==
                                                            null
                                                        ? ''
                                                        : trnDoc
                                                            .data()[cell.key]
                                                            .toString();
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: txt));

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Copied '${txt}'"),
                                                    ));
                                                  },
                                                  child: Text(
                                                      trnDoc.data()[cell.key] ==
                                                              null
                                                          ? ''
                                                          : trnDoc
                                                              .data()[cell.key]
                                                              .toString()))))
                                          .toList()))
                                  .toList())))
                ]));
}
