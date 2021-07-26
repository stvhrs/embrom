import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:intl/intl.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({this.path, this.person, required this.pop});
  final String? path;
  final Person? person;
  final bool pop;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _controller = VideoPlayerController.file(File(widget.path!));
    await _controller.initialize();
    _controller.addListener(videoPlayerListener);

    //  _controller.setLooping(true);

    if (mounted) {
      setState(() {});
    }
    _controller.play();
  }

  @override
  void dispose() {
    /// Remove listener from the controller and dispose it when widget dispose.
    /// 部件销毁时移除控制器的监听并销毁控制器。
    _controller.removeListener(videoPlayerListener);
    _controller.pause();

    _controller.dispose();
    super.dispose();
  }

  var _enterMessage = '';
  FocusNode _focusNode = FocusNode();
  final _controllert = TextEditingController();

  Future<void> _sendVideo() async {
    final user = FirebaseAuth.instance.currentUser;
    late Map<String, dynamic> data;

    String? thumbnail = await VideoThumbnail.thumbnailFile(
      video: widget.path!,
      quality: 1,
    );
    data = {
      'idFrom': user!.uid,
      'message': _enterMessage.trim(),
      'idTo': widget.person!.uid,
      'nickname': user.displayName,
      'readed': false,
      "imagePrefFrom": thumbnail,
      "imagePrefTo": "",
      'peerImageUrl': widget.person!.photoUrl!,
      'videoUrl': '',
      'imageUrl': '',
      'videoPrefFrom': widget.path,
      'videoPrefTo': '',
      'localFrom': true,
      'localTo': true,
      'timestamp': Timestamp.now().millisecondsSinceEpoch,
      'createdAt': DateFormat.Hm().format(DateTime.now()),
      'day': DateFormat.MMMMEEEEd().format(DateTime.now()),
      'groupChatId': widget.person!.groupChatId,
      'messageType': 'video',
    };

    Provider.of<Messages2>(context, listen: false)
        .addMessages(data, true, widget.person);
    FocusScope.of(context).unfocus();
    setState(() {
      _controllert.clear();
      _enterMessage = '';
    });
  }

  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  void videoPlayerListener() {
    if (_controller.value.isPlaying != isPlaying.value) {
      isPlaying.value = _controller.value.isPlaying;
    }
  }

  Future<void> playButtonCallback() async {
    if (isPlaying.value) {
      _controller.pause();
    } else {
      if (_controller.value.duration == _controller.value.position) {
        _controller
          ..seekTo(Duration.zero)
          ..play();
      } else {
        _controller.play();
      }
    }
  }

  Widget get playControlButton {
    return ValueListenableBuilder<bool>(
      valueListenable: isPlaying,
      builder: (_, bool value, Widget? child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: value ? playButtonCallback : null,
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: value ? 0.0 : 1.0,
            child: GestureDetector(
              onTap: playButtonCallback,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12)],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  value ? Icons.pause_circle_outline : Icons.play_circle_filled,
                  size: 70.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: TextFormField(
                focusNode: _focusNode,
                onTap: () {},
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _controllert,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                    fillColor: Colors.red,
                    focusColor: Colors.blue,
                    hoverColor: Colors.orange,
                    border: OutlineInputBorder(
                        gapPadding: 2,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    hintText: 'Send Message'),
                onChanged: (val) {
                  setState(() {
                    _enterMessage = val;
                  });
                },
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send,
                  color: _enterMessage.trim().isEmpty
                      ? Colors.grey
                      : Colors.green),
              onPressed: () async {
                await _sendVideo();
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == (widget.pop ? 1 : 2);
                });
              }),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(child: CircularProgressIndicator()),
                ),
                playControlButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
