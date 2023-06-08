import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:providers/firestore.dart';
import 'package:screensite/cases/case_page.dart';
import 'package:widgets/doc_field_text.dart';

import 'case_status.dart';

class CaseItem extends ConsumerWidget {
  final DR caseRef;
  final TextEditingController ctrl = TextEditingController();
  final bool showStatus, showRecentActions;
  final applicationRef = FirebaseFirestore.instance
      .collection("user")
      .doc(kUSR!.uid)
      .collection('case');

  CaseItem(this.caseRef,
      {this.showStatus = false, this.showRecentActions = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        height: 200,
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.only(top: 30),
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              // splashColor: Theme.of(context)
              //     .primaryColorLight
              //     .withAlpha(30),
              onTap: () {
                print('InkWell tapped');

                context.go(
                  //CasePage.routeName,
                  '/cases/${caseRef.id}',
                  extra: {
                    "caseId": caseRef.id,
                  },
                );
                // context.pushNamed(
                //   'case',
                //   queryParameters: {
                //     "caseId": caseRef.id,
                //   },
                // );
              },
              child: Column(
                children: [
                  DocFieldText(caseRef, 'name'),
                ],
              )),
        ),
      );

  Container buildStatus(STATUS status) {
    return Container(
        color: Colors.green,
        width: 80,
        height: 40,
        child: Center(
          child: Text(
            status.name,
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget _buildLastStatusUpdate(DocumentSnapshot<Map<String, dynamic>> appDoc) {
    // retrieve the number of days since the last status update
    if (appDoc.data()?['statusUpdateTime'] != null) {
      // get the last time the status was updated
      var lastUpdatedStatusDay =
          Jiffy(appDoc.data()!['statusUpdateTime'].toDate()).startOf(Units.DAY);
      // count how many days ago that was since now
      var daysAgo = Jiffy().diff(lastUpdatedStatusDay, Units.DAY);

      return Text(
        '$daysAgo',
        textAlign: TextAlign.center,
      );
    }
    return Container();
  }
}
