import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/screens/display_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MessageBubblePeer extends StatefulWidget {
  MessageBubblePeer({required this.message});
  final Message message;

  @override
  _MessageBubblePeerState createState() => _MessageBubblePeerState();
}

class _MessageBubblePeerState extends State<MessageBubblePeer> {
  

  @override
  Widget build(BuildContext context) {
    return  Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 3,
                    maxWidth: MediaQuery.of(context).size.width - 45,
                  ),
                  child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Color.fromRGBO(76, 175, 80,1),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 30,
                                  top: 5,
                                  bottom: 20,
                                ),
                                child:SelectableText(
                                  widget.message.message.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: 
                                        Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 4,
                              right: 10,
                              child: Text(
                                widget.message.createdAt.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ))));
       
  }
}
