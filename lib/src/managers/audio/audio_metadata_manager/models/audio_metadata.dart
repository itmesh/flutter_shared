import 'package:equatable/equatable.dart';

class AudioMetadata extends Equatable {
  const AudioMetadata({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String? imageUrl;

  @override
  List<Object?> get props => <Object?>[
        title,
        imageUrl,
      ];
}
