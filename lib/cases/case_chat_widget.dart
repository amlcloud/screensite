import 'chat_widget.dart';
import 'cases_exports.dart';

class CaseChatWidget extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();

  final DR caseRef;
  CaseChatWidget(this.caseRef);

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Card(child: ChatWidget(caseRef))),

          DocFieldText(caseRef, 'error', style: TextStyle(color: Colors.red))
        ]);
  }
}
