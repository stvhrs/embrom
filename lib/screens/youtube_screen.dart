import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_complete_guide/models/video_model.dart';

import 'package:flutter_complete_guide/screens/video_screen.dart';
import 'package:flutter_complete_guide/providers/youtube_api.dart';
import 'package:flutter_complete_guide/widgets/splash.dart';
import 'package:flutter_complete_guide/widgets/youtube_widget/youtubeItem.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = false;

  Future _load() async {
    _loading = true;
    if (mounted) {
      await Provider.of<APIService>(context, listen: false)
          .fetchVideosFromPlaylist(
              playlistId: 'PLw1gWHeiDeN4BMrVPKRANEEnXelq1fn6k')
          .then((value) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
    }
    _loading = false;
  }

  late AnimationController _controller;

  Tween<double> _tween = Tween(begin: 0.6, end: 1);
  var _init = true;
  @override
  void didChangeDependencies() {
    if (_init) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      )..repeat(reverse: true);

      _init = false;
    }
    super.didChangeDependencies();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild Youtube');

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Consumer<APIService>(
        builder: (context, value, child) =>
            NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollDetails) {
            if (!_loading &&
                value.listVideos.length < value.items &&
                scrollDetails.metrics.pixels ==
                    scrollDetails.metrics.maxScrollExtent) {
              print(value.listVideos.length);
              print('dari youtube');
              _load();

              if (_loading &&
                  value.listVideos.length < value.items &&
                  scrollDetails.metrics.pixels ==
                      scrollDetails.metrics.maxScrollExtent) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(hours: 1),
                    animation: _tween.animate(CurvedAnimation(
                        parent: _controller, curve: Curves.linear)),
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    content: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        color: Colors.grey.shade800,
                        backgroundColor: Colors.green,
                      ),
                    )));
              }
              return true;
            }
            return false;
          },
          child: Column(
            children: [Text(value.asu,style: TextStyle(color: Colors.red),),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: value.listVideos.length,
                  itemBuilder: (BuildContext context, int index) {
                    Video video = value.listVideos[index];
                    return YoutubeItem(
                      index + 1,
                      video,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
