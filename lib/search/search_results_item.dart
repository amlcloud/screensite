import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:screensite/lists/jsonview_switch.dart';

import 'package:widgets/doc_field_text.dart';

import 'package:widgets/doc_stream_widget.dart';

class SearchResultsItem extends ConsumerWidget {
  final DR _searchResultsSancDocRef;
  final DR _searchResultDocRef;

  const SearchResultsItem(
    this._searchResultsSancDocRef,
    this._searchResultDocRef,
  );
// Refactor entire code
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: _searchResultsSancDocRef.get().asStream(),
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.data == null) {
            widget = Container();
          } else {
            DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;

            widget = Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "List ID: " +
                              _searchResultsSancDocRef.parent.parent!.id
                                  .toString(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),

                        // Error: Expected a value of type 'AutoDisposeStreamProvider<DocumentSnapshot<Map<String, dynamic>>>', but
                        //          got one of type '_JsonDocumentReference'
                        DocStreamWidget(docSP(_searchResultDocRef.path),
                            ((context, doc) {
                          num matchScore = (1 -
                                  doc.data()!['levScore'] /
                                      doc.data()!['target'].length) *
                              100;
                          return Text(
                            'Match Score: ${matchScore.toStringAsFixed(0)} %',
                            style: Theme.of(context).textTheme.titleSmall,
                          );
                        }))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          Text(
                            "List Name: ",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          DocFieldText(
                              _searchResultsSancDocRef.parent.parent!, 'name',
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background),
                        child: SwitchJSON(documentSnapshot.data()))
                  ],
                ));
          }
          return widget;
        });
  }
}
