import 'indexing_exports.dart';
import 'package:flutter/foundation.dart';

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
                                    if (_item[f.data()['value']] != null) {
                                      if (type == 'Array of objects') {
                                        final objects =
                                            _item[f.data()['value']];
                                        final filtered = objects.map((obj) =>
                                            obj[nameFieldValue.text] != null
                                                ? obj[nameFieldValue.text]
                                                    .toString()
                                                : obj[nameFieldValue.text] =
                                                    '');
                                        List<String> nonEmptyValues = [];
                                        for (var value in filtered) {
                                          if (value.isNotEmpty) {
                                            nonEmptyValues.add(value);
                                          }
                                        }
                                        return nonEmptyValues;
                                      } else {
                                        return _item[f.data()['value']];
                                      }
                                    } else {
                                      return '';
                                    }
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
                                    } else if (type == 'Array of objects') {
                                      for (int i = 0;
                                          i < config.docs.length;
                                          i++) {
                                        String key =
                                            config.docs[i].data()['value'];
                                        if (_item.containsKey(key)) {
                                          for (int j = 0;
                                              j < _item[key].length;
                                              j++) {
                                            subset.add(_item[key][j]
                                                [nameFieldValue.text]);
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
                                              final removedCharactersSubset =
                                                  subset
                                                      .map((value) => value
                                                          .toString()
                                                          .replaceAll(
                                                              RegExp(
                                                                  r'[^a-z0-9]'),
                                                              ''))
                                                      .toSet();
                                              final removedCharactersSet = data
                                                  .docs
                                                  .map((f) => f
                                                      .data()['target']
                                                      .toString()
                                                      .replaceAll(
                                                          RegExp(r'[^a-z0-9]'),
                                                          ''))
                                                  .toSet();

                                              final setIntersection =
                                                  removedCharactersSubset
                                                      .intersection(
                                                          removedCharactersSet);
                                              final setEqualsResult = setEquals(
                                                  setIntersection,
                                                  removedCharactersSubset);
                                              if (setEqualsResult &&
                                                  setIntersection
                                                      .elementAt(0)
                                                      .isNotEmpty) {
                                                return Icon(Icons.check,
                                                    color: Colors.green);
                                              } else {
                                                return Icon(Icons.close,
                                                    color: Colors.red);
                                              }
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
