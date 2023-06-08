import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets/doc_field_text.dart';

import 'chat_widget.dart';

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
