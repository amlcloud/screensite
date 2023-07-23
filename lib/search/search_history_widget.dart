import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/search/search_list.dart';
import 'package:screensite/search/search_page.dart';


class SearchHistoryWidget extends ConsumerWidget {
  const SearchHistoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 40.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Search History",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            SearchHistory(selectedRef),
          ],
        ),
      ),
    );
  }
}