import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class IndexingTextField extends ConsumerWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final int selectedIndex;
  final Map<String, Map<String, TextSelection>> maps;

  TextEditingController textEditingController = TextEditingController();
  Timer? timer;

  IndexingTextField(this.document, this.selectedIndex, this.maps);

  void _update() {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    if (selectedIndex < entityIndexFields.length) {
      entityIndexFields[selectedIndex] = textEditingController.text;
    } else {
      entityIndexFields.add(textEditingController.text);
    }
    document.reference.update({'entityIndexFields': entityIndexFields});
  }

  void onChanged(String text) {
    Map<String, TextSelection>? map = maps[document.id];
    if (map == null) {
      map = {};
      maps[document.id] = map;
    }
    map['$selectedIndex'] = textEditingController.selection;
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(const Duration(milliseconds: 500), () {
      _update();
    });
  }

  void onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      _update();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    if (selectedIndex < entityIndexFields.length) {
      textEditingController.text = entityIndexFields[selectedIndex];
      Map<String, TextSelection>? map = maps[document.id];
      if (map != null) {
        TextSelection? selection = map['$selectedIndex'];
        if (selection != null) {
          try {
            textEditingController.selection = selection;
          } catch (e) {
            print(e);
          }
        }
      }
    }
    var textField = TextField(
      controller: textEditingController,
      onChanged: onChanged,
    );
    return Focus(
      onFocusChange: onFocusChange,
      child: textField,
    );
  }
}
