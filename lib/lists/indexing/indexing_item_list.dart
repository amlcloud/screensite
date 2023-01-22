import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firestore.dart';

class IndexingItemList extends ConsumerWidget {
  final String _entityId;
  final Map<String, dynamic> _item;

  const IndexingItemList(this._entityId, this._item);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        children: ref.watch(colSP('list/$_entityId/indexConfigs/')).when(
            loading: () => [Container()],
            error: (e, s) => [ErrorWidget(e)],
            data: (data) {
              List<Widget> configs = [];
              if (data.docs.isNotEmpty) {
                configs.add(Divider());
                configs.add(Text('Indices'));
                configs.addAll(data.docs.map((config) {
                  List<Widget> indices = [];
                  indices.add(SizedBox(
                      width: double.infinity,
                      child: Text('Type: ${config.data()['type']}')));
                  indices.addAll(ref
                      .watch(filteredColSP(QueryParams(
                          'list/$_entityId/indexConfigs/${config.id}/entityIndexFields/',
                          orderBy: 'createdTimestamp')))
                      .when(
                          loading: () => [Container()],
                          error: (e, s) => [ErrorWidget(e)],
                          data: (data) {
                            return [
                              SizedBox(
                                  width: double.infinity,
                                  child: Text('Index by: ${data.docs.map((f) {
                                    return f.data()['value'];
                                  }).join(' ')}')),
                              SizedBox(
                                  width: double.infinity,
                                  child:
                                      Text('Actual values: ${data.docs.map((f) {
                                    return _item[f.data()['value']];
                                  }).join(' ')}'))
                            ];
                          }));
                  return Column(children: [
                    Divider(),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: indices))
                  ]);
                }).toList());
              }
              return configs;
            }));
  }
}
