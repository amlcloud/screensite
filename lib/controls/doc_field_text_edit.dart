import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocFieldTextEdit extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final InputDecoration? decoration;
  final void Function(String, void Function(bool))? validator;
  final bool? valid;
  final String? validationErrorMessage;

  const DocFieldTextEdit(this.docRef, this.field,
      {this.decoration,
      Key? key,
      this.validator,
      this.valid,
      this.validationErrorMessage})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DocFieldTextEditState();
}

class DocFieldTextEditState extends ConsumerState<DocFieldTextEdit> {
  Timer? descSaveTimer;
  StreamSubscription? sub;

  final TextEditingController ctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? valid;

  @override
  void initState() {
    super.initState();
    sub = widget.docRef.snapshots().listen((event) {
      if (!event.exists) return;
      ctrl.text = event.data()![widget.field];
      ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
      print('received ${event.data()![widget.field]}');
      if (ctrl.text != event.data()![widget.field]) {
        ctrl.text = event.data()![widget.field];
        valid = widget.valid;
        Future.delayed(Duration.zero, () {
          _formKey.currentState?.validate();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (sub != null) {
      print('sub cancelled');
      sub!.cancel();
      sub = null;
    }
  }

  void _update(String v) {
    if (descSaveTimer != null && descSaveTimer!.isActive) {
      descSaveTimer!.cancel();
    }
    descSaveTimer = Timer(Duration(milliseconds: 200), () {
      widget.validator?.call(ctrl.text, (valid) {
        this.valid = valid;
        _formKey.currentState?.validate();
      });
      // if (docSnapshot.data() == null ||
      //     v != docSnapshot.data()![widget.field]) {
      Map<String, dynamic> map = {};
      map[widget.field] = v;
      // the document will get created, if not exists
      widget.docRef.set(map, SetOptions(merge: true));
      // throws exception if document doesn't exist
      //widget.docRef.update({widget.field: v});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.validator == null
        ? TextFormField(
            decoration: widget.decoration,
            controller: ctrl,
            onChanged: _update,
            // onSubmitted: _update,
          )
        : Form(
            key: _formKey,
            child: TextFormField(
                decoration: widget.decoration,
                controller: ctrl,
                onChanged: _update,
                // onSubmitted: _update,
                validator: (value) {
                  return valid == null || valid == true
                      ? null
                      : widget.validationErrorMessage ?? 'Error';
                }));
  }
}
