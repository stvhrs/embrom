import 'dart:convert';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/key/key.dart';

import 'package:flutter_complete_guide/models/video_model.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'www.googleapis.com';
const Map<String, String> headers = {
  HttpHeaders.contentTypeHeader: 'application/json',
};

class APIService with ChangeNotifier {
  String? _nextPageToken ;
  late int items;
  List<Video> listVideos = [];

  // Future<Channel> fetchChannel({String? channelId}) async {
  //   Map<String, String?> parameters = {
  //     'part': 'snippet, contentDetails, statistics',
  //     'id': channelId,
  //     'key': API_KEY,
  //   };
  //   Uri uri = Uri.https(
  //     _baseUrl,
  //     '/youtube/v3/channels',
  //     parameters,
  //   );

  //   // Get Channel
  //   var response = await http.get(uri, headers: headers);
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = json.decode(response.body)['items'][0];
  //     Channel channel = Channel.fromMap(data);
  //     // Fetch first batch of videos from uploads playlist

  //     return channel;
  //   } else {
  //     throw json.decode(response.body);
  //   }
  // }

  Future<void> fetchVideosFromPlaylist({
    required String playlistId,
  }) async {
    print(_nextPageToken);
    Map<String, String?> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'pageToken': _nextPageToken??"",
      'maxResults': '8',
      'key': 'AIzaSyBRnn7ViKwsP_IDRsvqAz_qxVQnZfuLl84',
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    print('playlist fetch');
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'];
      List<dynamic> videosJson = data['items'];
      print(videosJson.length);
      items = data['pageInfo']['totalResults'];
      if (listVideos.length == items) {
        return;
      }
      videosJson.forEach(
        (json) {
          listVideos.add(
            Video.fromMap(
              json['snippet'],
            ),
          );
        },
      );

      notifyListeners();
      return;
    } else {
      throw json.decode(response.body);
    }
  }
}
