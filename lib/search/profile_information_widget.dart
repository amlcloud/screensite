import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/search/search_results_item.dart';
import 'package:screensite/search/search_page.dart';

class ProfileInformationWidget extends ConsumerWidget {
  const ProfileInformationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Card(
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
          Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Profile Information",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              )),
          Flexible(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.all(10),
                        child: ref.watch(
                                    selectedRef) ==
                                null
                            ? Container()
                            : SearchResultsItem(
                                ref.watch(
                                    selectedRef)!))
                  ],
                ),
              ))
        ])));
  }
}
