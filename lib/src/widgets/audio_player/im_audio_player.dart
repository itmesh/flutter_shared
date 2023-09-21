import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'audio_controls/audio_controls.dart';

class ImAudioPlayer extends StatefulWidget {
  const ImAudioPlayer({
    super.key,
    required this.audioPlayer,
    required this.positionDataStream,
    required this.onCloseTap,
    required this.allowToChangeExpand,
    required this.initialExpanded,
    required this.showLoadingWhileBuffering,
    this.onWidgetTapIfCantExpand,
    this.baseBarColor,
    this.bufferedBarColor,
    this.progressBarColor,
    this.timeLabelTextStyleIfExpanded,
    this.playerColor,
    this.titleStyle,
    this.on15secBackBigTap,
    this.on15secNextBigTap,
    this.on15secBackTap,
    this.onPauseTap,
    this.positionTextStyle,
    this.onBigGreenPlayTap,
    this.onBigPausePlayerTap,
    this.onBigPlayTap,
    this.onGreenPlayTap,
    this.onOpenBigPlayerTap,
    this.onPlayTap,
    required this.playIcon,
    required this.backward15Seconds,
    required this.continueIcon,
    required this.pauseIcon,
    required this.forward15SecondsIcon,
    required this.closeIcon,
    this.circularProgressIndicatorColor,
  });

  final AudioPlayer audioPlayer;
  final Stream<PositionData> positionDataStream;
  final bool allowToChangeExpand;
  final bool initialExpanded;
  final void Function() onCloseTap;
  final void Function()? onWidgetTapIfCantExpand;
  final void Function()? on15secBackTap;
  final void Function()? onPauseTap;
  final void Function()? on15secBackBigTap;
  final void Function()? on15secNextBigTap;
  final void Function()? onGreenPlayTap;
  final void Function()? onPlayTap;
  final void Function()? onOpenBigPlayerTap;
  final void Function()? onBigPlayTap;
  final void Function()? onBigGreenPlayTap;
  final void Function()? onBigPausePlayerTap;

  final bool showLoadingWhileBuffering;
  final Color? baseBarColor;
  final Color? bufferedBarColor;
  final Color? progressBarColor;
  final Color? playerColor;
  final TextStyle? timeLabelTextStyleIfExpanded;
  final TextStyle? titleStyle;
  final TextStyle? positionTextStyle;
  final Color? circularProgressIndicatorColor;
  final Widget playIcon;
  final Widget backward15Seconds;
  final Widget continueIcon;
  final Widget pauseIcon;
  final Widget forward15SecondsIcon;
  final Widget closeIcon;

  @override
  State<ImAudioPlayer> createState() => _ImAudioPlayerState();
}

