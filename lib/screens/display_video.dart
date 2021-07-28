import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class DisplayVIdeo extends StatefulWidget {
   static const routeame = '/displayVideo';
  final String? pickedFile;
  final bool? downloaded;
  final String? thumbnailPath;

  DisplayVIdeo(
    [ this.pickedFile,
       this.downloaded,
       this.thumbnailPath]);
  @override
  _DisplayVIdeoState createState() => _DisplayVIdeoState();
}

class _DisplayVIdeoState extends State<DisplayVIdeo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
   
  }

  Future<void> init() async {
    if (widget.downloaded == false) {
      print('video memory');
      _controller = VideoPlayerController.file(File(widget.pickedFile!));
      await _controller!.initialize();

    await  _controller!.setLooping(true);
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (mounted) {
        setState(() {});
      }
      _controller!.play();
    } else {
      print('ideo net');
      _controller = VideoPlayerController.network(widget.pickedFile!)
        ..initialize().then((_) {
          _controller!.setLooping(true);
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          if (mounted) {
            setState(() {});
          }
          _controller!.play();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Hero(
          tag: widget.pickedFile!,child :FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          return Center(
            child: _controller!.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                      CircleAvatar(
                        radius: 30,
                        child: IconButton(
                            onPressed: () {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            },
                            icon: Icon(
                              _controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
                : AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: widget.downloaded!
                        ? Image.network(widget.thumbnailPath!)
                        : Image.file(File(widget.thumbnailPath!)),
                  ),
          );
        }
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller!.dispose();
  }
}
