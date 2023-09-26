import 'cases_exports.dart';

class ChatMessageWidget extends ConsumerWidget {
  final DR messageDocRef;
  final Function(String code)? useCode;
  final Widget? extension;

  ChatMessageWidget(this.messageDocRef, this.useCode,
      {this.extension, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => DocStreamWidget(
      key: ValueKey(messageDocRef.id),
      docSP(messageDocRef.path),
      (context, messageDoc) => ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 800),
          child: Card(
              child: ListTile(
                  trailing: IconButton(
                      onPressed: () => messageDocRef.delete(),
                      icon: Icon(Icons.delete)),
                  leading: Column(
                    children: [
                      // Text(
                      //     formatDateTime(messageDoc.data()?['timeCreated']),
                      //     style: Theme.of(context).textTheme.labelSmall),
                      // Text(messageDoc.data()?['role'] ?? ''),
                      CopyToClipboardWidget(
                          text: messageDoc.data()?['content'] ?? '',
                          child: Icon(Icons.copy))
                    ],
                  ),
                  title: ConstrainedBox(
                    constraints: BoxConstraints(
                        // maxHeight: 200
                        ),
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                    Text(messageDoc.data()?['content'] ?? '')),
                            Flexible(
                                child: Column(
                              children: [
                                Text(messageDoc.data()?['error'] ?? '',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            )),
                          ],
                        ),
                        if (extension != null) extension!
                      ],
                    )),
                  )))));
}