class _ImAudioPlayerState extends State<ImAudioPlayer> {
  bool _isExpanded = false;
  bool _initialPlaying = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpanded) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        onPanUpdate: (DragUpdateDetails details) {
          // Swiping in down direction.
          if (details.delta.dy > 0) {
            _onTap();
          }
        },
        child: Container(
          width: double.maxFinite,
          height: 212.0,
          decoration: BoxDecoration(
            color: widget.playerColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 26.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: _buildMetadataInfo(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 44),
                    child: _buildProgressBar(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: AudioControls(
                      onCloseTap: widget.onCloseTap,
                      isUserOnLessonDetailsScreen: widget.allowToChangeExpand,
                      isExpanded: _isExpanded,
                      showLoadingWhileBuffering: widget.showLoadingWhileBuffering,
                      closeIcon: widget.closeIcon,
                      playIcon: widget.playIcon,
                      backward15Seconds: widget.backward15Seconds,
                      continueIcon: widget.continueIcon,
                      pauseIcon: widget.pauseIcon,
                      circularProgressIndicatorColor: widget.circularProgressIndicatorColor,
                      isInitialPlaying: _initialPlaying,
                      forward15SecondsIcon: widget.forward15SecondsIcon,
                      on15secBackTap: widget.on15secBackTap,
                      on15secNextBigTap: widget.on15secNextBigTap,
                      onPauseTap: widget.onBigPausePlayerTap,
                      on15secBackBigTap: widget.on15secBackBigTap,
                      onGreenPlayTap: widget.onBigGreenPlayTap,
                      onPlayTap: widget.onBigPlayTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _buildNotExpandedView();
  }

  Widget _buildNotExpandedView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        color: widget.playerColor,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildMetadataInfo(),
                          _buildTimeInfo(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    AudioControls(
                      onCloseTap: widget.onCloseTap,
                      isUserOnLessonDetailsScreen: widget.allowToChangeExpand,
                      showLoadingWhileBuffering: widget.showLoadingWhileBuffering,
                      closeIcon: widget.closeIcon,
                      playIcon: widget.playIcon,
                      backward15Seconds: widget.backward15Seconds,
                      continueIcon: widget.continueIcon,
                      pauseIcon: widget.pauseIcon,
                      circularProgressIndicatorColor: widget.circularProgressIndicatorColor,
                      isInitialPlaying: _initialPlaying,
                      forward15SecondsIcon: widget.forward15SecondsIcon,
                      on15secBackTap: widget.on15secBackTap,
                      on15secNextBigTap: widget.on15secNextBigTap,
                      onPauseTap: widget.onPauseTap,
                      on15secBackBigTap: widget.on15secBackBigTap,
                      onGreenPlayTap: widget.onGreenPlayTap,
                      onPlayTap: widget.onPlayTap,
                    ),
                  ],
                ),
              ),
              _buildProgressBar(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataInfo() {
    return StreamBuilder<SequenceState?>(
      stream: widget.audioPlayer.sequenceStateStream,
      builder: (BuildContext context, AsyncSnapshot<SequenceState?> snapshot) {
        final SequenceState? state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox(
            height: 18.0,
          );
        }

        final MediaItem metadata = state!.currentSource!.tag as MediaItem;

        return Text(
          metadata.title,
          style: widget.titleStyle,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildTimeInfo() {
    return StreamBuilder<PositionData?>(
      stream: widget.positionDataStream,
      builder: (BuildContext context, AsyncSnapshot<PositionData?> snapshot) {
        final PositionData? positionData = snapshot.data;

        if (positionData == null) {
          return const SizedBox(
            height: 14.0,
          );
        }

        if (positionData.position == Duration.zero) {
          _initialPlaying = false;
          return SizedBox(
            height: 14.0,
            child: Text(
              '${positionData.duration.readableInMinutes} min',
              style: widget.positionTextStyle,
            ),
          );
        }

        if (positionData.position != Duration.zero) {
          _initialPlaying = true;
          return SizedBox(
            height: 14.0,
            child: Text(
              '${Duration(seconds: positionData.duration.inSeconds - positionData.position.inSeconds).readableInMinutes} left',
              style: widget.positionTextStyle,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<PositionData?>(
      stream: widget.positionDataStream,
      builder: (BuildContext context, AsyncSnapshot<PositionData?> snapshot) {
        final PositionData? positionData = snapshot.data;
        if (snapshot.data == null && _isExpanded) {
          return SizedBox(
            height: _initialPlaying ? 48.0 : 28.0,
            width: double.maxFinite,
          );
        }

        if (positionData?.position == Duration.zero) {
          return SizedBox(
            height: _isExpanded ? 38 : 20.0,
            width: double.maxFinite,
          );
        }

        if (positionData == null) {
          return const SizedBox(
            height: 20.0,
            width: double.maxFinite,
          );
        }

        return ProgressBar(
          baseBarColor: widget.baseBarColor,
          bufferedBarColor: widget.bufferedBarColor,
          progressBarColor: widget.progressBarColor,
          thumbColor: Colors.transparent,
          timeLabelLocation: _isExpanded ? TimeLabelLocation.below : TimeLabelLocation.none,
          timeLabelType: _isExpanded ? TimeLabelType.remainingTime : null,
          timeLabelTextStyle: _isExpanded ? widget.timeLabelTextStyleIfExpanded : null,
          thumbGlowRadius: 0.0,
          progress: positionData.position,
          total: positionData.duration,
          buffered: positionData.bufferedPosition,
          onSeek: widget.audioPlayer.seek,
        );
      },
    );
  }

  void _onTap() {
    if (widget.allowToChangeExpand) {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        widget.onOpenBigPlayerTap?.call();
      }
      setState(() {});

      return;
    }

    widget.onWidgetTapIfCantExpand?.call();
  }
}
