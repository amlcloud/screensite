import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';

class IndexingProgress extends ConsumerWidget {
  final String _entityId;
  const IndexingProgress(this._entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
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
            });
  }
}
