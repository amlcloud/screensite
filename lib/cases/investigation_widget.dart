import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:widgets/col_stream_widget.dart';
import 'package:widgets/copy_to_clipboard_widget.dart';
import 'package:widgets/doc_stream_widget.dart';
import 'package:http/http.dart' as http;

import 'chat_widget.dart';
import 'openai.dart';

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
                              ElevatedButton(
                                  onPressed: () => startInvestigationMessage(
                                      searchResDoc, caseDoc),
                                  child: Text('Investigate')),
                              Text(
                                searchResDocRef.path,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              ColStreamWidget<Widget>(
                                  colSPfiltered2(
                                      searchResDoc.reference
                                          .collection('message')
                                          .path,
                                      orderBy: 'timeCreated'),
                                  (context, col, items) =>

                                      // Column(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     mainAxisSize: MainAxisSize.min,
                                      //     children: items)
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            if (index == 0 || index == 1)
                                              return Container();
                                            return items[index];
                                          }),
                                  (context, doc) => Container(
                                      width: 200.0, // Set the width as you need
                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: 1000,
                                          ),
                                          // )
                                          // SizedBox(
                                          //     height: 400,
                                          child: //DocPrintWidget(doc.reference)
                                              MessageWidget(doc.reference)
                                          // DocPrintWidget(
                                          //     doc.reference)
                                          ))),
                              SendMessageWidget(
                                  searchResDoc.reference.collection('message'),
                                  (msg) {
                                postMessages(
                                    searchResDoc.reference
                                        .collection('message'),
                                    searchResDocRef);
                              })
                            ]))))),
      ],
    );
  }

  void startInvestigationMessage(DS searchResDoc, DS caseDoc) async {
    final messagesRef = searchResDoc.reference.collection('message');

    if ((await messagesRef.get()).size == 0) {
      await messagesRef.add({
        'role': 'system',
        'timeCreated': FieldValue.serverTimestamp(),
        'content':
            'You are a sanctions investigator. You need to compare the information about the customer with the information in the sanction document and decide whether the customer is the same person as the person in the sanction document.'
      });

      final sanctionDoc = await (searchResDoc.data()!['ref'] as DR).get();
      final prompt =
          """Here is my customer information: ${caseDoc.data()?['content']}\n\nHere is the information in the sanction document: ${sanctionDoc.data()}""";
      print(prompt);
      await messagesRef.add({
        'role': 'user',
        'timeCreated': FieldValue.serverTimestamp(),
        'content': prompt
      });
    }
    await postMessages(messagesRef, searchResDoc.reference);
  }

  Future<void> postMessages(CR messagesRef, DR searchResDocRef) async {
    final headers = await prepareOpenAIHeaders();

    final messagesCol = await messagesRef.orderBy('timeCreated').get();

    final messages = messagesCol.docs.map((e) {
      final data = e.data();
      data.remove('timeCreated');
      // if (data['timeCreated'] is Timestamp) {
      //   // Convert Timestamp to Unix milliseconds (int).
      //   data['timeCreated'] = data['timeCreated'].millisecondsSinceEpoch;
      // }

      return data;
    }).toList();

    print('messages: ${messages}');

    final res =
        await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: headers,
            body: jsonEncode({
              "model": "gpt-3.5-turbo-0613",
              //"gpt-3.5-turbo",
              "messages": messages,
              // [
              //   {
              //     "role": "user",
              //     "content":
              //         "Say this is a test!"
              //   }
              // ],
              "max_tokens": 500,
              "temperature": 0.6
            }));

    if (res.statusCode != 200) {
      // save error
      print(res.body);
      searchResDocRef.update({'error': res.body});
      return;
    } else {
      dynamic message = null;

      final response = json.decode(res.body);
      if (response != null &&
          response.containsKey('choices') &&
          response['choices'].length > 0 &&
          response['choices'][0].containsKey('message')) {
        message = response['choices'][0]['message'];
        // Perform further actions using 'text' variable
      } else {
        print('no answer from assistant');
        return;
      }

      print('message is: ${message}');

      String messageText = message['content'];

      messagesRef.add({
        'role': 'assistant',
        'timeCreated': FieldValue.serverTimestamp(),
        'content': messageText,
        // 'prompt': prompt
      });
    }
  }
}

class SendMessageWidget extends ConsumerWidget {
  FocusNode focusNode = FocusNode();
  final CR messageColRef;
  final SNP draftMessageSNP = snp('');
  final Function(String msg)? onMessageSent;
  final Widget? extension;
  final TextEditingController ctrl = TextEditingController();

  SendMessageWidget(this.messageColRef, this.onMessageSent,
      {this.extension, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => RawKeyboardListener(
      focusNode: focusNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
            event.isMetaPressed) {
          sendMessage(ref);
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
                child: SnpTextEdit2(draftMessageSNP,
                    ctrl: ctrl,
                    maxLines: 10,
                    canAddLines: true,
                    decoration: InputDecoration(hintText: 'Type a message')),

                //   DocFieldTextField(
                // docRef,
                // 'draft',
                // decoration: InputDecoration(hintText: 'Type a message'),
                //)
              ),
              IconButton(
                  onPressed: ref.watch(draftMessageSNP) == null ||
                          ref.watch(draftMessageSNP).trim().length == 0
                      ? null
                      : () => sendMessage(ref),
                  icon: Icon(Icons.send))
            ]),
      ));

  void sendMessage(WidgetRef ref) async {
    if (ref.read(draftMessageSNP.notifier).value == null ||
        ref.read(draftMessageSNP.notifier).value.trim().length == 0) return;

    final messageDocRef = await messageColRef.add({
      'content': ref.read(draftMessageSNP.notifier).value,
      'timeCreated': FieldValue.serverTimestamp(),
      'role': 'user'
    });
    if (onMessageSent != null)
      onMessageSent!(ref.read(draftMessageSNP.notifier).value);
    ctrl.clear();
  }
}

class MessageWidget extends ConsumerWidget {
  final DR messageDocRef;
  // final Function(String code)? useCode;
  final Widget? extension;

  MessageWidget(this.messageDocRef, {this.extension, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => DocStreamWidget(
      key: ValueKey(messageDocRef.id),
      docSP(messageDocRef.path),
      (context, messageDoc) =>
          // ConstrainedBox(
          //     constraints: BoxConstraints(maxHeight: 800),
          //     child:
          Card(
              child: ListTile(
            trailing: IconButton(
                onPressed: () => messageDocRef.delete(),
                icon: Icon(Icons.delete)),
            leading: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(formatDateTime(messageDoc.data()?['timeCreated']),
                //     style: Theme.of(context).textTheme.labelSmall),
                Text(messageDoc.data()?['role'] ?? ''),
                CopyToClipboardWidget(
                    text: messageDoc.data()?['content'] ?? '',
                    child: Icon(Icons.copy))
              ],
            ),
            title:
                // ConstrainedBox(
                //     constraints: BoxConstraints(maxHeight: 500),
                //     child:
                Container(
                    width: 200,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 50),
                        child: Text(messageDoc.data()?['content'] ?? ''))),
          )));
}
