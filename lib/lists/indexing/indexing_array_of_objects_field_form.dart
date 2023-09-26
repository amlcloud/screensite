import 'indexing_exports.dart';

class IndexingArrayOfObjectsFieldForm extends IndexingForm {
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>
      stateNotifierProvider =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));

  IndexingArrayOfObjectsFieldForm(
      String entityId, QueryDocumentSnapshot<Map<String, dynamic>> document)
      : super(entityId, document);

  @override
  Widget read(WidgetRef ref) {
    return Column(children: [IndexingIndexByArray(entityId, document.id)]);
  }

  @override
  Widget edit(WidgetRef ref) {
    return Column(
        children: ref
            .watch(colSPfiltered(
                'list/$entityId/indexConfigs/${document.id}/entityIndexFields/',
                orderBy: 'createdTimestamp', distinct: ((previous, current) {
              return previous.size == current.size;
            })))
            .when(
                loading: () => [Container()],
                error: (e, s) => [ErrorWidget(e)],
                data: (data) {
                  List<Widget> children = [];
                  children.addAll(data.docs
                      .asMap()
                      .entries
                      .map<Widget>((doc) => Row(children: [
                            Container(
                                width: 80,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                    child: Text('Names Field'))),
                            Flexible(
                                flex: 1,
                                child: DocFieldDropDown(
                                    doc.value.reference,
                                    'value',
                                    stateNotifierProvider,
                                    ref
                                        .watch(colSPfiltered(
                                            'list/$entityId/fields/',
                                            queries: [
                                              QueryParam('type', {
                                                Symbol('isEqualTo'): 'array'
                                              })
                                            ]))
                                        .when(
                                            loading: () => [],
                                            error: (e, s) => [],
                                            data: (data) => data.docs
                                                .map((e) => e.id)
                                                .toList())))
                          ]))
                      .toList());
                  children.add(
                    Row(children: [
                      Container(
                          width: 80,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: Text('Name field name'))),
                      Flexible(
                          flex: 1,
                          child: TextField(
                            controller: nameFieldValue,
                          ))
                    ]),
                  );
                  children.add(IndexingIndexByArray(entityId, document.id));
                  return children;
                }));
  }
}
