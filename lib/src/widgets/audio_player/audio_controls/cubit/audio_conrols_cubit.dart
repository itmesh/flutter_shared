import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

part 'audio_conrols_state.dart';

class AudioControlsCubit extends ImCubit<AudioControlsState> {
  AudioControlsCubit() : super(const AudioControlsNoDataState());

  final AudioPlayerManager _audioPlayerManager = GetIt.instance();

  StreamSubscription<dynamic>? _subscription;

  Future<void> init(bool showLoadingWhileBuffering) async {
    _subscription = CombineLatestStream.combine2(
      _audioPlayerManager.audioPlayerState,
      _audioPlayerManager.audioPlayer.playerStateStream,
      (AudioPlayerState? audioPlayerState, PlayerState playerState) {
        if (audioPlayerState == null) {
          emit(const AudioControlsLoadingState());
          return;
        }

        if (playerState.processingState == ProcessingState.buffering && showLoadingWhileBuffering) {
          emit(const AudioControlsLoadingState());
          return;
        }

        if (playerState.processingState == ProcessingState.loading) {
          emit(const AudioControlsLoadingState());
          return;
        }

        if (!audioPlayerState.isPlaying && audioPlayerState.position == Duration.zero) {
          emit(const AudioControlsLoadedState());
          return;
        }

        if (playerState.processingState == ProcessingState.completed) {
          emit(const AudioControlsCompletedState());
          return;
        }

        emit(
          AudioControlsActiveState(
            isPlaying: audioPlayerState.isPlaying,
            position: audioPlayerState.position,
            bufferedPosition: audioPlayerState.bufferedPosition,
            audioDuration: audioPlayerState.audioDuration,
          ),
        );
      },
    ).listen((_) {});
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();

    await super.close();
  }

  void play() {
    _audioPlayerManager.audioPlayer.play();
  }

  void pause() {
    _audioPlayerManager.audioPlayer.pause();
  }

  void replay() {
    _audioPlayerManager.audioPlayer.seek(Duration.zero);
  }

  void seek(Duration position) {
    _audioPlayerManager.audioPlayer.seek(position);
  }

  void forward15Sec() async {
    await _audioPlayerManager.audioPlayer.seek(
      Duration(seconds: _audioPlayerManager.audioPlayer.position.inSeconds + 15),
    );
  }

  void backward15Sec() async {
    await _audioPlayerManager.audioPlayer.seek(
      Duration(seconds: _audioPlayerManager.audioPlayer.position.inSeconds - 15),
    );
  }
}
