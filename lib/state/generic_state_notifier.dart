import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenericStateNotifier<V> extends StateNotifier<V> {
  GenericStateNotifier(V d) : super(d);

  set value(V v) {
    state = v;
  }

  V get value => state;
}



