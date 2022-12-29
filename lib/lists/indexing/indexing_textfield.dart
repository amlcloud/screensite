import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class IndexingTextField extends ConsumerWidget {
  final String entityId;
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final int selectedIndex;
  final Map<String, Map<String, TextSelection>> maps;

  TextEditingController textEditingController = TextEditingController();
  Timer? timer;

  IndexingTextField(
      this.entityId, this.document, this.selectedIndex, this.maps);

  void _update(bool valid) {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    List<dynamic> validFields = document.data()['validFields'];
    String text = textEditingController.text;
    if (selectedIndex < entityIndexFields.length) {
      entityIndexFields[selectedIndex] = text;
      validFields[selectedIndex] = valid;
    } else {
      for (int i = entityIndexFields.length; i <= selectedIndex; i++) {
        entityIndexFields.add('');
        validFields.add(false);
      }
      entityIndexFields[selectedIndex] = text;
      validFields[selectedIndex] = valid;
    }
    document.reference.update(
        {'entityIndexFields': entityIndexFields, 'validFields': validFields});
  }

  void _validate() {
    List<dynamic> entityIndexFields = document.data()['entityIndexFields'];
    String text = textEditingController.text;
    if (text.isEmpty) {
      _update(false);
    } else {
      bool duplicated = false;
      for (int i = 0; i < entityIndexFields.length; i++) {
        if (i != selectedIndex && entityIndexFields[i] == text) {
          duplicated = true;
          break;
        }
      }
      if (duplicated) {
        _update(false);
      } else {
        FirebaseFirestore.instance
            .collection('list/${entityId}/item')
            .orderBy(text)
            .limit(1)
            .snapshots()
            .listen((event) {
          _update(event.docs.isNotEmpty);
        });
      }
    }
  }

  void _onChanged(String text) {
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
      _validate();
    });
  }

  void _onFocusChange(bool hasFocus) {
    if (!hasFocus) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      _validate();
    }
  }

  bool isValid() {
    bool valid = true;
    List<dynamic> validFields = document.data()['validFields'];
    if (selectedIndex < validFields.length) {
      valid = validFields[selectedIndex];
    }
    return valid;
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
          } catch (e) {}
        }
      }
    }
    return Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: isValid() ? Colors.transparent : Colors.red)),
        child: Focus(
          onFocusChange: _onFocusChange,
          child: Column(children: [
            TextField(
              controller: textEditingController,
              onChanged: _onChanged,
            )
          ]),
        ));
  }
}
