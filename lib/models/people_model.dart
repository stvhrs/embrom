import 'package:firebase_auth/firebase_auth.dart';

class Person {
  String? uid;
  String? nickName;
  String? photoUrl;
  String? groupChatId;
  String? oneSignal;
  String? lastMessage;
  bool? readed;
  int? before;
  bool? messageIsMe;

  Person(
      {this.uid,
      this.nickName,
      this.before,
      this.lastMessage,
      this.readed,
      this.messageIsMe,
      this.photoUrl,
      this.groupChatId,
      this.oneSignal});
  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
        uid: map['id'],
        nickName: map['nickname'],
        photoUrl: map['photo'],
        groupChatId: map['groupChatId'],
        before: map['before'],
        readed: map['readed'],
        lastMessage: map['lastMessage'],
        messageIsMe: map['senderId'] == FirebaseAuth.instance.currentUser!.uid,
        oneSignal: map['oneSignal']);
  }
  static Map<String, dynamic> toMap(Person person) {
    return {
      'id': person.uid,
      'nickName': person.nickName,
      'photoUrl': person.photoUrl,
      'groupChatId': person.groupChatId,
      'before': person.before,
      'readed': person.readed,
      'lastMessage': person.lastMessage,
      'messageIsMe': person.messageIsMe,
      'oneSignal': person.oneSignal
    };
  }
}
