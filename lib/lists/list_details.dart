import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/lists/list_info.dart';
import 'package:screensite/lists/transaction_list.dart';

class ListDetails extends ConsumerWidget {
  final String entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  ListDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(flex: 1, child: ListInfo(entityId)),
            Divider(),
            //Timeline(entityId),
            Expanded(
              flex: 10,
              child: EntityList(entityId),
            ),
            //DataExportButton(entityId),
          ]));
}
