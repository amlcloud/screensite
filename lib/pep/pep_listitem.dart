import 'dart:async';
import 'pep_exports.dart';

class PepListItem extends ConsumerWidget {
  final String entityId;
  const PepListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('pepSource/' + entityId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Expanded(
                child: Card(
                  child: InkWell(
                    onTap: () {
                      ref.read(activePepLib.notifier).value = entityId;
                    },
                    child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                10), //apply padding to all four sides
                                        child: Text(
                                          entityDoc.data()!['url'] ?? 'url',
                                        ))),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(Icons.help_outline),
                                          onPressed: () {},
                                        )))
                              ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              entityDoc
                                                      .data()!['correctness'] ??
                                                  'Ambiguous',
                                            ),
                                            ref
                                                .watch(colSP(
                                                    'pepSource/$entityId/entity'))
                                                .when(
                                                    loading: () => Container(),
                                                    error: (e, s) =>
                                                        ErrorWidget(e),
                                                    data: (trnCol) => trnCol
                                                                .size ==
                                                            0
                                                        ? Text('no records')
                                                        : Text(trnCol.size
                                                                .toString() +
                                                            ' people'))
                                          ]),
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(children: [
                                              Text('Last updated: ' +
                                                  Jiffy(entityDoc
                                                          .data()![
                                                              'lastUpdated']
                                                          .toDate())
                                                      .format())
                                            ]),
                                            Row(children: [
                                              Text('Created: ' +
                                                  Jiffy(entityDoc
                                                          .data()!['timeAdded']
                                                          .toDate())
                                                      .format())
                                            ])
                                          ]),
                                    )
                                  ])
                            ],
                          ),
                        )),
                  ),
                ),
              ));
  }

  Future<bool> CheckSelected() async {
    var batchRef = await FirebaseFirestore.instance.collection('batch').get();
    for (var element in batchRef.docs) {
      var selectList = await FirebaseFirestore.instance
          .collection('batch')
          .doc(element.id)
          .collection('SelectedEntity')
          .doc(entityId)
          .get();
      if (selectList.exists) {
        print("sample data temp1: ${selectList.exists}");
        //temp = false;
        return selectList.exists;
      }
    }
    return false;
  }
}
