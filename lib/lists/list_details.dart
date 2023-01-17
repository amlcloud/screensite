import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/list_info.dart';
import 'package:screensite/lists/list_entitylistview.dart';
import 'package:screensite/lists/list_indexing.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/theme.dart';

import 'list_count.dart';

class ListDetails extends ConsumerWidget {
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
      selectedItem;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  ListDetails(this.entityId, this.selectedItem);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
      decoration: RoundedCornerContainer.containerStyle,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(flex: 1, child: ListInfo(entityId)),
            Divider(),
            ListIndexing(entityId),
            Divider(),
            //Timeline(entityId),
            /*Expanded(
              flex: 10,
              child: EntityList(entityId),
            ),*/
            //DataExportButton(entityId),
            Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: EntityListView(entityId, selectedItem),
                )),
            Divider(),
            ListCount(entityId),
          ]));
}
