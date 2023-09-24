import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'cases_exports.dart';

class ChatWidget extends ConsumerWidget {
  FocusNode focusNode = FocusNode();
  final DR docRef;
  final SNP draftMessageSNP = snp('');
  final TextEditingController ctrl = TextEditingController();
  final Function(String code)? useCode;
  final Widget Function(DS messageDoc)? extensionBuilder;

  ChatWidget(this.docRef, {Key? key, this.useCode, this.extensionBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // FutureBuilder<Response>(
          //   future:
          //       http.post(Uri.parse('https://api.openai.com/v1/completions'),
          //           headers: headers,
          //           body: jsonEncode({
          //             "model": 'text-davinci-003',
          //             "prompt": "What day is today?",
          //             "max_tokens": 9,
          //             "temperature": 0.6
          //           })),
          //   builder: (BuildContext context, AsyncSnapshot<Response?> res) {
          //     if (res.hasData) {
          //       return Text(res.data!.body);
          //     } else {
          //       print(res.error);
          //       // Display a loading indicator while waiting for the forecast
          //       return const CircularProgressIndicator();
          //     }
          //   },
          // ),

          // Expanded(flex: 20, child: DocFieldText(docRef, 'content')),

          // BUILD MESSAGES RENDER
          //Expanded(child: buildMessages()),
          Container(
              // color: Colors.purple,
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildSendMessage(context, ref),
          ))
          // Expanded(child: Container(color: Colors.red)),
          // Flexible(child: Container(color: Colors.blue)),
        ],
      );

  Widget? buildContext(WidgetRef ref) => Padding(
      padding: padding8,
      child: colWatch(
          colSP(docRef.collection('message').path),
          ref,
          (col) => col.size == 0
              ? DocFieldTextField(
                  docRef,
                  'context',
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(hintText: 'Context'),
                  canAddLines: true,
                )
              : null));

// BUILD MESSAGES WIDGET
  // Widget buildMessages() => Container(
  //         // color: Colors.green,
  //         child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: SingleChildScrollView(
  //           child: ColStreamWidget<Widget>(
  //               colSPfiltered(docRef.collection('input').path,
  //                   orderBy: 'timeCreated', isOrderDesc: false, limit: 50),
  //               (context, col, items) => Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: items),
  //               (context, messageDoc) => ChatMessageWidget(
  //                   key: ValueKey(messageDoc.id),
  //                   messageDoc.reference,
  //                   useCode,
  //                   extension: extensionBuilder != null
  //                       ? extensionBuilder!(messageDoc)
  //                       : null))),
  //     ));

  Widget buildSendMessage(BuildContext context, WidgetRef ref) {
    // Widget? chatContextWidget = buildContext(ref);
    return Container(
        // color: Colors.amber,
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // if (chatContextWidget != null) chatContextWidget,
        // submit on enter + ctrl
        RawKeyboardListener(
            focusNode: focusNode,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
                  event.isMetaPressed) {
                sendMessage(context, ref);
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
                      child: () {
                        docRef.collection('input');
                        DocumentReference<Map<String, dynamic>> inputDocRef =
                            docRef
                                .collection('input')
                                .doc('input-${docRef.id}');
                        return DocFieldTextField(inputDocRef, "text");
                      }(),
                      // child: SnpTextEdit2(
                      //   draftMessageSNP,
                      //   ctrl: ctrl,
                      //   maxLines: 10,
                      //   canAddLines: true,
                      //   decoration: InputDecoration(hintText: 'Type a message'),
                      //   onChanged: (text) {
                      //     print(text);
                      //     sendMessage(context, ref);
                      //   },
                      //),

                      //   DocFieldTextField(
                      // docRef,

                      // 'draft',
                      // decoration: InputDecoration(hintText: 'Type a message'),
                      //)
                    ),

                    // SEND BUTTON CODE

                    // IconButton(
                    //     onPressed: ref.watch(draftMessageSNP) == null ||
                    //             ref.watch(draftMessageSNP).trim().length == 0
                    //         ? null
                    //         : () => sendMessage(context, ref),
                    //     icon: Icon(Icons.send))
                  ]),
            ))
      ],
    ));
  }

  // THIS FUNCTION WAS REPLACED BY DocFieldTextField.
  void sendMessage(BuildContext context, WidgetRef ref) async {
    // String? inputText = ref.read(draftMessageSNP.notifier).value;

    // // if null or empty
    // if (inputText == null || inputText.trim().isEmpty) return;

    // // Create input collection
    // docRef.collection('input');

    // // Create Document Reference
    // // Confirm docID
    // DocumentReference inputDocRef =
    //     docRef.collection('input').doc('input-${docRef.id}');
    // DocumentSnapshot inputSnapshot = await inputDocRef.get();

    // // If document exists
    // if (inputSnapshot.exists && inputSnapshot.data() != null) {
    //   await inputDocRef.update({
    //     'text': ref.read(draftMessageSNP.notifier).value,
    //     'timeUpdated': FieldValue.serverTimestamp(),
    //   });
    // } else {
    //   await inputDocRef.set({
    //     'text': ref.read(draftMessageSNP.notifier).value,
    //     'timeUpdated': FieldValue.serverTimestamp(),
    //   });
    // }
  }
