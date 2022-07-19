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
                      buildAddEntityButton(context, ref),
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

  buildAddEntityButton(BuildContext context, WidgetRef ref) {
    TextEditingController id_inp = TextEditingController();
    TextEditingController name_inp = TextEditingController();
    TextEditingController desc_inp = TextEditingController();
    return ElevatedButton(
      child: Text("Add Entity"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Adding Entity...'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: id_inp,
                          decoration: InputDecoration(labelText: 'ID'),
                        ),
                        TextFormField(
                          controller: name_inp,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          controller: desc_inp,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      child: Text("Submit"),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('list').add({
                          'id': id_inp.text.toString(),
                          'name': name_inp.text.toString(),
                          'desc': desc_inp.text.toString(),
                          'time Created': FieldValue.serverTimestamp(),
                          'author': FirebaseAuth.instance.currentUser!.uid,
                          // 'author': FirebaseAuth.instance.currentUser!.uid
                        });
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      },
    );
  }
}
