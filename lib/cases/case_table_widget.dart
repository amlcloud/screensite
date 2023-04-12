import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:intl/intl.dart';

class CaseTableWidget extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();
  final String caseId;

  CaseTableWidget(this.caseId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Property',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Value',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        )
      ],
      rows:
          //  docFieldList(context, ref, '/index/api.trade.gov| I. ASH',
          //     //'case/1',
          //     builder: (context, item) => DataRow(cells: <DataCell>[
          //           DataCell(Text(item.key)),
          //           DataCell(Text(item.value.toString())),
          //         ]))

          ref.watch(docSP('case/${caseId}')).when(
              data: (caseDoc) => caseDoc
                  .data()!
                  .entries
                  .map<DataRow>((e) => DataRow(cells: <DataCell>[
                        DataCell(Text(e.key)),
                        DataCell((e.value.runtimeType == Timestamp)
                            ? Text(formatDate(e.value))
                            : Text(e.value.toString())),
                      ]))
                  .toList(),
              loading: () => [],
              error: (e, s) => []),
    ));
  }
}

List<T> docFieldList<T>(BuildContext context, WidgetRef ref, String address,
    { //required AsyncWidgetBuilder<T> builder
    required T Function(BuildContext context, MapEntry<String, dynamic> data)
        builder}) {
  return ref.watch(docSP(address)).when(
      data: (caseDoc) =>
          caseDoc.data()!.entries.map<T>((e) => builder(context, e)).toList(),
      loading: () => [],
      error: (e, s) => []);
}


// class DocFieldListWidget extends ConsumerWidget {

//   /// The build strategy currently used by this builder.
//   ///
//   /// This builder must only return a widget and should not have any side
//   /// effects as it may be called multiple times.
//   final AsyncWidgetBuilder<T> builder;

//   const DocFieldListWidget({
//     super.key,
//     required this.builder,
//   }) : assert(builder != null);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//       StreamBuilder
//       // ref.watch(docSP('case/1')).when(
//       //     data: (caseDoc) => caseDoc
//       //         .data()!
//       //         .entries
//       //         .map<DataRow>((e) =>

//   }
// }
