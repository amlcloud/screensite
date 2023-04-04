import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:providers/firestore.dart';
import '../../state/generic_state_notifier.dart';

class IndexingItemList extends ConsumerWidget {
  final String _entityId;
  final Map<String, dynamic> _item;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>
      activeList;

  const IndexingItemList(this._entityId, this._item, this.activeList);

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
                  String type = config.data()['type'];
                  List<Widget> indices = [];
                  indices.add(SizedBox(
                      width: double.infinity,
                      child: Text('Type: ${config.data()['type']}')));
                  indices.addAll(ref
                      .watch(colSPfiltered(
                          'list/$_entityId/indexConfigs/${config.id}/entityIndexFields/',
                          orderBy: 'createdTimestamp'))
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
                        child: Row(children: [
                          Expanded(child: Column(children: indices)),
                          ref
                              .watch(colSPfiltered(
                                  'list/$_entityId/indexConfigs/${config.id}/entityIndexFields/',
                                  orderBy: 'createdTimestamp'))
                              .when(
                                  loading: () => Container(),
                                  error: (e, s) => ErrorWidget(e),
                                  data: (config) {
                                    Set<String> subset = {};
                                    if (type == 'Single field' ||
                                        type == 'Multiple fields') {
                                      subset.add(config.docs.map((f) {
                                        return _item[f.data()['value']];
                                      }).join(' '));
                                    } else if (type == 'Array of values') {
                                      for (int i = 0;
                                          i < config.docs.length;
                                          i++) {
                                        String key =
                                            config.docs[i].data()['value'];
                                        if (_item.containsKey(key)) {
                                          for (int j = 0;
                                              j < _item[key].length;
                                              j++) {
                                            subset.add(_item[key][j]);
                                          }
                                        }
                                      }
                                    }
                                    return ref
                                        .watch(
                                            colSPfiltered('index/', queries: [
                                          QueryParam('listId',
                                              {Symbol('isEqualTo'): _entityId}),
                                          QueryParam('type',
                                              {Symbol('isEqualTo'): type})
                                        ]))
                                        .when(
                                            loading: () => Container(),
                                            error: (e, s) => ErrorWidget(e),
                                            data: (data) {
                                              Set<String> set = {};
                                              set.addAll(data.docs.map((f) {
                                                return f.data()['target'];
                                              }));
                                              return setEquals(
                                                      subset.intersection(set),
                                                      subset)
                                                  ? Icon(Icons.check,
                                                      color: Colors.green)
                                                  : Icon(Icons.close,
                                                      color: Colors.red);
                                            });
                                  })
                        ]))
                  ]);
                }).toList());
              }
              return configs;
            }));
  }
}