// Messages collection code
  // final messages = await docRef.collection('message').get();
  // if (messages.size == 0) {
  //   final doc = await docRef.get();
  //   await docRef.collection('message').add({
  //     'content': doc.get('context'),
  //     // "The following is a conversation with code generator named assistant. Assistant should provide python code by user request to be executed by the user using python exec(). User will exectue the code and provide the log to assistant. The code should print execution log in the console using print. The file system is read-only, no files can be created, modified or deleted."
  //     'timeCreated': FieldValue.serverTimestamp(),
  //     'role': 'system'
  //   });
  // }
  // final messageDocRef = await docRef.collection('message').add({
  //   'content': ref.read(draftMessageSNP.notifier).value,
  //   'timeCreated': FieldValue.serverTimestamp(),
  //   'role': 'user'
  // });
  //ctrl.clear();

// OPEN AI CALL - Moved to Backend
  //     final promptPrefix = """
  //       Based on the text provided below, return JSON with the following fields:
  //       {
  //         "name": "The full name of the person",
  //         "data_of_birth": "The date of birth of the person".,
  //         "place_of_birth": "The place of birth of the person.",
  //         "info": "Any additional information about the person."
  //       }
  //         Return JSON text only, no additional comments.
  //          Text:
  //            """;
  //final headers = await prepareOpenAIHeaders();
  //await docRef.set({'error': FieldValue.delete()}, SetOptions(merge: true));
  // final res =
  //     await http.post(Uri.parse('https://api.openai.com/v1/completions'),
  //         headers: headers,
  //         body: jsonEncode({
  //           "model": 'text-davinci-003',
  //           "prompt": promptPrefix + messagesText,
  //           "max_tokens": 200,
  //           "temperature": 0.6
  //         }));
  // if (res.statusCode != 200) {
  //   // save error
  //   print(res.body);
  //   docRef.update({'error': res.body});
  //   return;
  // } else {
  //   print(res.body);
  //   final bodyJson = jsonDecode(res.body);
  //   var text = bodyJson['choices'][0]['text'];
  //   // // remove first line of the text if it doesn't have open curly bracket in it (JSON format)
  //   // if (!text.startsWith('{')) {
  //   //   text = text.split('\n').sublist(1).join('\n');
  //   // }
  //   // extract substring representing JSON content from the text
  //   final jsonStartIndex = text.indexOf('{');
  //   final jsonEndIndex = text.lastIndexOf('}');
  //   text = text.substring(jsonStartIndex, jsonEndIndex + 1);
  //   print('JSON: $text');

