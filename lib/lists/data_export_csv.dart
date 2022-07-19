import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/providers/firestore.dart';
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:universal_html/html.dart" as html;

class DataExportButton extends ConsumerWidget {
  final db = FirebaseFirestore.instance;
  final String entityId;
  final List<List<String>> exportList = [
    <String>["amount", "balance", "ben_name", "rem_name"]
  ];

  DataExportButton(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
      onPressed: () {
        generateCSV(exportList);
        Fluttertoast.showToast(msg: 'CSV exported');
      },
      child: Text('Export CSV'));
}

generateCSV(List<List<String>> list) async {
  String csv = ListToCsvConverter().convert(list).toString();
  String timestamp = DateTime.now().toString();

  final bytes = Utf8Encoder().convert(csv);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'file_$timestamp.csv';
  html.document.body!.children.add(anchor);
  anchor.click();
  html.Url.revokeObjectUrl(url);
}
