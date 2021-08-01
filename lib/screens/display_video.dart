import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class DisplayVIdeo extends StatefulWidget {
  final String? pickedFile;
  final bool? downloaded;
  final String? thumbnailPath;

  DisplayVIdeo([this.pickedFile, this.downloaded, this.thumbnailPath]);
  @override
  _DisplayVIdeoState createState() => _DisplayVIdeoState();
}

class _DisplayVIdeoState extends State<DisplayVIdeo>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;

  final TransformationController _transformationController =
      TransformationController();

  Animation<Matrix4>? _animationReset;

  late final AnimationController _controllerReset;

  void _onAnimateReset() {
    _transformationController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    init();
  }

  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  void videoPlayerListener() {
    if (_controller!.value.isPlaying != isPlaying.value) {
      isPlaying.value = _controller!.value.isPlaying;
    }
  }

  Future<void> init() async {
    if (widget.downloaded == false) {
      print('video memory');
      _controller = VideoPlayerController.file(File(widget.pickedFile!));
      await _controller!.initialize();
      _controller!.addListener(videoPlayerListener);

      // await _controller!.setLooping(true);
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (mounted) {
        setState(() {});
      }
      await _controller!.play();
    } else {
      print('ideo net');
      _controller = VideoPlayerController.network(widget.pickedFile!);
      _controller!.addListener(videoPlayerListener);

      _controller!.initialize();
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (mounted) {
        setState(() {});
      }
      _controller!.play();
    }
  }

  Future<void> playButtonCallback() async {
    if (isPlaying.value) {
      _controller!.pause();
    } else {
      if (_controller!.value.duration == _controller!.value.position) {
        _controller!
          ..seekTo(Duration.zero)
          ..play();
      } else {
        _controller!.play();
      }
    }
  }

  // Widget get playControlButton {
  //   return ValueListenableBuilder<bool>(
  //     valueListenable: isPlaying,
  //     builder: (_, bool value, Widget? child) => GestureDetector(
  //       behavior: HitTestBehavior.opaque,
  //       onTap: value ? playButtonCallback : null,
  //       child: Center(
  //         child: AnimatedOpacity(
  //           duration: Duration(milliseconds: 300),
  //           opacity: value ? 0.0 : 1.0,
  //           child: GestureDetector(
  //             onTap: playButtonCallback,
  //             child: DecoratedBox(
  //               decoration: const BoxDecoration(
  //                 boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12)],
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 value ? Icons.pause_circle_outline : Icons.play_circle_filled,
  //                 size: 70.0,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white)),
        body: ValueListenableBuilder<bool>(
          valueListenable: isPlaying,
          builder: (_, bool value, Widget? child) => GestureDetector(
            onTap: () {
              playButtonCallback();
            },
            child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionEnd: (d) {
                  _animateResetInitialize();
                },
                child: Hero(
                    tag: widget.pickedFile!,
                    child: Center(
                      child: _controller!.value.isInitialized
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  opacity: value ? 0.0 : 1.0,
                                  child: GestureDetector(
                                    onTap: playButtonCallback,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(color: Colors.black12)
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        value
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_filled,
                                        size: 70.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : widget.downloaded!
                              ? Container(
                                  width: double.infinity,
                                  child: Image.network(
                                    widget.thumbnailPath!,
                                    fit: BoxFit.fitWidth,
                                  ))
                              : Container(
                                  width: double.infinity,
                                  child: Image.file(File(widget.thumbnailPath!),
                                      fit: BoxFit.fitWidth)),
                    ))),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.removeListener(videoPlayerListener);
    _controller!.dispose();
  }
}
