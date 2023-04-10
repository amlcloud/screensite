import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/common.dart';
import 'package:screensite/drawer.dart';

import 'case_table_widget.dart';
import 'chat_widget.dart';
import 'matches_widget.dart';

class CasesPage extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();

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
                  Flexible(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: CaseTableWidget()),
                        ],
                      ),
                      Expanded(child: ChatWidget()),
                    ],
                  )),
                  Expanded(
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Expanded(child: MatchesWidget())])))
                ])));
  }
}
