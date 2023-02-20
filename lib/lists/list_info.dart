import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/lists/api_widget.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:http/http.dart' as http;

import '../common.dart';
import '../state/generic_state_notifier.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
