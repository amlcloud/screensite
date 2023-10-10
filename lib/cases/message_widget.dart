import 'package:common/common.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/doc_stream_widget.dart';

class MessageWidget extends ConsumerWidget {
  final DR messageDocRef;

  MessageWidget(this.messageDocRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DocStreamWidget(
      key: ValueKey(messageDocRef.id),
      docSP(messageDocRef.path),
      (context, messageDoc) => Card(
        child: ListTile(
          trailing: IconButton(
            onPressed: () => messageDocRef.delete(),
            icon: Icon(Icons.delete),
          ),
          leading: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(messageDoc.data()?['role'] ?? ''),
            ],
          ),
          title: Container(
            width: 200,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 50),
              child: Text(messageDoc.data()?['content'] ?? ''),
            ),
          ),
        ),
      ),
    );
  }
}
