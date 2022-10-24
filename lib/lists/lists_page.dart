import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/lists/lists_list.dart';
import 'package:screensite/lists/list_details.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final activeList =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class ListsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
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
                      Lists(),
                    ],
                  ))),
                  Expanded(
                    child: ref.watch(activeList) == null
                        ? Container()
                        : ListDetails(ref.watch(activeList)!),
                  ),
                  Expanded(
                      child: Card(
                          child: SizedBox(
                              width: 300,
                              height: 100,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [Text('text')])))))
                ])));
  }
}
