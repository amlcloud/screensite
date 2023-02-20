import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

import '../providers/firestore.dart';
import '../state/generic_state_notifier.dart';

class ListDetailsWidget extends ConsumerWidget {
  const ListDetailsWidget({
    Key? key,
    required this.indexButtonClicked,
    required this.indexStatus,
    required this.entityId,
  }) : super(key: key);

  final AlwaysAliveProviderBase<GenericStateNotifier<bool>> indexButtonClicked;
  final QuerySnapshot<Map<String, dynamic>> indexStatus;
  final String entityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityDoc = ref.watch(docSP('list/$entityId'));
    return entityDoc.when(
      loading: () => Container(),
      error: (e, s) => ErrorWidget(e),
      data: (entityData) {
        final uiName = entityData.data()!['uiName'];
        final name = entityData.data()!['name'];
        final listName = uiName ?? name ?? 'undefined list name';
        final lastUpdateTime = entityData.data()!['lastUpdateTime'];
        final lastUpdatedOn = Jiffy(
          lastUpdateTime == null ? Text('N/A') : lastUpdateTime.toDate(),
        ).format('MMM d, y');
        final lastChangedOn = Jiffy(
          lastUpdateTime == null ? Text('N/A') : lastUpdateTime.toDate(),
        ).format('MMM d, y');
        final isIndexing = indexStatus.docs.isNotEmpty &&
            indexStatus.docs.first['indexing'] == true;
        final isButtonDisabled =
            ref.watch(indexButtonClicked).value || isIndexing;
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: Text(listName)),
            Flexible(child: Text('Last updated on $lastUpdatedOn')),
            Flexible(child: Text('Last changed on $lastChangedOn')),
            Flexible(
              child: ElevatedButton(
                onPressed: isButtonDisabled
                    ? null
                    : () {
                        ref.read(indexButtonClicked).value = true;
                        HttpsCallable callable = FirebaseFunctions.instance
                            .httpsCallable('index_list2?list=$entityId');
                        callable().then((_) {
                          ref.read(indexButtonClicked).value = false;
                        });
                      },
                child: Text('Reindex'),
              ),
            ),
          ],
        );
      },
    );
  }
}

// class ListDetailsWidget extends StatelessWidget {
//   const ListDetailsWidget({
//     super.key,
//     required AlwaysAliveProviderBase<GenericStateNotifier<bool>>
//         indexButtonClicked,
//     required QuerySnapshot<Map<String, dynamic>> indexStatus,
//     required this.entityId,
//   })  : _indexButtonClicked = indexButtonClicked,
//         _indexStatus = indexStatus;

//   final AlwaysAliveProviderBase<GenericStateNotifier<bool>> _indexButtonClicked;
//   final QuerySnapshot<Map<String, dynamic>> _indexStatus;
//   final String entityId;

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(docSP('list/${entityId}')).when(
//         loading: () => Container(),
//         error: (e, s) => ErrorWidget(e),
//         data: (entityDoc) => Row(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Flexible(
//                       child: Text(
//                     (entityDoc.data()!['uiName'] != null)
//                         ? entityDoc.data()!['uiName']
//                         : (entityDoc.data()!['name'] != null)
//                             ? entityDoc.data()!['name']
//                             : 'undefined list name',
//                   )),
//                   Flexible(
//                       child: Text('Last updated on ' +
//                           Jiffy(entityDoc.data()!['lastUpdateTime'] == null
//                                   ? Text('N/A')
//                                   : entityDoc
//                                       .data()!['lastUpdateTime']
//                                       .toDate())
//                               .format('MMM d, y'))),
//                   Flexible(
//                       child: Text('Last changed on ' +
//                           Jiffy(entityDoc.data()!['lastUpdateTime'] == null
//                                   ? Text('N/A')
//                                   : entityDoc
//                                       .data()!['lastUpdateTime']
//                                       .toDate())
//                               .format('MMM d, y'))),
//                   Flexible(
//                       child: ElevatedButton(
//                     onPressed: ref.watch(_indexButtonClicked).value ||
//                             (_indexStatus.docs.isNotEmpty &&
//                                 _indexStatus.docs.first['indexing'] == true)
//                         ? null
//                         : () {
//                             ref.read(_indexButtonClicked).value = true;
//                             HttpsCallable callable = FirebaseFunctions.instance
//                                 .httpsCallable('index_list2?list=$entityId');
//                             callable().then((_) {
//                               ref.read(_indexButtonClicked).value = false;
//                             });
//                           },
//                     child: Text('Reindex'),
//                   )

//                       // ElevatedButton(
//                       //     onPressed:  () {
//                       //       if (ref.read(_indexButtonClicked).value ==
//                       //               false &&
//                       //           (_indexStatus.docs.isEmpty ||
//                       //               _indexStatus.docs.first['indexing'] ==
//                       //                   false)) {
//                       //         ref.read(_indexButtonClicked).value = true;
//                       //         HttpsCallable callable =
//                       //             FirebaseFunctions.instance.httpsCallable(
//                       //                 'index_list2?list=$entityId');
//                       //         callable();
//                       //       }
//                       //     },
//                       //     child: Text('Reindex')),
//                       ),
//                 ]));
//   }
// }