// CREATE SEARCH ON INPUT CHANGE - Moved to Backend
  // try {
  //   final jsonContent = jsonDecode(text);
  //   await docRef.update({
  //     'content': jsonContent,
  //   });
  //   if (jsonContent["name"] != null) {
  //     final searchDoc =
  //         await docRef.collection('search').doc(jsonContent["name"]).get();
  //     if (searchDoc.exists) return;
  //     await docRef.collection('search').doc(jsonContent["name"]).set({
  //       'target': jsonContent["name"],
  //       'timeCreated': FieldValue.serverTimestamp(),
  //       'author': FirebaseAuth.instance.currentUser!.uid,
  //     });
  //     await docRef.update({'target': jsonContent["name"]});
  //   }
  // } catch (e) {
  //   await docRef.update({'error': e.toString() + '\n' + text});
  // }
}

// docRef.collection('run').add({
//   'content': ref.read(draftMessageSNP.notifier).value,
//   'timeCreated': FieldValue.serverTimestamp(),
//   'user': 'user'
// });
//}

// class SnpTextEdit2 extends ConsumerWidget {
//   TextEditingController? _ctrl;
//   final SNP dataSNP;
//   final InputDecoration? decoration;
//   final bool debugPrint;
//   final bool showSaveStatus;
//   final int saveDelay;
//   final bool enabled;
//   final int? maxLines;
//   final int? minLines;
//   final bool canAddLines;
//   final Function(String)? onChanged;

//   SnpTextEdit2(this.dataSNP,
//       {TextEditingController? ctrl,
//       this.decoration,
//       this.saveDelay = 1000,
//       this.showSaveStatus = true,
//       this.debugPrint = false,
//       this.enabled = true,
//       this.maxLines = 1,
//       this.minLines,
//       this.onChanged = null,
//       this.canAddLines = false,
//       Key? key})
//       : _ctrl = ctrl,
//         super(key: key) {
//     if (this._ctrl == null) this._ctrl = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => TextField(
//         // this.controller,
//         controller: _ctrl,
//         // this.focusNode,
//         // this.undoController,
//         // this.decoration = const InputDecoration(),
//         decoration: decoration,
//         // this.textInputAction,
//         // this.textCapitalization = TextCapitalization.none,
//         // this.style,
//         // this.strutStyle,
//         // this.textAlign = TextAlign.start,
//         // this.textAlignVertical,
//         // this.textDirection,
//         // this.readOnly = false,
//         enabled: enabled,
//         maxLines: maxLines,
//         minLines: !canAddLines
//             ? minLines
//             : ref.watch(dataSNP) == null
//                 ? 1
//                 : (ref.watch(dataSNP).split('\n').length + 1 > maxLines
//                     ? maxLines
//                     : ref.watch(dataSNP).split('\n').length + 1),
//         onChanged: (v) {
//           // ref.read(status.notifier).value = 'changed';
//           // if (descSaveTimer != null && descSaveTimer!.isActive) {
//           //   descSaveTimer!.cancel();
//           // }
//           // descSaveTimer = Timer(
//           //     Duration(milliseconds: widget.saveDelay), () => saveValue(v));
//           // if (widget.onChanged != null) widget.onChanged!(v);

//           // OnChanged Callback to OnChanged in SnpTextEdit2
//           if (onChanged != null) {
//             onChanged!(v);
//           }
//           saveValue(ref, v);
//         },
//         // onSubmitted: (v) {
//         //   // if (descSaveTimer != null && descSaveTimer!.isActive) {
//         //   //   descSaveTimer!.cancel();
//         //   // }
//         //   saveValue(ref, v);
//         // }
//       );

//   void saveValue(WidgetRef ref, String s) async {
//     ref.read(dataSNP.notifier).value = s;
//   }
// }

final padding8 = EdgeInsets.all(8);
