import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/lists/lists_list.dart';
import 'package:screensite/lists/list_details.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/drawer.dart';
import 'package:screensite/common.dart';
import 'jsonview_switch.dart';
//import 'jsonview_switch.dart';
// import 'package:flutter_json_viewer/flutter_json_viewer.dart';

import 'indexing/indexing_item_list.dart';

final selectedItem = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

class ListsPage extends ConsumerWidget {
  final activeList =
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
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      Lists(activeList),
                    ],
                  ))),
                  Expanded(
                    child: ref.watch(activeList) == null
                        ? Container()
                        : ListDetails(
                            ref.watch(activeList)!, selectedItem.notifier),
                  ),
                  Expanded(
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ref.watch(selectedItem) == null
                                      ? Container()
                                      : SwitchJSON(ref.watch(selectedItem))),
                              ref.watch(activeList) == null ||
                                      ref.watch(selectedItem) == null
                                  ? Container()
                                  : IndexingItemList(ref.watch(activeList)!,
                                      ref.watch(selectedItem)!, activeList)
                            ],
                          ),
                        ))
                      ])))
                ])));
  }
}
