import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:path_provider/path_provider.dart';

abstract class CachedDataManager<T, P> extends DataManager<T, P> {
  String get name;

  static const String _boxName = 'cache';

  Future<bool> init() async {
    print('Initing $name');
    // Get hive box using name and read data.
    Box box = await _openHiveBox();

    String? collection = box.get(name, defaultValue: '');

    if (collection == null) {
      return false;
    }

    if (collection.isNotEmpty) {
      // Use fromJson to parse the data.
      Map<String, T> cashedData = fromJson(collection);

      // Put read cashedData into stream.
      updateStreamWith(cashedData);
    }

    // Subscribe to stream, when data changes use toJson and _save to cache it.
    data.listen((Map<String, T> value) {
      String json = toJson(value);
      print(json);
      _save(json);
    });
    return true;
  }

  Map<String, T> fromJson(String json);

  String toJson(Map<String, T> data);

  Future<void> _save(String json) async {
    // Get hive box using name.
    Box box = await _openHiveBox();

    // Write data to hive.
    box.put(name, json);
  }

  Future<Box> _openHiveBox() async {
    if (!kIsWeb && !Hive.isBoxOpen(_boxName)) {
      String path = (await getApplicationDocumentsDirectory()).path;
      Hive.init(path);
    }

    return await Hive.openBox(_boxName);
  }
}
