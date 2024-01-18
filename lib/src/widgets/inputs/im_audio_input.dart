import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:itmesh_flutter_shared/src/_src.dart';
import 'package:just_audio/just_audio.dart' as audio;

class ImAudioInput extends StatefulWidget {
  const ImAudioInput({
    super.key,
    this.initUploadData,
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
    this.baseBarColor,
    this.bufferedBarColor,
    this.progressBarColor,
    this.playerColor,
    this.timeLabelTextStyleIfExpanded,
    this.titleStyle,
    this.positionTextStyle,
    this.requiredTextError,
  });

  final UploadData? initUploadData;
  final audio.AudioPlayer? audioPlayer;
  final Stream<PositionData>? positionDataStream;
  final void Function() closeAudio;
  final Future<void> Function(UploadData audioInputData, String title, String? imageUrl) playAudio;
  final GlobalKey<FormFieldState<UploadData>> formFieldKey;
  final FormFieldValidator<UploadData>? validator;
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
  final Color? baseBarColor;
  final Color? bufferedBarColor;
  final Color? progressBarColor;
  final Color? playerColor;
  final TextStyle? timeLabelTextStyleIfExpanded;
  final TextStyle? titleStyle;
  final TextStyle? positionTextStyle;
  final String? requiredTextError;

  @override
  State<ImAudioInput> createState() => ImAudioInputState();
}

class ImAudioInputState extends State<ImAudioInput> {
  @override
  Widget build(BuildContext context) {
    return FormField<UploadData>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.formFieldKey,
      validator: (UploadData? value) {
        if (widget.isRequired && value == null) {
          if (widget.requiredTextError == null) {
            return 'This field is required';
          } else {
            return widget.requiredTextError;
          }
        }

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        return null;
      },
      initialValue: widget.initUploadData,
      builder: (FormFieldState<UploadData> field) => Column(
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
                  UploadData(
                    bytes: fileBytes,
                    file: XFile.fromData(fileBytes),
                  ),
                );

                setState(() {});

                return;
              }

              widget.formFieldKey.currentState?.didChange(
                UploadData(
                  url: result.files.first.path,
                  file: XFile(result.files.first.path ?? ''),
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

  Widget _buildErrorLine(FormFieldState<UploadData> field) {
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

  Widget _buildAudioInfo(FormFieldState<UploadData> field) {
    if (_selectedValue == null ||
        (_selectedValue?.bytes == null && _selectedValue?.url == null && _selectedValue?.file == null)) {
      return Text(
        'No file selected',
        style: widget.infoStyle,
      );
    }

    widget.playAudio(_selectedValue!, 'Selected audio file', null);

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
        baseBarColor: widget.baseBarColor,
        bufferedBarColor: widget.bufferedBarColor,
        progressBarColor: widget.progressBarColor,
        playerColor: widget.playerColor,
        timeLabelTextStyleIfExpanded: widget.timeLabelTextStyleIfExpanded,
        titleStyle: widget.titleStyle,
        positionTextStyle: widget.positionTextStyle,
      );
    } else {
      return Container(
        width: 100,
        height: 100,
        color: Colors.green,
      );
    }
  }

  UploadData? get _selectedValue => widget.formFieldKey.currentState?.value;
}
