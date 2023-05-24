import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/col_stream_widget.dart';

class MatchesWidget extends ConsumerWidget {
  final DR docRef;
  final TextEditingController searchCtrl = TextEditingController();

  MatchesWidget(this.docRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: ColStreamWidget<Widget>(
            colSP(docRef.collection('search').path),
            (context, snapshot, items) => Column(children: items),
            (context, doc) => Text(doc.data()!['target'])));
  }
}
