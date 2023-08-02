import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/search/search_details.dart';
import 'package:screensite/search/search_page.dart';

class MatchesWidget extends ConsumerWidget {
  const MatchesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Matches",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                )),
            ref.watch(selectedSearchId) ==
                    null
                ? Container(
                    height: double.maxFinite,
                  )
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: SearchDetails(
                          FirebaseFirestore
                              .instance
                              .doc(
                            'search/${ref.watch(selectedSearchId)}',
                          ),
                          selectedRef),
                    )),
          ],
        ),
      ),
    ));
  }
}