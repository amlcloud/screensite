import 'cases_exports.dart';

class CasesPage extends ConsumerWidget {
  static String get routeName => 'cases';
  static String get routeLocation => '/$routeName';
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < 600)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildNewCaseButton(),
            buildCasesList(),
          ],
        ));
  }

  Expanded buildCasesList() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
      child: SingleChildScrollView(child: CasesList()),
    ));
  }

  ElevatedButton buildNewCaseButton() {
    return ElevatedButton(
        onPressed: () {
          kDB.collection('user/${kUSR!.uid}/case').add({
            'name': 'new case',
            'status': 'draft',
            'timeCreated': FieldValue.serverTimestamp(),
          });
        },
        child: Text('New case'));
  }
}
