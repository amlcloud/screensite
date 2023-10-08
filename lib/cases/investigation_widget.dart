import 'dart:convert';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/col_stream_widget.dart';
import 'package:widgets/doc_stream_widget.dart';

class InvestigationWidget extends ConsumerWidget {
  final DR caseDocRef;
  final DR searchResDocRef;

  InvestigationWidget(this.caseDocRef, this.searchResDocRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: DocStreamWidget(
            docSP(searchResDocRef.path),
            (context, searchResDoc) => DocStreamWidget(
              docSP(caseDocRef.path),
              (context, caseDoc) => SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      searchResDocRef.path,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    ColStreamWidget<Widget>(
                      colSPfiltered2(
                        searchResDoc.reference.collection('message').path,
                        orderBy: 'timeCreated',
                      ),
                      (context, col, items) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          if (index == 0 || index == 1) return Container();
                          return items[index];
                        },
                      ),
                      (context, doc) => Container(
                        width: 200.0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 1000,
                          ),
                          child: MessageWidget(doc.reference),
                        ),
                      ),
                    ),
                    SendMessageWidget(
                      searchResDoc.reference.collection('message'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SendMessageWidget extends ConsumerWidget {
  final CR messageColRef;

  SendMessageWidget(this.messageColRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FocusNode focusNode = FocusNode();
    final TextEditingController ctrl = TextEditingController();

    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
            event.isMetaPressed) {
          
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                maxLines: 10,
                decoration: InputDecoration(hintText: 'Type a message'),
              ),
            ),
            IconButton(
              onPressed: ctrl.text.trim().isEmpty
                  ? null
                  : () {
                     
                    },
              icon: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

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
