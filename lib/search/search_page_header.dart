import 'package:flutter/material.dart';

class SearchPageHeader extends StatelessWidget {
  const SearchPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 12.0),
          child: Text(
            "Sanction Search",
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 12.0),
          child: Text(
            "Enter known information on an individual or entity to find the closest match and review their information.",
            style:
                Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}