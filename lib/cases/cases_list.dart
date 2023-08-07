import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:screensite/cases/case_item.dart';
import 'package:widgets/col_stream_widget.dart';
import 'case_status.dart';

final sortStateNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class CasesList extends ConsumerWidget {
  const CasesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH
          ? buildMobile(context, ref)
          : buildDesktop(context, ref);

  Widget buildMobile(BuildContext context, WidgetRef ref) {
    return
        //  SingleChildScrollView(
        //     child:
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildAppsByStatus()
            //)
            );
  }

  Widget buildDesktop(BuildContext context, WidgetRef ref) => Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildAppsByStatus()
          .map((e) => Flexible(
                child: e,
              ))
          .toList());

  List<Widget> _buildAppsByStatus() {
    // kDB
    //     .collection('user/${kUSR!.uid}/case')
    //     .orderBy('timeCreated')
    //     .where('status', isEqualTo: 'draft')
    //     .get()
    //     .then((value) => print(value.docs.length));

    return [
      STATUS.draft,
      STATUS.investigating,
      STATUS.escalated,
    ]
        .map(
          (e) => ColStreamWidget<Widget>(
            colSPfiltered('user/${kUSR!.uid}/case',
                queries: [
                  QueryParam(
                    'status',
                    Map<Symbol, dynamic>.from(
                      {const Symbol('isEqualTo'): getStatusKey(e)},
                    ),
                  ),
                ],
                orderBy: 'timeCreated'),
            (context, data, items) => Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.name,
                            style: Theme.of(context).textTheme.headlineSmall),
                      )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: items)
                ],
              ),
            ),
            (context, data) => //Text('${data.id} }')
                CaseItem(key: Key(data.id), data.reference),
          ),
        )
        .toList();
  }
}
