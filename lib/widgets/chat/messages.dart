import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/models/message_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble_image_me.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble_image_peer.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble_me.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble_video_me.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble_video_peer.dart';
import 'package:provider/provider.dart';
import 'message_bubble_peer.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController? _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<Messages2>(builder: (context, val, c) {
      print('build list message');
      // if (mounted) {
      //   Timer(Duration(milliseconds: 300), () {
      //     _scrollController!.animateTo(
      //         _scrollController!.position.maxScrollExtent,
      //         duration: Duration(milliseconds: 500),
      //         curve: Curves.ease);
      //   });
      // }
      if (val.hen.isEmpty) {
        return Center(
            child: Text('Empty', style: TextStyle(color: Colors.white)));
      }
      return ListView.separated(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 0),
        itemCount: val.hen.length,
        reverse: true,
        itemBuilder: (context, int index) {
          if (val.hen[index]['messageType'] == 'image' &&
              val.hen[index]['idFrom'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
            return BubbleMeImage(message: Message.fromMap(val.hen[index]));
          }
          if (val.hen[index]['messageType'] == 'chat' &&
              val.hen[index]['idFrom'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
            return MessageBubbleMe(message: Message.fromMap(val.hen[index]));
          }
          if (val.hen[index]['messageType'] == 'chat' &&
              val.hen[index]['idFrom'] !=
                  FirebaseAuth.instance.currentUser!.uid) {
            return MessageBubblePeer(message: Message.fromMap(val.hen[index]));
          }

          if (val.hen[index]['messageType'] == 'image' &&
              val.hen[index]['idFrom'] !=
                  FirebaseAuth.instance.currentUser!.uid) {
            return BubblePeerImage(message: Message.fromMap(val.hen[index]));
          }
          if (val.hen[index]['messageType'] == 'video' &&
              val.hen[index]['idFrom'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
            return BubbleMeVideo(message: Message.fromMap(val.hen[index]));
          }
          if (val.hen[index]['messageType'] == 'video' &&
              val.hen[index]['idFrom'] !=
                  FirebaseAuth.instance.currentUser!.uid) {
            return BubblePeerVIdeo(message: Message.fromMap(val.hen[index]));
          } else {
            return Text('kkk');
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          if (val.hen[index]['day'] != val.hen[index + 1]['day'])
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(30),
              child: Text(
                val.hen[index]['day'],
                style: TextStyle(color: Colors.green),
              ),
            );

          return SizedBox();
        },
      );
    });
  }
}
