import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_complete_guide/providers/loading.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/route/custom_route.dart';
import 'package:flutter_complete_guide/screens/display_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BubbleMeImage extends StatefulWidget {
  BubbleMeImage({required this.message});
  final Message message;

  @override
  _BubbleMeImageState createState() => _BubbleMeImageState();
}

class _BubbleMeImageState extends State<BubbleMeImage> {
  

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment:
            Alignment.centerRight ,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width / 3,minHeight: 150,
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Color.fromRGBO(35, 35, 35,1),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CustomRoute2(
                                    builder: (context) =>
                                DisplayImage(widget.message.imagePrefFrom!),
                          ));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                                aspectRatio: 5 / 5.5,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 5, left: 5, right: 5),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: Hero(
                                        tag: widget.message.imagePrefFrom!,
                                        child: Image.file(
                                          File(widget.message.imagePrefFrom!),
                                          fit: BoxFit.cover
                                        ),
                                      )),
                                )),
                            widget.message.localFrom == false
                                ? SizedBox()
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                          bottom: 20,
                        ),
                        child: Text(
                          widget.message.message.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
