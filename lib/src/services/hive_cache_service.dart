import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:itmesh_flutter_shared/src/services/cache_service.dart';
import 'package:path_provider/path_provider.dart';

class HiveCacheService<T> extends CacheService<T> {
  Box? _box;

  bool _isCurrentlyCaching = false;

  HiveCacheService({
    required super.collectionName,
    required super.toJson,
    required super.fromJson,
  });

  @override
  Future<void> cacheData(Map<String, dynamic> data) async {
    if (_isCurrentlyCaching || data.isEmpty) {
      return;
    }

    try {
      final Map<String, dynamic> dataParsed = data.map(
        (key, value) {
          return MapEntry(key, toJson(value));
        },
      );
      _isCurrentlyCaching = true;
      final String serializedData = await _serializeData(dataParsed);
      // TODO(lukkam): Consider moving serialization to Isolate if main thread is too busy.
      //               for now dropping this idea cuz if we initialize a lot of managers in same time we create too much isolate threads. (maybe some Queue?)
      // await compute(_serializeData, dataParsed);
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

  @override
  void clearCache() {
    _box?.delete(collectionName);
  }

  Future<Box> _openHiveBox(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName) && !kIsWeb) {
        String path = (await getApplicationDocumentsDirectory()).path;
        Hive.init(path);
      }
      return await Hive.openBox(boxName);
    } catch (e) {
      throw UnsupportedError('Ensure hive box exists');
    }
  }

  @override
  Future<void> init() async {
    await _openHiveBox(collectionName);
  }

  @override
  Map<String, T>? getCachedData() {
    String? collectionData = _box?.get(collectionName, defaultValue: '');

    if (collectionData == null || collectionData.isEmpty) {
      return null;
    }

    final Map<String, dynamic> decodedData = json.decode(collectionData) as Map<String, dynamic>;
    final Map<String, T> cachedData = <String, T>{};

    decodedData.forEach(
      (key, value) {
        final jsonData = (value as Map<String, dynamic>)..['id'] = key;
        cachedData[key] = fromJson(jsonData);
      },
    );
    return cachedData;
  }
}
