import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/api_widget.dart';

import 'list_info_details.dart';

class ListInfo extends ConsumerWidget {
  final String entityId;
  final QuerySnapshot<Map<String, dynamic>> _indexStatus;
  const ListInfo(this.entityId, this._indexStatus);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [
        ListDetailsWidget(indexStatus: _indexStatus, entityId: entityId),
        APIWidget(entityId: entityId)
      ]);
}
