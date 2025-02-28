abstract class CacheService<T> {
  final String collectionName;

  final Map<String, dynamic> Function(T object) toJson;

  final T Function(Map<String, dynamic>) fromJson;

  CacheService({
    required this.collectionName,
    required this.toJson,
    required this.fromJson,
  });

  void clearCache();

  Future<void> cacheData(Map<String, T> data);

  Future<void> init();

  Map<String, T>? getCachedData();
}
