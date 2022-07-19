import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import 'package:jiffy/jiffy.dart';
import 'package:screensite/common.dart';

class GenerateTransactionsButton extends ConsumerWidget {
  final String entityId;
  const GenerateTransactionsButton(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
      onPressed: () {
        /// Generates multiple transactions of random amount and balance
        for (var i = 0; i < 10; i++) {
          FirebaseFirestore.instance
              .collection('entity/${entityId}/transaction')
              .add({
            'amount': math.Random().nextDouble() * 999 + 1,
            'balance':
                (math.Random().nextDouble() * 999 + 1).toStringAsFixed(2),
            'ben_name': "Beneficiary",
            'reference': "Example Transaction",
            'rem_name': "Remitter",
            't': Jiffy().add(days: -25).add(days: i).dateTime,
            'day': Jiffy().add(days: -25).add(days: i).format(DATE_FORMAT),
          });
        }
      },
      child: Text('Generate'));
}
