import 'dart:async';

import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  AudioPlayerManager({
    required AudioPlayer audioPlayer,
    required AudioMetadataManager audioMetadataManager,
  })  : _audioPlayer = audioPlayer,
        _audioMetadataManager = audioMetadataManager;

  AudioPlayerManager.base({
    required AudioMetadataManager audioMetadataManager,
  })  : _audioPlayer = AudioPlayer(),
        _audioMetadataManager = audioMetadataManager;

  final AudioPlayer _audioPlayer;
  final AudioMetadataManager _audioMetadataManager;

  final BehaviorSubject<AudioPlayerState?> _audioPlayerState$ = BehaviorSubject<AudioPlayerState?>.seeded(null);

  StreamSubscription<dynamic>? _playerStateSubscription;

  Stream<AudioPlayerState?> get audioPlayerState {
    return _audioPlayerState$;
  }

  AudioPlayer get audioPlayer {
    return _audioPlayer;
  }

  Future<void> init() async {
    _playerStateSubscription = Rx.combineLatest5(
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
      _audioPlayer.playerStateStream,
      _audioMetadataManager.audioMetadata,
      _handleDataChange,
    ).listen((_) {});
  }

  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    await _audioPlayerState$.close();
    await _audioPlayer.dispose();
  }

  Future<void> setAudioSource({
    required UploadData uploadData,
    required String title,
    required Duration initialPosition,
    required String? imageUrl,
  }) async {
    if (uploadData.url != null) {
      final Uri? uri = Uri.tryParse(uploadData.url!);
      if (uri != null) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            uri,
            tag: MediaItem(
              id: uri.toString(),
              title: title,
              artUri: imageUrl != null ? Uri.tryParse(imageUrl) : null,
            ),
          ),
          initialPosition: initialPosition,
        );
      }
    }

    if (uploadData.bytes != null) {
      await _audioPlayer.setAudioSource(
        BufferAudioSource(
          buffer: uploadData.bytes!,
          title: title,
        ),
        initialPosition: initialPosition,
      );
    }

    await _audioPlayer.setLoopMode(LoopMode.off);

    _audioMetadataManager.setMetadata(
      AudioMetadata(
        title: title,
        imageUrl: imageUrl,
      ),
    );
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  void _handleDataChange(
    Duration position,
    Duration bufferedPosition,
    Duration? duration,
    PlayerState playerState,
    AudioMetadata? audioMetadata,
  ) {
    _audioPlayerState$.add(
      AudioPlayerState(
        title: audioMetadata?.title,
        position: position,
        bufferedPosition: bufferedPosition,
        audioDuration: duration ?? Duration.zero,
        isPlaying: playerState.playing,
      ),
    );
  }
}
