import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:screensite/theme.dart';
import 'package:widgets/doc_field_text_field.dart';

class Sandbox extends StatelessWidget {
  const Sandbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: RoundedCornerContainer.containerStyle,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            ListTile(
              title: DocFieldTextField(
                  FirebaseFirestore.instance.doc('/dev/serge/text_edit/1'),
                  'the_field'),
            ),
            ListTile(
              title: Text('Text Widget 1'),
            )
          ],
        ));
  }
}
