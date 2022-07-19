import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

class Day extends ConsumerWidget {
  final Jiffy day;
  const Day(this.day);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Text(
        day.format('dd'),
        style: TextStyle(fontSize: 8),
      );
}
