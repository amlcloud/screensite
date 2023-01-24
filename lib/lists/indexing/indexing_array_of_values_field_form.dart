import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/theme.dart';

import '../../controls/doc_field_text_edit.dart';
import '../../providers/firestore.dart';
import 'indexing_form.dart';
import 'indexing_index_by_array.dart';

class IndexingArrayOfValuesFieldForm extends IndexingForm {
  const IndexingArrayOfValuesFieldForm(
      String entityId, QueryDocumentSnapshot<Map<String, dynamic>> document)
      : super(entityId, document);

  @override
  Widget read(WidgetRef ref) {
    return Column(children: [IndexingIndexByArray(entityId, document.id)]);
  }

  @override
  Widget edit(WidgetRef ref) {
    return Column(
        children: ref
            .watch(filteredColSP(QueryParams(
                'list/$entityId/indexConfigs/${document.id}/entityIndexFields/',
                orderBy: 'createdTimestamp', distinct: ((previous, current) {
              return previous.size == current.size;
            }))))
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
                                  validator(doc, data, text, true, callback);
                                }))
                          ]))
                      .toList());
                  children.add(IndexingIndexByArray(entityId, document.id));
                  return children;
                }));
  }
}
