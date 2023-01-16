import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firestore.dart';

class IndexingItemList extends ConsumerWidget {
  final String _ref;

  const IndexingItemList(this._ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(''):
    // return Column(
    //     children: ref
    //         .watch(filteredColSP(QueryParams(path: 'index/', queries: [
    //           // QueryParam('ref', {Symbol('isEqualTo'): _ref}),
    //           QueryParam('he', {Symbol('isEqualTo'): true})
    //         ])))
    //         .when(
    //             loading: () => [Container()],
    //             error: (e, s) => [ErrorWidget(e)],
    //             data: (data) => [
    //                   Text('Reference: $_ref'),
    //                   Text('Count: ${data.docs.length}')
    //                 ]));
  }
}
