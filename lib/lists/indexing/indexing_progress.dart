import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';

import '../../state/generic_state_notifier.dart';

class IndexingProgress extends ConsumerWidget {
  final String _entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<bool?>>
      _indexButtonClicked;
  const IndexingProgress(this._entityId, this._indexButtonClicked);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  } else if (ref.read(_indexButtonClicked).value == true) {
                    widget = Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Reindexing...'));
                  } else {
                    widget = Container();
                  }
                  return widget;
                }));
  }
}
