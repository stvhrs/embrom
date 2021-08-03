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
   var whichId = '';
    if (map['senderId'] != null || map['senderId'] != '') {
      whichId = map['senderId']??FirebaseAuth.instance.currentUser!.uid;
    } else {
      whichId = map['id'];
    }
    return Person(
        uid: map['id'],
        nickName: map['nickname'],
        photoUrl: map['photo'],
        groupChatId: map['groupChatId'],
        before: map['before'] ?? 0,
        readed: map['readed'] ?? true,
        lastMessage: map['lastMessage'],
        messageIsMe: whichId == FirebaseAuth.instance.currentUser!.uid,
        oneSignal: map['oneSignal'] ?? '');
  }
  static Map<String, dynamic> toMap(Person person) {
    return {
      'id':FirebaseAuth.instance.currentUser!.uid,
      'nickname': FirebaseAuth.instance.currentUser!.displayName,
      'photo':FirebaseAuth.instance.currentUser!.photoURL,
      'groupChatId': person.groupChatId,
      'before': person.before,
      'readed': person.readed,
      'lastMessage': person.lastMessage,
      'messageIsMe': person.messageIsMe,
      'oneSignal': person.oneSignal
    };
  }
}
