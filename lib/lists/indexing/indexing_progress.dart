import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';

import '../../state/generic_state_notifier.dart';

class IndexingProgress extends ConsumerWidget {
  final String _entityId;
  final StateNotifierProvider<GenericStateNotifier<bool>, bool>
      _indexButtonClicked;

  const IndexingProgress(this._entityId, this._indexButtonClicked);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(_indexButtonClicked)) {
      return Container(
          padding: EdgeInsets.all(8.0), child: Text('Reindexing...'));
    } else {
      return Container(
          child: ref
              .watch(colSPfiltered('indexStatus/', queries: [
                QueryParam('listId', {Symbol('isEqualTo'): _entityId})
              ]))
              .when(
                  loading: () => Container(),
                  error: (e, s) => ErrorWidget(e),
                  data: (data) {
                    Widget widget;
                    if (data.docs.isNotEmpty) {
                      widget = Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              '${data.docs.first.data()['count']} / ${data.docs.first.data()['total']} indexed'));
                    } else {
                      widget = Container();
                    }
                    return widget;
                  }));
    }
  }
}
