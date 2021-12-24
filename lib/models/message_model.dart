import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Message {
  Message(
      {this.message,
      this.docId,
  this.isMe,
       this.readed,
      this.messageType,
      this.idTo,
      this.imageUrl,
      this.videoUrl,
      this.groupId,
      this.createdAt,
      this.imagePrefTo,
     this.imagePrefFrom,
      this.localFrom,
      this.localTo,
      this.timestamp,
      this.videoPrefFrom,
    this.peerImageUrl,this.idFrom,
      this.videoPrefTo,
     this.day});

   String? message;
  bool? isMe;
  bool ?readed;
  String? docId;
   String? idFrom;
  String? messageType;
  String? imageUrl;
   String? videoUrl;
   String? groupId;
   String? idTo;
   String? createdAt;
   String? day;
  String ?imagePrefFrom;
  String? imagePrefTo;
  String? videoPrefFrom;
  String? videoPrefTo;
   String ?peerImageUrl;
  bool? localFrom;
  bool? localTo;
  int? timestamp;

  factory Message.fromMap(Map<String, dynamic> snippet, ) {
    return Message(
        isMe: snippet['idFrom'] == FirebaseAuth.instance.currentUser!.uid,
        readed: snippet['readed'] ?? false,
        groupId: snippet['groupChatId'],
        idTo: snippet['idTo'],
        imageUrl: snippet['imageUrl'],
      
        peerImageUrl: snippet['peerImageUrl'],
        message: snippet['message'],
        messageType: snippet['messageType'],
        videoUrl: snippet['videoUrl'],
        createdAt: snippet['createdAt'],
        localFrom: snippet['localFrom'],
        videoPrefFrom: snippet['videoPrefFrom'],
        videoPrefTo: snippet['videoPrefTo'],
        imagePrefTo: snippet['imagePrefTo'],
        imagePrefFrom: snippet['imagePrefFrom'],
        localTo: snippet['localTo'],idFrom: snippet['idFrom'],
        day: snippet['day'],
        timestamp: int.parse(snippet['timestamp'].toString()) );
  }
  static Map<String,dynamic> toMap(Message message) {
    return {
      
      'idFrom':message.idFrom,
      'createdAt': DateFormat.Hm().format(DateTime.now()),
      'day': DateFormat.MMMMEEEEd().format(DateTime.now()),
      'message': message.message,
      'idTo':  message.idTo,
      'nickname': message.idTo,
      'peerImageUrl': message.peerImageUrl,
      'readed': message.readed,
      "imagePrefFrom": message.imagePrefFrom,
      "imagePrefTo": message.imagePrefTo,
      'videoUrl': message.videoUrl,
      'imageUrl': message.imageUrl,
      'videoPrefFrom': message.videoPrefFrom,
      'videoPrefTo': message.videoPrefTo,
      'timestamp': message.timestamp,
      'groupChatId': message.groupId,
      'messageType': message.messageType,
      'localFrom': message.localFrom,
      'localTo': message.localTo,
    };
  }
  
}