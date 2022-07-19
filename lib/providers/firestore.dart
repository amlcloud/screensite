import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/core.dart';

/// Query parameter for [WhereFilter] used in [filteredColSP]
///
/// Example:
///
/// ref.watch(filteredColSP(WhereFilter(
///     limit: 5,
///     path: 'path to collection',
///     queries: [
///   QueryParam(
///       'entity',
///       Map<Symbol, dynamic>.from(
///           {Symbol('isEqualTo'): caseDoc.get('entity')}))
///
/// Available values:
/// final dynamic isEqualTo;
/// final dynamic isNotEqualTo;
/// final dynamic isLessThan;
/// final dynamic isLessThanOrEqualTo;
/// final dynamic isGreaterThan;
/// final dynamic isGreaterThanOrEqualTo;
/// final dynamic arrayContains;
/// final List<dynamic>? arrayContainsAny;
/// final List<dynamic>? whereIn;
/// final List<dynamic>? whereNotIn;
class QueryParam extends Equatable {
  final dynamic field;
  final Map<Symbol, dynamic> params;

  const QueryParam(
    this.field,
    this.params,
  );

  @override
  List<Object?> get props => [
        field,
        ...params.entries
            .map((e) => e.key.toString() + ":" + e.value.toString())
            .toList()
      ];
}

/// Filter for collection when listening to [filteredColSP]
///
/// Example:
///
/// ref.watch(filteredColSP(WhereFilter(
///     limit: 5,
///     path: 'path to collection',
///     queries: [
///   QueryParam(
///       'entity',
///       Map<Symbol, dynamic>.from(
///           {Symbol('isEqualTo'): caseDoc.get('entity')}))
class QueryParams extends Equatable {
  const QueryParams(
      {this.path,
      this.queries,
      this.orderBy,
      this.isOrderDesc,
      this.limit,
      this.distinct});

  final dynamic path;
  final List<QueryParam>? queries;
  final String? orderBy;
  final bool? isOrderDesc;
  final int? limit;
  final bool Function(QuerySnapshot a, QuerySnapshot<Map<String, dynamic>> b)?
      distinct;

  @override
  List<Object?> get props => [
        path,
        ...(queries == null ? [] : queries!.map((qp) => qp..props).toList()),
        orderBy,
        limit
      ];
}

/// Riverpod Stream Provider that listens to a collection with specific query criteria
/// (see [QueryParams]) and [equals] function that is used by [Stream.distinct] to
/// filter out events with unrelated changes.
final AutoDisposeStreamProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        QueryParams> filteredColSP =
    StreamProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, QueryParams>(
            (ref, filter) {
  Query<Map<String, dynamic>> q =
      FirebaseFirestore.instance.collection(filter.path);

  if (filter.queries != null)
    filter.queries!.forEach((query) {
      q = Function.apply(q.where, [query.field], query.params);
    });

  if (filter.orderBy != null)
    q = q.orderBy(filter.orderBy!, descending: filter.isOrderDesc ?? false);

  if (filter.limit != null) q = q.limit(filter.limit!);

  return filter.distinct == null
      ? q.snapshots()
      : q.snapshots().distinct(filter.distinct);
});

/// Riverpod Provider listening to a Firestore document by the path specified
final AutoDisposeStreamProviderFamily<DocumentSnapshot<Map<String, dynamic>>,
        String> docSP =
    StreamProvider.autoDispose
        .family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.doc(path).snapshots();
});

/// DocParam is used only to pass parameters (path and equals function)
/// to distinct stream providers (docSPdistinct and colSPdistinct)
@immutable
class DocParam {
  final String path;
  final bool Function(DocumentSnapshot<Map<String, dynamic>>,
      DocumentSnapshot<Map<String, dynamic>>)? equals;

  const DocParam(this.path, this.equals);

  @override
  int get hashCode {
    //print('path: ${path}, hash: ${hashObjects([path])}');
    return hashObjects([path]);
  }

  @override
  bool operator ==(Object other) {
    // print(' ${path}==${(other as DocParam).path}');
    return path == (other as DocParam).path; // && equals == other.equals;
  }
}

/// Riverpod Provider listening to a Firestore document by the path specified
/// with distinct function if you need to filter our unnecessarry changes.
final AutoDisposeStreamProviderFamily<DocumentSnapshot<Map<String, dynamic>>,
        DocParam> docSPdistinct =
    StreamProvider.autoDispose
        .family<DocumentSnapshot<Map<String, dynamic>>, DocParam>((ref, param) {
  return FirebaseFirestore.instance
      .doc(param.path)
      .snapshots()
      .distinct(param.equals);
});

/// Riverpod Provider that fetches a document once, as a promise.
final AutoDisposeFutureProviderFamily<DocumentSnapshot<Map<String, dynamic>>,
        String> docFP =
    FutureProvider.autoDispose
        .family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.doc(path).get();
});

/// Riverpod Provider that fetches a collection once, as a promise.
///
/// WARNING: Use with care as it returns all the documents in the collection!
/// Only to be used on collections which size is known to be small.
final AutoDisposeFutureProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        String> colFP =
    FutureProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.collection(path).get();
});

/// Riverpod collection Stream Provider that listens to a collection
///
/// WARNING: Use with care as it returns all the documents in the collection
/// whenever any document in collection changes!
/// Only to be used on collections which size is known to be small
///
/// To work with large collections consider using [filteredColSP]
final AutoDisposeStreamProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        String> colSP =
    StreamProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.collection(path).limit(100).snapshots();
});
