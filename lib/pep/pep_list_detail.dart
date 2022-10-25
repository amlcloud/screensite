import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/pep/pep_listinfo.dart';
import 'package:screensite/pep/pep_entityinfo.dart';

class PepListDetail extends ConsumerWidget {
  final String entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  PepListDetail(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
      constraints: const BoxConstraints(
        minWidth: 70,
        minHeight: 70,
        maxWidth: 150,
        maxHeight: 600,
      ),
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Expanded(flex: 3, child: PepListInfo(entityId)),
                Divider(),
                Expanded(
                  flex: 7,
                  child: PepEntityList(entityId),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Re-fetch'),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 8),
                  ],
                )
                //DataExportButton(entityId),
              ]))));
}
