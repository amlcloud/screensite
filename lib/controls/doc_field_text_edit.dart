import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';

class DocFieldTextEdit extends ConsumerStatefulWidget {
  final DocumentReference docRef;
  final String field;
  final InputDecoration? decoration;

  final TextEditingController ctrl = TextEditingController();

  DocFieldTextEdit(this.docRef, this.field, {this.decoration, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DocFieldTextEditState();
}

class DocFieldTextEditState extends ConsumerState<DocFieldTextEdit> {
  Timer? descSaveTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(docSPdistinct(DocParam(widget.docRef.path, (prev, curr) {
          //print('equals called');
          if (prev.data()![widget.field] == curr.data()![widget.field]) {
            // print('field ${field} did not change, return true');
            return true;
          }
          if (widget.ctrl.text == curr.data()![widget.field]) {
            return true;
          }
          // print(
          //     'field changed! ctrl: ${widget.ctrl.text}!=${curr.data()![widget.field]}');
          return false;
        })))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (docSnapshot) {
              return TextField(
                decoration: widget.decoration,
                controller: widget.ctrl
                  ..text = docSnapshot.data()![widget.field] ?? '',
                onChanged: (v) {
                  if (descSaveTimer != null && descSaveTimer!.isActive) {
                    descSaveTimer!.cancel();
                  }
                  descSaveTimer = Timer(Duration(milliseconds: 200), () {
                    if (docSnapshot.data() == null ||
                        v != docSnapshot.data()![widget.field]) {
                      Map<String, dynamic> map = {};
                      map[widget.field] = v;
                      // the document will get created, if not exists
                      widget.docRef.set(map, SetOptions(merge: true));
                      // throws exception if document doesn't exist
                      //widget.docRef.update({widget.field: v});
                    }
                  });
                },
              );
            });
  }
}

/// 
/// Version of textedit without delayed saving
///
// class DocFieldTextEdit extends ConsumerWidget {
//   final DocumentReference docRef;
//   final String field;
//   final TextEditingController ctrl = TextEditingController();

//   DocFieldTextEdit(this.docRef, this.field);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // print('DocFieldTextEdit rebuild');
//     return ref
//         .watch(docSPdistinct(DocParam(docRef.path, (prev, curr) {
//           // print('equals called');
//           if (prev.data()![field] == curr.data()![field]) {
//             // print('field ${field} did not change, return true');
//             return true;
//           }
//           if (ctrl.text == curr.data()![field]) {
//             // print(
//             //     'ctrl.text (${ctrl.text}) == snap text (${curr.data()![field]})');
//             return true;
//           }
//           return false;
//         })))
//         .when(
//             loading: () => Container(),
//             error: (e, s) => ErrorWidget(e),
//             data: (docSnapshot) => TextField(
//                   controller: ctrl..text = docSnapshot.data()![field],
//                   onChanged: (v) {
//                     docRef.update({field: v});
//                   },
//                 ));
//   }
// }
