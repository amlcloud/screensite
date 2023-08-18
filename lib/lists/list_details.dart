import '../common.dart';
import '_exports.dart';

class ListDetails extends ConsumerWidget {
  final String listId;
  final StateNotifierProvider<GenericStateNotifier<Map<String, dynamic>?>,
      Map<String, dynamic>?>? selectedItem;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  ListDetails(this.listId, this.selectedItem);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(colSPfiltered('indexStatus/', queries: [
          QueryParam('listId', {Symbol('isEqualTo'): listId})
        ]))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (indexStatus) {
              return Container(
                  decoration: RoundedCornerContainer.containerStyle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildHeader(context, ref),
                          Divider(),
                          ListIndexingWidget(listId: listId),
                          Divider(),
                          buildSourcesLinks(context, ref),
                          Divider(),
                          ListIndicesWidget(listId),
                          Divider(),
                          buildEntityList(),
                          Divider(),
                          Expanded(child: ListCount(listId)),
                        ]),
                  ));
            });
  }

  Expanded buildEntityList() {
    return Expanded(
        flex: 10,
        child: SingleChildScrollView(
          child: EntityListView(listId, selectedItem),
        ));
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              DocFieldText(
                kDB.doc('list/$listId'),
                'name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _buildAPIButton(context),
            ]),
            Text(
              'id: $listId',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Flexible(
                child: DocFieldText(
              kDB.doc('list/$listId'),
              'lastUpdateTime',
              builder: (c, ref, v) => 'Last changed: ${formatDateTime(v)}',
              style: Theme.of(context).textTheme.labelSmall,
            )),
          ],
        ),
        ref
            .watch(docSP('admin/${FirebaseAuth.instance.currentUser!.uid}'))
            .when(
                loading: () => Container(),
                error: (e, s) => ErrorWidget(e),
                data: (doc) {
                  return doc.exists
                      ? InkWell(
                          child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final _formKey = GlobalKey<FormState>();
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Text('Sanction list settings'),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: <Widget>[
                                                DocFieldTextField(
                                                    FirebaseFirestore.instance
                                                        .doc('list/${listId}'),
                                                    'entitiesName1',
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Entity Name 1")),
                                                DocFieldTextField(
                                                    FirebaseFirestore.instance
                                                        .doc('list/${listId}'),
                                                    'entitiesName2',
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Entity Name 2")),
                                                DocFieldTextField(
                                                    FirebaseFirestore.instance
                                                        .doc('list/${listId}'),
                                                    'name',
                                                    decoration: InputDecoration(
                                                        hintText: "List Name")),
                                                DocFieldTextField(
                                                    FirebaseFirestore.instance
                                                        .doc('list/${listId}'),
                                                    'entitiesAddress',
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Entity address")),
                                                DocFieldTextField(
                                                    FirebaseFirestore.instance
                                                        .doc('list/${listId}'),
                                                    'dataSource',
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Data Source")),
                                                DocFieldTextField(
                                                    FirebaseFirestore.instance
                                                        .doc('list/${listId}'),
                                                    'website',
                                                    decoration: InputDecoration(
                                                        hintText: "Website")),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Done'),
                                          )
                                        ], //actions
                                      );
                                    } // Builder Widget
                                    ); //show dialog
                              }))
                      : Container();
                }),
      ],
    );
  }

  TextButton _buildAPIButton(BuildContext context) {
    return TextButton(
        child: Text("API"),
        onPressed: () => showCustomDialog(
                context,
                'API Details',
                Column(children: <Widget>[
                  Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("curl: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: CopyToClipboardWidget(
                              child: Text(generateCurlUrl("GET", listId)),
                              text: generateCurlUrl("GET", listId)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Text("url: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: CopyToClipboardWidget(
                                child: Text(generateBrowserUrl(listId)),
                                text: generateBrowserUrl(listId),
                              ),
                            ),
                          ],
                        )),
                  ])
                ]),
                [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  )
                ]));
  }

  Widget buildSourcesLinks(BuildContext context, WidgetRef ref) {
    return DocStreamWidget(
        docSP('list/$listId'),
        (c, listDoc) =>
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(TextSpan(
                        style: TextStyle(decoration: TextDecoration.underline),
                        //make link underline
                        text: listDoc.data()?['website'] ?? '',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            //on tap code here, you can navigate to other page or URL
                            final url =
                                Uri.parse(listDoc.data()!['website'] ?? '#');
                            var urllaunchable = await canLaunchUrl(
                                url); //canLaunch is from url_launcher package
                            if (urllaunchable) {
                              await launchUrl(
                                  url); //launch is from url_launcher package to launch URL
                            } else {
                              print("URL can't be launched.");
                            }
                          }))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text.rich(TextSpan(
                        style: TextStyle(decoration: TextDecoration.underline),
                        //make link underline
                        text: listDoc.data()?['dataSource'] ?? '',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            //on tap code here, you can navigate to other page or URL
                            final url =
                                Uri.parse(listDoc.data()!['dataSource'] ?? '#');
                            var urllaunchable = await canLaunchUrl(
                                url); //canLaunch is from url_launcher package
                            if (urllaunchable) {
                              await launchUrl(
                                  url); //launch is from url_launcher package to launch URL
                            } else {
                              print("URL can't be launched.");
                            }
                          })),
                  ]),
            ]));
  }
}
