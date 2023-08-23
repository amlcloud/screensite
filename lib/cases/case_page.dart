import 'cases_exports.dart';

final SNP<DR?> activeSearchResDocRef = snp(null);

class CasePage extends ConsumerWidget {
  static String get routeName => 'case';
  static String get routeLocation => '/$routeName';

  final String caseId;
  final TextEditingController searchCtrl = TextEditingController();
  final DR caseDocRef;

  CasePage(this.caseId)
      : caseDocRef = kDB.doc('/user/${kUSR!.uid}/case/$caseId') {
    print(caseId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < 600)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: poc(context, ref));
  }

  Widget poc(BuildContext context, WidgetRef ref) {
    return Container(
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
                      Expanded(child: Text('Case: ${caseDocRef.id}')),
                      // Dropdown button for selecting the status

                      DropdownButton<STATUS>(
                        isExpanded: true,
                        value: STATUS.draft,
                        items: getAllStatuses()
                            .map<DropdownMenuItem<STATUS>>(
                              (STATUS value) => DropdownMenuItem<STATUS>(
                                value: value,
                                child: Text(value.name),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) async {
                          await caseDocRef
                              .update({'status': getStatusKey(newValue!)});
                          print('Document updated successfully.');
                        },
                      ),

                      Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: DocStreamWidget(docSP(caseDocRef.path),
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
                                    rows: doc.data()?['content'] == null
                                        ? []
                                        : ((doc.data()?['content']
                                                    as Map<String, dynamic>) ??
                                                {})
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
                              height: 300, child: CaseChatWidget(caseDocRef))),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Card(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Expanded(child: MatchesWidget(caseDocRef))
                      ]))),
              Expanded(
                  flex: 1,
                  child: ref.watch(activeSearchResDocRef) == null
                      ? Text('no active search')
                      : InvestigationWidget(
                          caseDocRef, ref.watch(activeSearchResDocRef)!))
            ]));
  }
}
