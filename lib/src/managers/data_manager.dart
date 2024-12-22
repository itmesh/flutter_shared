import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';

abstract class DataManager<T, P> {
  Box? _box;

  bool _isCurrentlyCaching = false;

  @protected
  final BehaviorSubject<Map<String, T>> data = BehaviorSubject<Map<String, T>>.seeded(<String, T>{});

  DateTime? lastFetchingAll;

  Map<String, DateTime> lastFetchingForId = <String, DateTime>{};

  Stream<List<T>> get data$ => data.stream.map((Map<String, T> data) => data.values.toList());

  Stream<Map<String, T>> get dataMap$ => data.stream;

  Stream<List<T>> dataForIds$(List<String> ids) => data.stream.map((Map<String, T> data) => data.values.toList());

  Stream<T?> dataForId$(String id) => data.stream.map((Map<String, T> data) => data[id]);

  List<T> get lastKnownValues => data.value.values.toList();

  List<T> lastKnownValuesForIds(List<String> ids) =>
      data.value.keys.where((String id) => ids.contains(id)).map((String id) => data.value[id]!).toList();

  T? lastKnownValueForId(String id) => data.value[id];

  Map<String, Duration> functionsWithFetchingTime = <String, Duration>{};

  Future<bool> fetchData(
    P params, {
    bool forceFetching = true,
    bool showErrorToast = true,
  }) async {
    data.add(await fetch(params));
    return true;
  }

  DateTime? lastFetchingDate;

  void setfunctionsWithFetchingTime(Map<String, Duration> givenFunctionsWithFetchingTime) {
    functionsWithFetchingTime = givenFunctionsWithFetchingTime;
  }

  bool validateCacheTime(
    String functionName, {
    bool forceFetch = false,
  }) {
    if (forceFetch) {
      lastFetchingDate = DateTime.now();
      return true;
    }
    if (functionsWithFetchingTime[functionName] == null) {
      return true;
    }

    if (lastFetchingDate == null) {
      lastFetchingDate = DateTime.now();
      return true;
    }

    final Duration duration = functionsWithFetchingTime[functionName]!;

    final DateTime now = DateTime.now();

    if (now.difference(lastFetchingDate!) > duration) {
      lastFetchingDate = DateTime.now();
      return true;
    }

    return false;
  }

  /// deleteWhere is using to delete old values which doesn't exists.
  /// For example when you delete something and fetch again data, value still exists in map so we need to delete
  /// it first if we update stream with using current value.
  Future<void> updateStreamWith(
    Map<String, T?> updatedData, {
    bool Function(T item)? deleteWhere,
  }) async {
    final Map<String, T> currentValues = data.value;
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

    data.add(currentValues);
  }

  void clearData() {
    final Map<String, T> clearData = <String, T>{};
    data.add(clearData);
    lastFetchingDate = null;
  }

  @protected
  Future<Map<String, T>> fetch(P params);

  Future<void> initializeCache() async {
    if (kIsWeb) {
      return;
    }

    final String boxName = T.toString();
    // print('INITIALIZE CACHE! ${boxName}');

    _box = await _openHiveBox(boxName);
    String? collectionData = _box?.get(boxName, defaultValue: '');
    // print('INITIALIZE CACHE! ${boxName} Data ${collectionData} hallo ${_box != null}');

    data.listen(
      (value) {
        if (_box != null) {
          _cacheData(value);
        }
      },
    );

    if (collectionData == null || collectionData.isEmpty) {
      return;
    }

    final Map<String, T> cachedData = <String, T>{};
    final Map<String, dynamic> decodedData = json.decode(collectionData) as Map<String, dynamic>;

    decodedData.forEach(
      (key, value) {
        final jsonData = (value as Map<String, dynamic>)..['id'] = key;
        cachedData[key] = fromJsonCache(jsonData);
      },
    );
    print('Updating stream with data coll ${T.toString()} data len: ${cachedData.length}');
    updateStreamWith(cachedData);
  }

  void clearCache() {
    if (_box != null) {
      _box?.delete(T.toString());
    }
  }

  Map<String, dynamic> toJsonCache(T object) {
    throw UnimplementedError('Implement toJson from DataManager to cache data');
  }

  T fromJsonCache(Map<String, dynamic> json) {
    throw UnimplementedError('Implement fromJson from DataManager to cache data');
  }

  Future<void> _cacheData(Map<String, T> data) async {
    if (_isCurrentlyCaching || data.isEmpty) {
      return;
    }

    try {
      final Map<String, dynamic> dataParsed = data.map(
        (key, value) {
          return MapEntry(key, toJsonCache(value));
        },
      );
      _isCurrentlyCaching = true;
      final String serializedData = await _serializeData(dataParsed); //  await compute(_serializeData, dataParsed);

      // print('Saving data... ${T.toString()} $serializedData');
      await _box?.put(
        T.toString(),
        serializedData,
      );
    } finally {
      _isCurrentlyCaching = false;
    }
  }

  static Future<String> _serializeData(Map<String, dynamic> data) async {
    return json.encode(data);
  }

  Future<Box> _openHiveBox(String boxName) async {
    if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
      String path = (await getApplicationDocumentsDirectory()).path;
      Hive.init(path);
    }
    try {
      return await Hive.openBox(boxName);
    } catch (e) {
      throw UnsupportedError('Ensure hive box exists');
    }
  }
}
