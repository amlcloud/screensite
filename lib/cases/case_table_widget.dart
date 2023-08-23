import 'cases_exports.dart';

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
