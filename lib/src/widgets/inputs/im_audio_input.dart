import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:just_audio/just_audio.dart' as audio;

class ImAudioInput extends StatefulWidget {
  const ImAudioInput({
    super.key,
    this.initAudioInputData,
    required this.audioPlayer,
    required this.positionDataStream,
    required this.closeAudio,
    required this.playAudio,
    required this.formFieldKey,
    this.validator,
    this.isRequired = false,
    required this.playIcon,
    required this.backward15Seconds,
    required this.continueIcon,
    required this.pauseIcon,
    required this.forward15SecondsIcon,
    required this.closeIcon,
    this.circularProgressIndicatorColor,
    this.labelStyle,
    this.errorStyle,
    this.infoStyle,
  });

  final AudioInputData? initAudioInputData;
  final audio.AudioPlayer? audioPlayer;
  final Stream<PositionData>? positionDataStream;
  final void Function() closeAudio;
  final Future<void> Function(AudioInputData audioInputData, String title) playAudio;
  final GlobalKey<FormFieldState<AudioInputData>> formFieldKey;
  final FormFieldValidator<AudioInputData>? validator;
  final bool isRequired;
  final Color? circularProgressIndicatorColor;
  final Widget playIcon;
  final Widget backward15Seconds;
  final Widget continueIcon;
  final Widget pauseIcon;
  final Widget forward15SecondsIcon;
  final Widget closeIcon;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? infoStyle;

  @override
  State<ImAudioInput> createState() => ImAudioInputState();
}

class ImAudioInputState extends State<ImAudioInput> {
  @override
  Widget build(BuildContext context) {
    return FormField<AudioInputData>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.formFieldKey,
      validator: (AudioInputData? value) {
        if (widget.isRequired && value == null) {
          return 'This field is required';
        }

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        return null;
      },
      initialValue: widget.initAudioInputData,
      builder: (FormFieldState<AudioInputData> field) => Column(
        children: <Widget>[
          Text(
            'Select Audio File',
            style: widget.labelStyle,
          ),
          ElevatedButton(
            onPressed: () async {
              final FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
                allowMultiple: false,
              );

              if (result == null) {
                return;
              }

              if (kIsWeb) {
                final Uint8List? fileBytes = result.files.first.bytes;
                if (fileBytes == null) {
                  return;
                }

                widget.formFieldKey.currentState?.didChange(
                  AudioInputData(
                    imageBytes: fileBytes,
                    imageFile: XFile.fromData(fileBytes),
                  ),
                );

                setState(() {});

                return;
              }

              widget.formFieldKey.currentState?.didChange(
                AudioInputData(
                  imageUrl: result.files.first.path,
                  imageFile: XFile(result.files.first.path ?? ''),
                ),
              );

              setState(() {});
            },
            child: const Text('File Picker'),
          ),
          _buildAudioInfo(field),
          _buildErrorLine(field),
        ],
      ),
    );
  }

  Widget _buildErrorLine(FormFieldState<AudioInputData> field) {
    if (field.hasError) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
        ),
        child: Text(
          field.errorText ?? '',
          style: widget.errorStyle,
        ),
      );
    }

    return const SizedBox(height: 16.0);
  }

  Widget _buildAudioInfo(FormFieldState<AudioInputData> field) {
    if (_selectedValue != null) {
      widget.playAudio(_selectedValue!, 'Selected audio file');

      if (widget.audioPlayer != null && widget.positionDataStream != null) {
        return ImAudioPlayer(
          audioPlayer: widget.audioPlayer!,
          positionDataStream: widget.positionDataStream!,
          showLoadingWhileBuffering: true,
          allowToChangeExpand: false,
          onCloseTap: () {
            widget.closeAudio.call();
            widget.formFieldKey.currentState?.didChange(null);
            setState(() {});
          },
          initialExpanded: false,
          playIcon: widget.playIcon,
          backward15Seconds: widget.backward15Seconds,
          continueIcon: widget.continueIcon,
          pauseIcon: widget.pauseIcon,
          forward15SecondsIcon: widget.forward15SecondsIcon,
          closeIcon: widget.closeIcon,
          circularProgressIndicatorColor: widget.circularProgressIndicatorColor,
        );
      } else {
        return const SizedBox();
      }
    }

    return Text(
      'No file selected',
      style: widget.infoStyle,
    );
  }

  AudioInputData? get _selectedValue => widget.formFieldKey.currentState?.value;
}

class AudioInputData {
  const AudioInputData({
    this.imageUrl,
    this.imageFile,
    this.imageBytes,
  });

  final String? imageUrl;
  final XFile? imageFile;
  final Uint8List? imageBytes;
}
