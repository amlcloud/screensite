import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:screensite/common.dart';
import 'package:screensite/providers/transactions.dart';
import 'package:screensite/timeline/day.dart';

class Timeline extends ConsumerWidget {
  static Jiffy startDate = Jiffy().add(days: -25);
  static Jiffy endDate = Jiffy();
  final List<Jiffy> days = generateDays(startDate, endDate);
  final String entityId;
  Timeline(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
      height: 100,
      child: Stack(children: [
        ...buildGraph(ref),
        ...days
            .asMap()
            .entries
            .map((e) => Positioned(
                left: e.key * 12,
                width: 12,
                bottom: 0,
                height: 10,
                child: Day(e.value)))
            .toList()
      ]));

  List<Widget> buildGraph(WidgetRef ref) => ref
      .watch(entityTrnDailyTotalsSP(
          EntityFilter(startDate.dateTime, endDate.dateTime, entityId)))
      .when(
          loading: () => [Text('loading')],
          error: (e, s) => [Text(e.toString())],
          data: (dailyTotals) => days
              .asMap()
              .entries
              .map((e) => Positioned(
                  left: e.key * 12,
                  width: 12,
                  bottom: 10 + (dailyTotals[e.key]['amount'] as double) / 100,
                  height: 10,
                  child: Container(
                    height: 2,
                    width: 2,
                    color: Colors.grey,
                  )))
              .toList());
}
