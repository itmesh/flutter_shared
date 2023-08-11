import 'package:equatable/equatable.dart';

class AudioMetadata extends Equatable {
  const AudioMetadata({
    required this.title,
  });

  final String title;

  @override
  List<Object?> get props => <Object?>[
        title,
      ];
}
