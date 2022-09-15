import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/lists/lists_list.dart';
import 'package:screensite/lists/list_details.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/drawer.dart';
import 'package:screensite/common.dart';

final activeList =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class ListsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? Container(
                alignment: Alignment.topLeft,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          child: SingleChildScrollView(
                              child: Column(
                        children: [
                          Lists(),
                        ],
                      ))),
                      Expanded(
                        flex: 2,
                        child: ref.watch(activeList) == null
                            ? Container()
                            : ListDetails(ref.watch(activeList)!),
                      )
                    ]))
            : Container(
                alignment: Alignment.topLeft,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          child: SingleChildScrollView(
                              child: Column(
                        children: [
                          Lists(),
                        ],
                      ))),
                      Expanded(
                        flex: 2,
                        child: ref.watch(activeList) == null
                            ? Container()
                            : ListDetails(ref.watch(activeList)!),
                      )
                    ])));
  }
}
