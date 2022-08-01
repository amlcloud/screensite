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
