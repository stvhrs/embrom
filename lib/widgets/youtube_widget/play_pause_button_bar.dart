import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayPauseButtonBar extends StatefulWidget {
  final int index;
  final String id;
  final String image;
  PlayPauseButtonBar(this.index, this.id, this.image);

  @override
  _PlayPauseButtonBarState createState() => _PlayPauseButtonBarState();
}

class _PlayPauseButtonBarState extends State<PlayPauseButtonBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  void play() {
    _controller.reverse();
    context.ytController.play();
  }

  void pause() {
    _controller.forward();
    context.ytController.pause();
  }

  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  late AnimationController _controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        YoutubeValueBuilder(
          builder: (context, value) {
            return IconButton(color: Colors.green,
              onPressed: () {
                if (value.playerState == PlayerState.playing) {
                  context.ytController.onEnterFullscreen!();
                } else if (value.playerState == PlayerState.paused) {
                  play();
                  Future.delayed(Duration(milliseconds: 500), () {
                    context.ytController.onEnterFullscreen!();
                  });
                }
              },
              icon: Icon(
                Icons.fullscreen,
              ),
            );
          },
        ),
       
        YoutubeValueBuilder(
          builder: (context, value) {
            return IconButton(color: Colors.green,
              onPressed: () {
                (value.isReady)
                    ? value.playerState == PlayerState.playing
                        ? pause()
                        : play()
                    : pause();
              },
              icon: AnimatedIcon(
                progress: _controller,
                color: Theme.of(context).primaryColor,
                icon: AnimatedIcons.pause_play,
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isMuted,
          builder: (context, isMuted, _) {
            return IconButton(color: Colors.green,
              icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
              onPressed: () {
                _isMuted.value = !isMuted;
                isMuted
                    ? context.ytController.unMute()
                    : context.ytController.mute();
              },
            );
          },
        ),
      ],
    );
  }
}
