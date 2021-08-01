import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_complete_guide/widgets/youtube_widget/volume_slider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../widgets/youtube_widget/player_state_section.dart';

import '../widgets/youtube_widget/play_pause_button_bar.dart';

class YoutubeAppDemo extends StatefulWidget {
  static const String routName = '/youtubeVideo';
  final String? id;
   final String? title;
  final int? index;
  final String? image;

  YoutubeAppDemo({
    this.id,this.title,
    this.index,
    this.image,
  });

  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late  YoutubePlayerController _controller;
  bool latee = true;
  Future<void> waiting() async {
    await Future.delayed(Duration(seconds: 1), () {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        child: YoutubePlayerIFrame(controller: _controller),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: NetworkImage(widget.image!),
                              fit: BoxFit.cover,
                            ))),
                    Container( margin: EdgeInsets.all(10),child: PlayerStateSection()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _space,
                      VolumeSlider(),
                      _space,
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

    return true;
  }

  Widget get _space => const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(backgroundColor: Colors.grey.shade900,
            appBar: AppBar(title: Text(widget.title!),),
            body: WillPopScope(
              onWillPop: asu,
              child: FutureBuilder(
                  future: waiting(),
                  builder: (context, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? LayoutBuilder(builder: (context, constraints) {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Hero(
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
                                        )),
                                    Container( margin: EdgeInsets.all(10),child:  Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 800),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.grey.shade900,
                                          ),
                                          width: 100,
                                          height: 20,
                                          padding: const EdgeInsets.all(8.0),
                                        ),
                                        Text(
                                          'Waiting',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),)
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _space,
                                        Row(
                                          children: <Widget>[
                                            const Text(
                                              "Volume",
                                              style: TextStyle(color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Slider(
                                                  inactiveColor: Colors.grey,
                                                  value: double.parse(
                                                      100.toString()),
                                                  activeColor:
                                                      Colors.green[400],
                                                  min: 0.0,
                                                  max: 100.0,
                                                  divisions: 10,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        _space,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(color: Colors.green,
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.fullscreen,
                                              ),
                                            ),
                                            IconButton(color: Colors.green,
                                              onPressed: () {},
                                              icon: Icon(Icons.pause),
                                            ),
                                            IconButton(color: Colors.green,
                                              icon: Icon(Icons.volume_up),
                                              onPressed: () {},
                                            ),
                                          ],
                                        )
                                      ],
                                    ))
                              ]);
                        })
                      : widgest),
            )));
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
