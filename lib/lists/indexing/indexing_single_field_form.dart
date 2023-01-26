import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/controls/doc_field_text_edit.dart';
import 'package:screensite/providers/firestore.dart';

import 'indexing_form.dart';
import 'indexing_index_by.dart';

class IndexingSingleFieldForm extends IndexingForm {
  const IndexingSingleFieldForm(
      String entityId, QueryDocumentSnapshot<Map<String, dynamic>> document)
      : super(entityId, document);

  @override
  Widget read(WidgetRef ref) {
    return Column(children: [IndexingIndexBy(entityId, document.id)]);
  }

  @override
  Widget edit(WidgetRef ref) {
    return Column(
        children: ref
            .watch(colSPfiltered(
                'list/$entityId/indexConfigs/${document.id}/entityIndexFields/',
                orderBy: 'createdTimestamp', distinct: ((previous, current) {
              return previous.size == current.size;
            })))
            .when(
                loading: () => [Container()],
                error: (e, s) => [ErrorWidget(e)],
                data: (data) {
                  List<Widget> children = [];
                  children.addAll(data.docs
                      .asMap()
                      .entries
                      .map<Widget>((doc) => Row(children: [
                            Container(
                                width: 80,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                    child: Text('Full Name'))),
                            Flexible(
                                flex: 1,
                                child: DocFieldTextEdit(
                                    doc.value.reference, 'value',
                                    valid: doc.value['valid'],
                                    validator: (text, callback) {
                                  validator(doc, data, text, false, callback);
                                }))
                          ]))
                      .toList());
                  children.add(IndexingIndexBy(entityId, document.id));
                  return children;
                }));
  }
}
