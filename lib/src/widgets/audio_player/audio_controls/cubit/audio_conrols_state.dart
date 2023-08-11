part of 'audio_conrols_cubit.dart';

sealed class AudioControlsState extends Equatable {
  const AudioControlsState();

  @override
  List<Object?> get props => <Object?>[];
}

class AudioControlsLoadingState extends AudioControlsState {
  const AudioControlsLoadingState();
}

class AudioControlsNoDataState extends AudioControlsState {
  const AudioControlsNoDataState();
}

class AudioControlsLoadedState extends AudioControlsState {
  const AudioControlsLoadedState();
}

class AudioControlsActiveState extends AudioControlsState {
  const AudioControlsActiveState({
    required this.isPlaying,
    required this.position,
    required this.bufferedPosition,
    required this.audioDuration,
  });

  final bool isPlaying;
  final Duration position;
  final Duration bufferedPosition;
  final Duration audioDuration;

  @override
  List<Object?> get props => <Object?>[
        isPlaying,
        position,
        bufferedPosition,
        audioDuration,
      ];
}

class AudioControlsCompletedState extends AudioControlsState {
  const AudioControlsCompletedState();
}
