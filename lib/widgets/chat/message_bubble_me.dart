import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_complete_guide/providers/loading.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/screens/display_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MessageBubbleMe extends StatefulWidget {
  MessageBubbleMe({required this.message});
  final Message message;

  @override
  _MessageBubbleMeState createState() => _MessageBubbleMeState();
}

class _MessageBubbleMeState extends State<MessageBubbleMe> {
 

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width / 3,
             maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color:Color.fromRGBO(35, 35, 35,1),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                          bottom:
                              20,
                        ),
                        child: Text(
                          widget.message.message.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 4,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            widget.message.createdAt.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          widget.message.localFrom == false
                              ? Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: widget.message.readed!
                                      ? Colors.green
                                      : Colors.grey,
                                )
                              : Icon(Icons.av_timer)
                        ],
                      ))
                ]))));
  }
}
