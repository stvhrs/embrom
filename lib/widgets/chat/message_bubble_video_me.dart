import 'dart:io';

import 'package:flutter_complete_guide/route/custom_route.dart';

import 'package:flutter_complete_guide/screens/display_video.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';

class BubbleMeVideo extends StatefulWidget {
  BubbleMeVideo({required this.message});
  final Message message;

  @override
  _BubbleMeVideoState createState() => _BubbleMeVideoState();
}

class _BubbleMeVideoState extends State<BubbleMeVideo> {
  
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
                color:Colors.grey.shade800,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(widget.message.videoPrefFrom!);
                          Navigator.of(context).push(CustomRoute2(
                                    builder: (context) => DisplayVIdeo(                          
                            widget.message.videoPrefFrom!,  false,
                              widget.message.imagePrefFrom!,widget.message.timestamp.toString()
                            ),
                          ));
                        },
                        child: Stack(
                          children: [
                            Container(
                                  margin: EdgeInsets.only(
                                      top: 5, left: 5, right: 5),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: Hero(
                                        tag: widget.message.timestamp.toString(),
                                        child: Image.file(
                                          File(widget.message.imagePrefFrom!),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),Positioned.fill(
                                    child:Icon(Icons.play_arrow,color: Colors.white,)),
                            widget.message.localFrom == false
                                ? SizedBox()
                                : Positioned.fill(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                        color: Colors.white,
                                      ),
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
                         SelectableText(
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
                              :  Icon(Icons.av_timer,color: 
                              Colors.grey,)
                                        
                                
                        ],
                      ))
                ]))));
  }
}
