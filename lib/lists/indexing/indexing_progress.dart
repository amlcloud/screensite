import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/generic_state_notifier.dart';

class IndexingProgress extends ConsumerWidget {
  final String _entityId;
  final bool _clicked;
  final AlwaysAliveProviderBase<GenericStateNotifier<bool>>
      _reindexInitiatedNotifier;
  final QuerySnapshot<Map<String, dynamic>> _indexStatus;

  const IndexingProgress(this._entityId, this._clicked,
      this._reindexInitiatedNotifier, this._indexStatus);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int count;
    int total;
    if (_indexStatus.docs.isNotEmpty) {
      count = _indexStatus.docs.first.data()['count'];
      total = _indexStatus.docs.first.data()['total'];
    } else {
      count = total = 0;
    }
    Widget widget;
    if (count == total &&
        _clicked &&
        ref.read(_reindexInitiatedNotifier).value == false) {
      widget =
          Container(padding: EdgeInsets.all(8.0), child: Text('Reindexing...'));
      ref.read(_reindexInitiatedNotifier).value = true;
    } else if (_indexStatus.docs.isNotEmpty) {
      widget = Container(
          padding: EdgeInsets.all(8.0),
          child: Text('${count} / ${total} indexed'));
    } else {
      widget = Container();
    }
    return widget;
  }
}
