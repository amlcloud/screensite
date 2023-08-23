import 'indexing_exports.dart';

//Change by GPT
class IndexingStatus extends ConsumerWidget {
  final QuerySnapshot<Map<String, dynamic>> _indexStatus;

  const IndexingStatus(this._indexStatus);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget widget;
    EdgeInsets p = EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0);

    if (_indexStatus.docs.isNotEmpty) {
      if (_indexStatus.docs.first['indexing'] == true ||
          _indexStatus.docs.first['count'] !=
              _indexStatus.docs.first['total']) {
        widget = Container(padding: p, child: Text('Indexing...'));
      } else {
        widget = Container();
      }
    } else {
      widget = Container();
    }

    return widget;
  }
}

// Original
// class IndexingStatus extends ConsumerWidget {
//   final bool _clicked;
//   final QuerySnapshot<Map<String, dynamic>> _indexStatus;
//   final StateNotifierProvider<GenericStateNotifier<bool>, bool>
//       _indexButtonClicked;
//   final StateNotifierProvider<GenericStateNotifier<bool>, bool>
//       _afterIndexButtonClicked;

//   const IndexingStatus(this._clicked, this._indexStatus,
//       this._indexButtonClicked, this._afterIndexButtonClicked);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Widget widget;
//     EdgeInsets p = EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0);
//     if (_clicked) {
//       if (ref.read(_afterIndexButtonClicked.notifier).value == true &&
//           _indexStatus.docs.isNotEmpty &&
//           _indexStatus.docs.first['indexing'] == false &&
//           _indexStatus.docs.first['count'] ==
//               _indexStatus.docs.first['total']) {
//         widget = Container();
//         ref.read(_afterIndexButtonClicked.notifier).value = false;
//         Future.delayed(Duration.zero, () {
//           ref.read(_indexButtonClicked.notifier).value = false;
//         });
//       } else {
//         widget = Container(padding: p, child: Text('Indexing...'));
//         ref.read(_afterIndexButtonClicked.notifier).value = true;
//       }
//     } else {
//       if (_indexStatus.docs.isNotEmpty) {
//         if (_indexStatus.docs.first['indexing'] == true) {
//           widget = Container(padding: p, child: Text('Indexing...'));
//         } else if (_indexStatus.docs.first['count'] !=
//             _indexStatus.docs.first['total']) {
//           widget = Container(padding: p, child: Text('Indexing...'));
//         } else {
//           widget = Container();
//         }
//       } else {
//         widget = Container();
//       }
//     }
//     return widget;
//   }
// }
