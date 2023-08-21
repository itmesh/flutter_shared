import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/audio_conrols_cubit.dart';

class AudioControls extends StatefulWidget {
  AudioControls({
    super.key,
    required this.onCloseTap,
    required this.isUserOnLessonDetailsScreen,
    required this.showLoadingWhileBuffering,
    required this.playIcon,
    required this.backward15Seconds,
    required this.continueIcon,
    required this.pauseIcon,
    required this.forward15SecondsIcon,
    required this.closeIcon,
    this.isExpanded = false,
    this.circularProgressIndicatorColor,
  });

  final void Function() onCloseTap;
  final bool isUserOnLessonDetailsScreen;
  final bool showLoadingWhileBuffering;
  final Color? circularProgressIndicatorColor;
  final Widget playIcon;
  final Widget backward15Seconds;
  final Widget continueIcon;
  final Widget pauseIcon;
  final Widget forward15SecondsIcon;
  final Widget closeIcon;

  final bool isExpanded;

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls> {
  late final double controlsSize = widget.isExpanded ? 48.0 : 32.0;
  late final double playControlSize = widget.isExpanded ? 64.0 : 44.0;
  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioControlsCubit>(
      create: (BuildContext context) => AudioControlsCubit()..init(widget.showLoadingWhileBuffering),
      child: BlocBuilder<AudioControlsCubit, AudioControlsState>(
        builder: (BuildContext context, AudioControlsState state) {
          switch (state) {
            case AudioControlsLoadingState():
              if (_clicked) {
                return _buildLoading(context);
              }
              return _buildLoaded(context);

            case AudioControlsNoDataState():
              return const SizedBox();

            case AudioControlsLoadedState():
              return _buildLoaded(context);

            case AudioControlsActiveState():
              return _buildActive(context, state);

            case AudioControlsCompletedState():
              return _buildCompleted(context);
          }
        },
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context,
  ) {
    return SizedBox(
      width: controlsSize,
      height: controlsSize,
      child: CircularProgressIndicator(
        color: widget.circularProgressIndicatorColor,
      ),
    );
  }

  Widget _buildLoaded(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_clicked) {
          _clicked = true;
          setState(() {});
        }
        
        final AudioControlsCubit cubit = context.read();

        cubit.play();
      },
      child: Center(
        child: SizedBox(
          height: playControlSize,
          width: playControlSize,
          child: widget.playIcon,
        ),
      ),
    );
  }

  Widget _buildActive(BuildContext context, AudioControlsActiveState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          child: Center(
            child: SizedBox(
              height: controlsSize,
              width: controlsSize,
              child: widget.backward15Seconds,
            ),
          ),
          onTap: () {
            final AudioControlsCubit cubit = context.read();

            cubit.backward15Sec();
          },
        ),
        const SizedBox(width: 16.0),
        _buildActionIcon(context, state.isPlaying),
        const SizedBox(width: 16.0),
        widget.isExpanded ? _buildForward15Sec(context) : _buildCloseIcon(),
      ],
    );
  }

  Widget _buildCompleted(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          child: Center(
            child: Icon(
              size: controlsSize,
              Icons.replay,
              color: Colors.white,
            ),
          ),
          onTap: () {
            final AudioControlsCubit cubit = context.read();

            cubit.replay();
          },
        ),
        const SizedBox(width: 16.0),
        _buildCloseIcon(),
      ],
    );
  }

  Widget _buildActionIcon(BuildContext context, bool playing) {
    if (!playing) {
      return GestureDetector(
        onTap: () {
          final AudioControlsCubit cubit = context.read();

          cubit.play();
        },
        child: Center(
          child: SizedBox(
            height: controlsSize,
            width: controlsSize,
            child: widget.continueIcon,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        final AudioControlsCubit cubit = context.read();

        cubit.pause();
      },
      child: Center(
        child: SizedBox(
          height: controlsSize,
          width: controlsSize,
          child: widget.pauseIcon,
        ),
      ),
    );
  }

  Widget _buildForward15Sec(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final AudioControlsCubit cubit = context.read();

        cubit.forward15Sec();
      },
      child: Center(
        child: SizedBox(
          height: controlsSize,
          width: controlsSize,
          child: widget.forward15SecondsIcon,
        ),
      ),
    );
  }

  Widget _buildCloseIcon() {
    return GestureDetector(
      onTap: widget.onCloseTap,
      child: Center(
        child: SizedBox(
          height: controlsSize,
          width: controlsSize,
          child: widget.closeIcon,
        ),
      ),
    );
  }
}
