import 'list_exports.dart';

final selectedItem = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

class ListsPage extends ConsumerWidget {
  static String get routeName => 'lists';
  static String get routeLocation => '/$routeName';
  final selectedList =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildSanctionListsColumn(),
                  buildListDetailsColumn(ref),
                  buildItemDetailsPreviewColumn(ref)
                ])));
  }

  Expanded buildItemDetailsPreviewColumn(WidgetRef ref) {
    return Expanded(
        flex: 2,
        child: Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ref.watch(selectedItem) == null
                        ? Container()
                        : SwitchJSON(ref.watch(selectedItem))),
                ref.watch(selectedList) == null ||
                        ref.watch(selectedItem) == null
                    ? Container()
                    : IndexingItemList(ref.watch(selectedList)!,
                        ref.watch(selectedItem)!, selectedList)
              ],
            ),
          ))
        ])));
  }

  Expanded buildListDetailsColumn(WidgetRef ref) {
    return Expanded(
      flex: 2,
      child: ref.watch(selectedList) == null
          ? Container()
          : ListDetails(ref.watch(selectedList)!, selectedItem),
    );
  }

  Expanded buildSanctionListsColumn() {
    return Expanded(
        flex: 1,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Lists(selectedList),
          ],
        )));
  }
}
