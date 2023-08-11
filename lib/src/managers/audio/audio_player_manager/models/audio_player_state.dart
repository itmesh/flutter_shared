import 'package:equatable/equatable.dart';

class AudioPlayerState extends Equatable {
  const AudioPlayerState({
    required this.title,
    required this.position,
    required this.bufferedPosition,
    required this.audioDuration,
    required this.isPlaying,
  });

  final String? title;
  final Duration position;
  final Duration bufferedPosition;
  final Duration audioDuration;
  final bool isPlaying;

  @override
  List<Object?> get props => <Object?>[
        title,
        position,
        bufferedPosition,
        audioDuration,
        isPlaying,
      ];
}
