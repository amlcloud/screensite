import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesWidget extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(child: Text("Matches Widget"));
  }
}