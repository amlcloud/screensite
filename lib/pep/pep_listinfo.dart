import 'pep_exports.dart';

class PepListInfo extends ConsumerWidget {
  final String entityId;
  const PepListInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('pepSource/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: 2), //apply padding to all four sides
                        child: Text(entityDoc.data()!['url'] ?? 'url'))
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: 5), //apply padding to all four sides
                        child: Text('Last updated: ' +
                            Jiffy(entityDoc.data()!['lastUpdated'].toDate())
                                .format()))
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: 5), //apply padding to all four sides
                        child: Text('Last source change: ' +
                            Jiffy(entityDoc
                                    .data()!['lastSourceChanged']
                                    .toDate())
                                .format()))
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: 5), //apply padding to all four sides
                        child: Text('Last fetch change: ' +
                            Jiffy(entityDoc
                                    .data()!['lastFetchChanged']
                                    .toDate())
                                .format()))
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: 2), //apply padding to all four sides
                        child: Text('When data broke: ' +
                            Jiffy(entityDoc.data()!['timeDataBroke'].toDate())
                                .format()))
                  ])
                ],
              ));
}
