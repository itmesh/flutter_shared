import 'package:equatable/equatable.dart';

class PositionData extends Equatable {
  const PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  @override
  List<Object?> get props => <Object?>[
        position,
        bufferedPosition,
        duration,
      ];
}
