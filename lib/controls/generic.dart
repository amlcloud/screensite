
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenericStateNotifier<V> extends StateNotifier<V> {
  GenericStateNotifier(V d) : super(d);

  set value(V v) {
    state = v;
  }

  V get value => state;
}

typedef SNP<T> = StateNotifierProvider<GenericStateNotifier<T>, T>;
typedef GSN<T> = GenericStateNotifier<T>;
typedef MAP = Map<String, dynamic>;

SNP<T> snp<T>(T value) {
  return SNP<T>((ref) => GSN<T>(value));
}