import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class BufferAudioSource extends StreamAudioSource {
  BufferAudioSource({
    required this.buffer,
    this.title,
  }) : super(
          tag: MediaItem(
            id: buffer.hashCode.toString(),
            title: title ?? 'BufferAudioSource',
          ),
        );

  final Uint8List buffer;
  final String? title;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= buffer.length;
    return StreamAudioResponse(
      sourceLength: buffer.length,
      contentLength: end - start,
      offset: start,
      stream: Stream<List<int>>.value(buffer.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
