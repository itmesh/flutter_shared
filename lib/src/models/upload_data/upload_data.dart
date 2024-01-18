import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';

class UploadData extends Equatable {
  const UploadData({
    this.url,
    this.file,
    this.bytes,
    this.fileName,
  });

  final String? url;
  final XFile? file;
  final Uint8List? bytes;
  final String? fileName;

  String get fileNameFromFilePath => file?.path.split('/').last ?? '';

  @override
  List<Object?> get props => [
        url,
        file,
        bytes,
        fileName,
      ];
}
