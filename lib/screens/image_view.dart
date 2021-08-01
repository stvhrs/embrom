import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ImageView extends StatefulWidget {
  
  const ImageView({this.path, this.person,  this.pop});
  final String? path;
  final Person? person;
  final bool? pop;
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  FocusNode _focusNode = FocusNode();
  final _controller = TextEditingController();
  var _enterMessage = '';

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser!;
    late Map<String, dynamic> data;
    data = {
      'idFrom': user.uid,
      'message': _enterMessage.trim(),
      'idTo': widget.person!.uid,
      'nickname': user.displayName,
      'readed': false,
      'imageUrl': '',
      'peerImageUrl': widget.person!.photoUrl!,
      "imagePrefFrom": widget.path,
      "imagePrefTo": "",
      'videoUrl': '',
      'videoPrefFrom': '',
      'videoPrefTo': '',
      'localFrom': true,
      'localTo': true,
      'timestamp': Timestamp.now().millisecondsSinceEpoch,
      'createdAt': DateFormat.Hm().format(DateTime.now()),
      'day': DateFormat.MMMMEEEEd().format(DateTime.now()),
      'groupChatId': widget.person!.groupChatId,
      'messageType': 'image',
    };

    Provider.of<Messages2>(context, listen: false)
        .addMessages(data, true, widget.person);

    FocusScope.of(context).unfocus();
    setState(() {
      _controller.clear();
      _enterMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fitWidth,image: FileImage(File(widget.path!)
              
              ))),
        ),
        Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
                    controller: _controller,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                        fillColor: Colors.red,
                        focusColor: Colors.blue,
                        hoverColor: Colors.orange,
                        border: OutlineInputBorder(
                            gapPadding: 2,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                    await _sendMessage();
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                      return count++ == (widget.pop==true ? 1 : 2);
                    });
                  }),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
