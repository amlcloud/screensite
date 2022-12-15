// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../state/generic_state_notifier.dart';

// class IndexingForm extends ConsumerWidget {
//   final QueryDocumentSnapshot<Map<String, dynamic>> document;
//   final StateNotifierProvider<GenericStateNotifier<Map<String, bool>>,
//       Map<String, bool>> editings;

//   const IndexingForm(this.document, this.editings);

//   void editing(WidgetRef ref, bool editing) {
//     Map<String, bool> map = ref.read(editings);
//     map[document.id] = editing;
//     Map<String, bool> newMap = {};
//     map.forEach((key, value) => {newMap[key] = value});
//     ref.read(editings.notifier).value = newMap;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     throw UnimplementedError();
//   }
// }
