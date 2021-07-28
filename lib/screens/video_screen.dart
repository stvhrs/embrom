import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_complete_guide/widgets/youtube_widget/volume_slider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../widgets/youtube_widget/player_state_section.dart';
import '../widgets/youtube_widget/metadata_section.dart';
import '../widgets/youtube_widget/play_pause_button_bar.dart';

class YoutubeAppDemo extends StatefulWidget {
  static const String routName = '/youtubeVideo';
  final String? id;
  final int? index;
  final String? image;

  YoutubeAppDemo({
    this.id,
    this.index,
    this.image,
  });

  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late final YoutubePlayerController _controller;
  bool latee = true;
  Future<void> waiting() async {
    await Future.delayed(Duration(seconds:1), () {
      _controller = YoutubePlayerController(  
        initialVideoId: widget.id!,
        params: const YoutubePlayerParams(
          enableKeyboard: true,
          startAt: const Duration(seconds: 0),
          showVideoAnnotations: false,
          showControls: true,
          autoPlay: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
          privacyEnhanced: true,
          desktopMode: true,
        ),
      )..listen((value) {
          if (value.isReady && !value.hasPlayed) {
            _controller
              ..hidePauseOverlay()
              ..play()
              ..hideTopMenu();
          }
        });
    }).then((_) {
      latee = false;
    });

    _controller.onEnterFullscreen = () {
      _controller.hidePauseOverlay();
      _controller.hideTopMenu();
      _controller.play();
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };

    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.play();
      });
      // Future.delayed(const Duration(seconds: 5), () {
      //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      // });
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
      log('Exited Fullscreen');
    };

    //print(context.ytController.initialVideoId.toString());
  }

  Widget get widgest => YoutubePlayerControllerProvider(
        controller: _controller,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                    child: YoutubePlayerIFrame(controller: _controller),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                          image: NetworkImage(widget.image!),
                          fit: BoxFit.cover,
                        ))),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _space,
                      MetaDataSection(),
                      _space,
                      VolumeSlider(),
                      _space,
                      PlayerStateSection(),
                      PlayPauseButtonBar(
                          widget.index!, widget.id!, widget.image!),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );

  Future<bool> asu() async {
    if (mounted) {
      setState(() {});

      await Future.delayed(Duration(milliseconds: 300), () {});
    }
    print('popopopopopoopopopopopop');
    return true;
  }

  Widget get _space => const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WillPopScope(
            onWillPop: asu,
            child: FutureBuilder(
                future: waiting(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Hero(
                            tag: widget.index!,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                width: double.infinity,
                                child: Image.network(
                                  widget.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                        : widgest)));
  }

  @override
  void dispose() {
    if (latee == false) {
      print(latee);
      _controller.close();
    }

    super.dispose();
  }
}
