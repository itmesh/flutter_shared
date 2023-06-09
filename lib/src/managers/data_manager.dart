import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class DataManager<T, P> {
  @protected
  final BehaviorSubject<Map<String, T>> _data = BehaviorSubject<Map<String, T>>.seeded(<String, T>{});

  DateTime? lastFetchingAll;

  Map<String, DateTime> lastFetchingForId = <String, DateTime>{};

  Stream<List<T>> get data$ => _data.stream.map((Map<String, T> data) => data.values.toList());

  Stream<Map<String, T>> get dataMap$ => _data.stream;

  Stream<List<T>> dataForIds$(List<String> ids) => _data.stream.map((Map<String, T> data) => data.values.toList());

  Stream<T?> dataForId$(String id) => _data.stream.map((Map<String, T> data) => data[id]);

  List<T> get lastKnownValues => _data.value.values.toList();

  List<T> lastKnownValuesForIds(List<String> ids) =>
      _data.value.keys.where((String id) => ids.contains(id)).map((String id) => _data.value[id]!).toList();

  T? lastKnownValueForId(String id) => _data.value[id];

  Future<bool> fetchData(
    P params, {
    bool forceFetching = true,
    bool showErrorToast = true,
  }) async {
    try {
      _data.add(await fetch(params));

      return true;
    } catch (e) {
      return false;
    }
  }

  /// deleteWhere is using to delete old values which doesn't exists.
  /// For example when you delete something and fetch again data, value still exists in map so we need to delete
  /// it first if we update stream with using current value.
  void updateStreamWith(Map<String, T?> updatedData, {bool Function(T item)? deleteWhere}) {
    final Map<String, T> currentValues = _data.value;
    if (deleteWhere != null) {
      currentValues.removeWhere((_, T value) => deleteWhere(value));
    }

    for (String id in updatedData.keys) {
      final T? data = updatedData[id];

      if (data == null) {
        currentValues.remove(id);
      } else {
        currentValues[id] = data;
      }
    }

    _data.add(currentValues);
  }

  void clearData() {
    final Map<String, T> clearData = <String, T>{};
    _data.add(clearData);
  }

  @protected
  Future<Map<String, T>> fetch(P params);
}
