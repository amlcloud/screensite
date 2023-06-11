import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/drawer.dart';

import 'cases_list.dart';

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
            ElevatedButton(
                onPressed: () {
                  kDB
                      .collection('user/${kUSR!.uid}/case')
                      .add({'name': 'new case', 'status': 'draft'});
                },
                child: Text('New case')),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
              child: SingleChildScrollView(child: CasesList()),
            )),
          ],
        ));
  }
}
