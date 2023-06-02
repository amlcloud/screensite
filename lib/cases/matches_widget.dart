import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/col_stream_widget.dart';
import 'package:widgets/doc_print.dart';
import 'package:widgets/doc_stream_widget.dart';
import 'package:http/http.dart' as http;

import 'openai.dart';

class MatchesWidget extends ConsumerWidget {
  final DR caseDocRef;
  final TextEditingController searchCtrl = TextEditingController();

  MatchesWidget(this.caseDocRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: Card(
            child: DocStreamWidget(
                docSP(caseDocRef.path),
                (context, caseDoc) => caseDoc.data()?['target'] == null
                    ? Text('No matches')
                    : DocStreamWidget(
                        docSP(caseDocRef
                            .collection('search')
                            .doc(caseDoc.data()?['target'])
                            .path),
                        (context, doc) => Column(
                              children: [
                                Text(doc.data()!['target']),
                                ColStreamWidget<Widget>(
                                    colSP(doc.reference.collection('res').path),
                                    (context, snapshot, items) =>
                                        Column(children: items),
                                    (context, doc) => DocStreamWidget(
                                        docSP((doc.data()!['ref']
                                                as DocumentReference)
                                            .path),
                                        (context, sanctionDoc) => Column(
                                              children: [
                                                DocPrintWidget(
                                                    sanctionDoc.reference),
                                                ElevatedButton(
                                                    onPressed: () =>
                                                        sendMessage(sanctionDoc,
                                                            caseDoc),
                                                    child: Text('Investigate')),
                                                ColStreamWidget<Widget>(
                                                    colSP(sanctionDoc.reference
                                                        .collection('messages')
                                                        .path),
                                                    (context, col, items) =>
                                                        Column(children: items),
                                                    (context, doc) =>
                                                        DocPrintWidget(
                                                            doc.reference))
                                              ],
                                            )))
                              ],
                            )))
            // ColStreamWidget<Widget>(
            //     colSP(docRef.collection('search').path),
            //     (context, snapshot, items) => Column(children: items),
            //     (context, doc) => Column(
            //           children: [
            //             Text(doc.data()!['target']),
            //             ColStreamWidget<Widget>(
            //                 colSP(doc.reference.collection('res').path),
            //                 (context, snapshot, items) =>
            //                     Column(children: items),
            //                 (context, doc) => DocStreamWidget(
            //                     docSP((doc.data()!['ref'] as DocumentReference)
            //                         .path),
            //                     (context, sanctionDoc) =>
            //                         DocPrintWidget(sanctionDoc.reference)))
            //           ],
            //         ))
            ));
  }

  void sendMessage(DS sanctionDoc, DS caseDoc) async {
    final headers = await prepareOpenAIHeaders();

    final messagesRef = sanctionDoc.reference.collection('messages');

    final messagesCol = await messagesRef.get();

    if (messagesCol.size == 0) {
      await messagesRef.add({
        'role': 'system',
        'timeCreated': FieldValue.serverTimestamp(),
        'content':
            'You are a sanctions investigator. You need to compare the information about the customer with the information in the sanction document and decide whether the customer is the same person as the person in the sanction document.'
      });
      await messagesRef.add({
        'role': 'user',
        'timeCreated': FieldValue.serverTimestamp(),
        'content':
            """Here is my customer information: ${caseDoc.data()?['target']}\n\nHere is the information in the sanction document: ${sanctionDoc.data()?['target']}"""
      });
    }

    final messages = messagesCol.docs.map((e) => e.data()).toList();

    final res =
        await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: headers,
            body: jsonEncode({
              "model": "gpt-3.5-turbo",
              "messages": messages,
              // [
              //   {
              //     "role": "user",
              //     "content":
              //         "Say this is a test!"
              //   }
              // ],
              "max_tokens": 200,
              "temperature": 0.6
            }));

    if (res.statusCode != 200) {
      // save error
      print(res.body);
      sanctionDoc.reference.update({'error': res.body});
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
