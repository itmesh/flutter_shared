import 'package:rxdart/rxdart.dart';

import 'models/_models.dart';

class AudioMetadataManager {
  AudioMetadataManager();

  final BehaviorSubject<AudioMetadata?> _audioMetadata$ = BehaviorSubject<AudioMetadata?>.seeded(null);

  Stream<AudioMetadata?> get audioMetadata {
    return _audioMetadata$;
  }

  Future<void> dispose() async {
    await _audioMetadata$.close();
  }

  Future<void> setMetadata(AudioMetadata metadata) async {
    _audioMetadata$.add(metadata);
  }
}
