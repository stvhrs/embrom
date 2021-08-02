import 'dart:io';

import 'dart:ui';

import 'package:flutter_complete_guide/route/custom_route.dart';

import 'package:flutter_complete_guide/screens/display_video.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';


class BubblePeerVIdeo extends StatefulWidget {
  BubblePeerVIdeo({required this.message});
  final Message message;

  @override
  _BubblePeerVIdeoState createState() => _BubblePeerVIdeoState();
}

class _BubblePeerVIdeoState extends State<BubblePeerVIdeo> {
  @override
  Widget build(BuildContext context) {
    print('peervideo');
    return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width / 3,
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Color.fromRGBO(76, 175, 80, 1),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          var downloaded = widget.message.localTo!;
                          var pickedFile = widget.message.localTo!
                              ? widget.message.videoUrl!
                              : widget.message.videoPrefTo!;
                          var thumbnailPath = widget.message.localTo!
                              ? widget.message.imageUrl!
                              : widget.message.imagePrefTo!;

                          Navigator.of(context).push(CustomRoute2(
                              builder: (context) => DisplayVIdeo(
                                  pickedFile, downloaded, thumbnailPath,widget.message.timestamp.toString())));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                  margin: EdgeInsets.only(
                                      top: 5, left: 5, right: 5),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: Hero(
                                        tag: widget.message.timestamp.toString(),
                                        child: widget.message.localTo == false
                                            ? Image.file(
                                                File(widget
                                                    .message.imagePrefTo!),
                                                fit: BoxFit.cover,
                                              )
                                            : FittedBox(
                                                fit: BoxFit.cover,
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      widget.message.imageUrl!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned.fill(
                                                      child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: Container(
                                                            color: Colors.black
                                                                .withOpacity(0),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      )),
                                ),
                            Positioned.fill(
                                child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            )),
                            widget.message.localTo == false
                                ? SizedBox()
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                      color: Colors.white,
                                    ),
                                  )
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
                      child: Row(
                        children: [
                          Text(
                            widget.message.createdAt.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ))
                ]))));
  }
}
