import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/route/custom_route.dart';
import 'package:flutter_complete_guide/screens/display_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BubblePeerImage extends StatefulWidget {
  BubblePeerImage({required this.message});
  final Message message;

  @override
  _BubblePeerImageState createState() => _BubblePeerImageState();
}

class _BubblePeerImageState extends State<BubblePeerImage> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Card(
                shadowColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Color.fromRGBO(76, 175, 80, 1),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: widget.message.localTo! == true
                              ? null
                              : () {
                                  Navigator.of(context).push(CustomRoute2(
                                    builder: (context) => DisplayImage(
                                        widget.message.imagePrefTo!),
                                  ));
                                },
                          child: AspectRatio(
                            aspectRatio: 5 / 5.5,
                            child: Container(
                                margin:
                                    EdgeInsets.only(top: 5, left: 5, right: 5),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: widget.message.localTo! == false
                                        ? Hero(
                                            tag: widget.message.imagePrefTo!,
                                            child: Image.file(
                                              File(widget.message.imagePrefTo!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Hero(
                                                  tag: widget
                                                      .message.imagePrefTo!,
                                                  child: BackdropFilter(
                                                      filter:
                                                          ImageFilter.blur(),
                                                      child: Image.network(
                                                        widget
                                                            .message.imageUrl!,
                                                        fit: BoxFit.cover,
                                                      ))),
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.green,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ))),
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
                          child: SelectableText(
                            widget.message.message.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
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
