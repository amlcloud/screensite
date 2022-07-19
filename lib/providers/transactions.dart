import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screensite/common.dart';

class EntityFilter extends Equatable {
  final DateTime start, end;
  final String entity;

  const EntityFilter(
    this.start,
    this.end,
    this.entity,
  );

  @override
  List<Object?> get props =>
      [start.toIso8601String(), end.toIso8601String(), entity];
}

final AutoDisposeStreamProviderFamily<
        List<List<DocumentSnapshot<Map<String, dynamic>>>>, EntityFilter>
    entityTrnByDaysSP = StreamProvider.autoDispose.family<
        List<List<DocumentSnapshot<Map<String, dynamic>>>>,
        EntityFilter>((ref, filter) {
  List<Stream<QuerySnapshot<Map<String, dynamic>>>> qs = [];

  final days = generateDays(Jiffy(filter.start), Jiffy(filter.end));

  for (var day in days) {
    Query<Map<String, dynamic>> q = FirebaseFirestore.instance
        .collection("entity/${filter.entity}/transaction");

    q = q.where('day', isEqualTo: day.format('yyyy-MM-dd'));

    qs.add(q.snapshots());
  }

  return Rx.combineLatestList<QuerySnapshot<Map<String, dynamic>>>(qs)
      .map((event) => event.fold([], (v, el) => v + [el.docs]));
});

final AutoDisposeStreamProviderFamily<List<Map<String, dynamic>>, EntityFilter>
    entityTrnDailyTotalsSP = StreamProvider.autoDispose
        .family<List<Map<String, dynamic>>, EntityFilter>((ref, filter) {
  return ref.watch(entityTrnByDaysSP(filter)).when(
      loading: () => Stream.empty(),
      error: (e, s) => Stream.empty(),
      data: (d) {
        print(
            'day: ${d.map((day) => day.map((trn) => trn.data()!['amount']))}');
        return //d.map((da) => {'count': da.length}).toList();
            Stream.value(d.map((day) {
          var fold = day.fold<Map<String, dynamic>>(
              {'count': 0, 'amount': 0},
              (previousValue, element) => {
                    'count': previousValue['count'] + 1,
                    'amount': previousValue['amount'] + element.get('amount'),
                  });
          print('day: ${fold}');
          return fold;
        }).toList());
      });
});

// final AutoDisposeStreamProviderFamily<Map<String, dynamic>, DataFilter>
//     dayTimelineOneMonthCountsSP = StreamProvider.autoDispose
//         .family<Map<String, dynamic>, DataFilter>((ref, filter) {
//   // print('dayTimelineCountsStart2EndByFilterSP starts');
//   // print(' end: ${Jiffy(filter.start).endOf(Units.MONTH).format(DATE_FORMAT)}');

//   // print(
//   //     '${Jiffy(filter.start).endOf(Units.MONTH).diff(Jiffy(filter.start), Units.DAY).toInt()}');

//   final opv = ref.watch(orgProjVerProvider);

//   final days = List<Jiffy>.generate(
//       Jiffy(filter.start)
//           .endOf(Units.MONTH)
//           .diff(Jiffy(filter.start), Units.DAY)
//           .toInt(),
//       (int index) => Jiffy(filter.start).startOf(Units.DAY).add(days: index));

//   //print('dayTimelineCountsStart2EndByFilterSP: ${days}');

//   List<Stream<DocumentSnapshot<Map<String, dynamic>>>> qs = days
//       .map((day) => FF
//           .doc(
//               "org/${opv.org}/projects/${opv.proj}/versions/${opv.ver}/dayTimeline/${idFromFilter(filter)}/${day.format(DATE_FORMAT)}/stat")
//           .snapshots())
//       .toList();

//   // print(
//   //     'queries: ${qs.length}, from ${days.first.format(DATE_FORMAT)} to ${days.last.format(DATE_FORMAT)} with: ${"org/${opv.org}/projects/${opv.proj}/versions/${opv.ver}/dayTimeline/${idFromFilter(filter)}/${DATE_FORMAT}/stat"}');

//   Stream<List<DocumentSnapshot<Map<String, dynamic>>>> res = Rx.combineLatestList(qs);

//   return res.map((event) => event.fold(
//       {},
//       (prev, el) => {
//             ...prev,
//             ...(el.exists &&
//                     el.data() != null &&
//                     el.data()!['day'] != null &&
//                     el.data()!['totalCount'] != null
//                 ? {el.data()!['day']: el.data()!['totalCount']}
//                 : {})
//           }));
// });
