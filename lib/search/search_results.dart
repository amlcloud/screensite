import 'search_exports.dart';

class SearchResults extends ConsumerWidget {
  final DocumentSnapshot searchDoc;
  final StateNotifierProvider<GenericStateNotifier<DocumentReference?>,
      DocumentReference?> _selectedItemNotifier;

  SearchResults(this.searchDoc, this._selectedItemNotifier);

  //Sort List of results
  //Parameter: unsorted list and fieldname to sort
  List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedMapbyFieldName(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList,
      String fieldName) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDataList = dataList
        .toList()
      ..sort((a, b) => a.data()[fieldName].compareTo(b.data()[fieldName]));
    return sortedDataList;
  }

  // function to calculate progress bar color based on value
  Color calculateBackgroundColor({required double value}) {
    if (value > 0.90) {
      return Colors.red;
    } else if (value > 0.50) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
      children: ref
          .watch(
            colSP(
                'user/${FirebaseAuth.instance.currentUser!.uid}/search/${searchDoc.id}/res'),
          )
          .when(
            loading: () => [],
            error: (e, s) => [ErrorWidget(e)],
            data: (results) {
              if (results.docs.isEmpty) {
                return [
                  Center(
                    child: Text(
                        "Nothing was found to match ${searchDoc['target']}"),
                  ),
                ];
              }
              return sortedMapbyFieldName(results.docs, 'levScore').map((res) {
                num maxLengthOfString = max(
                    res.data()['target'].length, searchDoc['target'].length);
                num matchScore =
                    (1 - res.data()['levScore'] / maxLengthOfString) *
                        100; // Formula to calculate match score from lev score
                return GestureDetector(
                    onTap: () {
                      ref.read(_selectedItemNotifier.notifier).value =
                          res.data()['ref'];
                      ref.read(selectedSearchResultId.notifier).value = res.id;
                    },
                    child: ListTile(
                      tileColor: Theme.of(context).listTileTheme.tileColor,
                      subtitle:
                          DocFieldText(res.data()['ref'].parent.parent, 'name'),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${matchScore.toStringAsFixed(0)}%",
                              style: Theme.of(context).textTheme.titleMedium),
                          // Remove Row and add Text(matchScore) directly to trailing for old version
                          // Spacing
                          SizedBox(
                            width: 9,
                          ),
                          // Linear Percentage Indicator- ??
                          SizedBox(
                            width: 80,
                            height: 5,
                            child: LinearProgressIndicator(
                              color: calculateBackgroundColor(
                                  value: matchScore.toDouble() / 100),
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              value: matchScore.toDouble() / 100,
                              semanticsValue:
                                  '${matchScore.toStringAsFixed(0)} %',
                            ),
                          ),

                          //     style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),

                      // Plain percentage
                      //Text("${matchScore.toStringAsFixed(0)} %",
                      //     style: Theme.of(context).textTheme.titleLarge),
                      selectedColor:
                          Theme.of(context).colorScheme.inverseSurface,
                      title: Text(
                        res.data()['target'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ));
              }).toList();
            },
          ));
}
