import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/indexing/indexing_index_by.dart';

import '../../controls/doc_field_text_edit.dart';
import '../../providers/firestore.dart';
import 'indexing_form.dart';

class IndexingMultipleFieldsForm extends IndexingForm {
  const IndexingMultipleFieldsForm(
      String entityId, QueryDocumentSnapshot<Map<String, dynamic>> document)
      : super(entityId, document);

  void _updateNumberOfNames(int numberOfNames, int length) {
    CollectionReference collectionRef =
        document.reference.collection('entityIndexFields');
    if (length < numberOfNames) {
      for (int i = length; i < numberOfNames; i++) {
        collectionRef.add({
          'value': '',
          'createdTimestamp': DateTime.now().millisecondsSinceEpoch,
          'valid': null
        });
      }
    } else if (length > numberOfNames) {
      collectionRef.orderBy('createdTimestamp').get().then((value) {
        final List<int> indices =
            Iterable<int>.generate(value.docs.length).toList();
        indices.forEach((index) {
          if (index >= numberOfNames) {
            value.docs.elementAt(index).reference.delete();
          }
        });
      });
    }
  }

  Widget numberOfNames(QuerySnapshot<Map<String, dynamic>> data) {
    return Row(children: [
      Container(
        width: 128,
        child: Text('Number of names'),
      ),
      data.docs.isEmpty
          ? Container()
          : Flexible(
              flex: 1,
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: '${data.docs.length}',
                  items: [for (int i = 1; i <= 10; i++) '$i']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      _updateNumberOfNames(int.parse(value), data.docs.length);
                    }
                  }))
    ]);
  }

  @override
  Widget read(WidgetRef ref) {
    return Column(children: [IndexingIndexBy(entityId, document.id)]);
  }

  @override
  Widget edit(WidgetRef ref) {
    List<Widget> children = [];
    children.addAll(ref
        .watch(filteredColSP(QueryParams(
            'list/$entityId/indexConfigs/${document.id}/entityIndexFields/',
            orderBy: 'createdTimestamp', distinct: ((previous, current) {
          for (int i = 0; i < previous.size; i++) {
            print('${previous.docs[i].data()} ${current.docs[i].data()}');
          }
          print('Size: ${previous.size} ${current.size}');
          return previous.size == current.size;
        }))))
        .when(
            loading: () => [Container()],
            error: (e, s) => [ErrorWidget(e)],
            data: (data) {
              List<Widget> children = [];
              children.add(numberOfNames(data));
              children.addAll(data.docs
                  .asMap()
                  .entries
                  .map<Widget>((doc) => Row(children: [
                        Container(
                            width: 80,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: Text('Name ${doc.key + 1}'))),
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
              return children;
            }));
    children.add(IndexingIndexBy(entityId, document.id));
    return Column(children: children);
  }
}
