import 'dart:convert';
import 'dart:io';

import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/message_model.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:path_provider/path_provider.dart';

class Messages2 with ChangeNotifier {
  bool? readAll;
  List<Map<String, dynamic>> hen = [];
  String asu2 = 'wwkwk';
  bool loadingSend = false;
  bool loadingReceive = false;
  fetchMessages(QuerySnapshot<Map<String, dynamic>> messages) {
    print('Fetch Messages');

    hen = [];
    if (messages.docs.isNotEmpty)
      messages.docs.forEach((element) {
        var data = element.data();

        addMessages(
          data,
          false,
        );
      });
  }

  updateStatus(Map<String, dynamic> message) {
    print('updateStatus');

    if (message['idFrom'] == FirebaseAuth.instance.currentUser!.uid) {
      var target = hen.firstWhere((element) =>
          element['timestamp'] == message['timestamp'] &&
          element['localFrom'] == true);

      target['localFrom'] = false;
      notifyListeners();
    }

    if (message['idFrom'] != FirebaseAuth.instance.currentUser!.uid) {
      var target = hen.firstWhere((element) =>
          element['timestamp'] == message['timestamp'] &&
          element['localTo'] == true);
      target['localTo'] = false;
      target['imagePrefTo'] = message['imagePrefTo'];
      target['videoPrefTo'] = message['videoPrefTo'];
      notifyListeners();
    }
  }

  Future<void> send(Message message, Person person) async {
    List before = [];
    hen.forEach((element) {
      if (element['readed'] == false) {
        before.add(element);
      }
    });

    if (message.localFrom == true && message.isMe!) {
      loadingSend = true;
      var data = {
        'idFrom': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': message.createdAt,
        'day': message.day,
        'message': message.message,
        'idTo': message.idTo,
        'nickname': message.idTo,
        'readed': false,
        'peerImageUrl': message.peerImageUrl,
        'videoPrefFrom': message.videoPrefFrom,
        'videoPrefTo': message.videoPrefTo,
        "imagePrefFrom": message.imagePrefFrom,
        "imagePrefTo": message.imagePrefTo,
        'videoUrl': message.videoUrl,
        'imageUrl': message.imageUrl,
        'timestamp': message.timestamp,
        'groupChatId': message.groupId,
        'messageType': message.messageType,
        'localFrom': false,
        'localTo': true,
        'before': before.length
      };
//Send Image
      if (message.messageType == 'image') {
        print('send image');
        Directory appDocDir = await getApplicationDocumentsDirectory();
        final ref = FirebaseStorage.instance
            .ref()
            .child(message.groupId!)
            .child(data['timestamp'].toString() + '.jpg');
        await ref.putFile(File(message.imagePrefFrom!));
        File _pickedFilePath = File(message.imagePrefFrom!);
        File downloadToFile = await _pickedFilePath
            .copy('${appDocDir.path}/${data['timestamp']}.jpg');
        // await ref.writeToFile(downloadToFile);
        //  await GallerySaver.saveImage(downloadToFile.path, albumName: 'Embrom2');

        data["imageUrl"] = await ref.getDownloadURL();

        data["imagePrefFrom"] = downloadToFile.path;
      }

//Send Video
      if (message.messageType == 'video') {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        print('messageType Video');
        //Thumbnail
        File _pickedFilePath = File(message.imagePrefFrom!);

        File downloadToFile = await _pickedFilePath
            .copy('${appDocDir.path}/${data['timestamp']}.jpg');

        final ref = FirebaseStorage.instance
            .ref()
            .child(message.groupId!)
            .child(data['timestamp'].toString() + '.jpg');
        await ref.putFile(File(message.imagePrefFrom!));

        //Video
        File _pickedFilePathVideo = File(message.videoPrefFrom!);

        File downloadToFileVideo = _pickedFilePathVideo;
        // .copy('${appDocDir.path}/${data['timestamp']}.mp4');

        final refVideo = FirebaseStorage.instance
            .ref()
            .child(message.groupId!)
            .child('video' + data['timestamp'].toString() + '.mp4');

        await refVideo.putFile(
          File(message.videoPrefFrom!),
        );

        data["imagePrefFrom"] = downloadToFile.path;
        data["videoPrefFrom"] = downloadToFileVideo.path;
        data["imageUrl"] = await ref.getDownloadURL();
        data["videoUrl"] = await refVideo.getDownloadURL();
      }

      if (hen.length == 1) {
        var myOneSignal = await OneSignal.shared.getDeviceState();
        var groupChatId;
        User? user = FirebaseAuth.instance.currentUser;
        var peerId = message.idTo;
        if (user!.uid.hashCode <= peerId.hashCode) {
          groupChatId = '${user.uid}-$peerId';
        } else {
          groupChatId = '$peerId-${user.uid}';
        }
        data['groupChatId'] = groupChatId;
        Map<String, dynamic> data2 = {
          'id': person.uid,
          'nickname': person.nickName,
          'senderId': user.uid,
          'groupChatId': groupChatId,
          'createdAt': DateTime.now(),
          'photo': person.photoUrl,
          'oneSignal': person.oneSignal,
          'before': before.length,
          'lastMessage': message.message,
          'readed': false
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection(user.uid)
            .doc(peerId)
            .set(data2);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(peerId)
            .collection(peerId!)
            .doc(user.uid)
            .set({
          'id': user.uid,
          'nickname': user.displayName,
          'groupChatId': groupChatId,
          'createdAt': DateTime.now(),
          'photo': user.photoURL,
          'oneSignal': myOneSignal!.userId,
          'before': before.length,
          'lastMessage': message.message,
          'readed': false,
          'senderId': user.uid,
        });

        await FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .doc(message.timestamp.toString())
            .set(data)
            .then((value) {
              loadingSend = false;
          updateStatus(data);
        });
      } else {
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(message.groupId)
            .collection(message.groupId!)
            .doc(message.timestamp.toString())
            .set(data)
            .then((value) {
          updateStatus(data);
          loadingSend = false;
         
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(message.idTo)
            .collection(message.idTo!)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'createdAt': DateTime.now(),
          //  'oneSignal': myOneSignal!.userId,
          'before': before.length,
          'readed': false,
          'lastMessage': message.message,
          'senderId': FirebaseAuth.instance.currentUser!.uid
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .doc(message.idTo!)
            .update({
          'createdAt': DateTime.now(),
          //   'oneSignal': person.oneSignal,
          'before': before.length,
          'readed': false,
          'lastMessage': message.message,
          'senderId': FirebaseAuth.instance.currentUser!.uid
        });
      }
      var notification = Message.fromMap(data);
      sendNotification(notification, person);
    }
    before.clear();
  }

  addMessages(Map<String, dynamic> message, bool? notif,
      [Person? person]) async {
    asu2 = message['message'];
    Message temp = Message.fromMap(message);

    print('add message');
    if (hen.every((element) => element['timestamp'] != temp.timestamp)) {
      print(readAll);
      if (readAll == true) {
        print('readAlltrue');
        message['readed'] = true;
      }
      //    log(temp.docId!);
      hen.insert(0, message);
      if (notif!) notifyListeners();

      if (message['localFrom'] == true) await send(temp, person!);

      if (!temp.isMe! && message['localTo'] == true) await receviced(temp);
    } else {
      return;
    }
  }

  updateRead(bool id) {
    print('update Read');
    if (id) {
      readAll = true;
      hen.every((element) => element['readed'] = true);
      // notifyListeners();
    }
  }

  updateUnRead(bool id) {
    print('unread');
    if (!id) readAll = false;
  }

  Future<Response> sendNotification(
    Message message,
    Person person,
  ) async {
    var data = Person.toMap(person);
    // var status = await OneSignal.shared.getDeviceState();
    // // OneSignal.shared.postNotificationWithJson(json)
    // String? tokenId = status!.userId;
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": 'b157051e-b42d-463e-bcf7-982a2d7e05ee',

        'big_picture': message.imageUrl, 'data': data,
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": [
          person.oneSignal
        ], //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon": FirebaseAuth.instance.currentUser!.photoURL,

        "headings": {"en": FirebaseAuth.instance.currentUser!.displayName},

        "contents": {
          "en": message.messageType != 'chat'
              ? 'Media: ' + message.message!
              : ': ' + message.message!
        },
      }),
    );
  }

  Future<void> receviced(Message message) async {
    var data = {
      'idFrom': message.idFrom,
      'createdAt': DateFormat.Hm().format(DateTime.now()),
      'day': DateFormat.MMMMEEEEd().format(DateTime.now()),
      'message': message.message,
      'idTo': message.idTo,
      'nickname': message.idTo,
      'peerImageUrl': message.peerImageUrl,
      'readed': false,
      "imagePrefFrom": message.imagePrefFrom,
      "imagePrefTo": message.imagePrefTo,
      'videoUrl': message.videoUrl,
      'imageUrl': message.imageUrl,
      'videoPrefFrom': message.videoPrefFrom,
      'videoPrefTo': message.videoPrefTo,
      'timestamp': message.timestamp,
      'groupChatId': message.groupId,
      'messageType': message.messageType,
      'localFrom': false,
      'localTo': true,
    };

    if (message.isMe == false && message.localTo == true) {
      print('recived message');
      loadingReceive = true;
      if (message.messageType == 'image') {
        Directory appDocDir = await getApplicationDocumentsDirectory();

        final ref = FirebaseStorage.instance
            .ref()
            .child(message.groupId!)
            .child(message.timestamp.toString() + '.jpg');

        File downloadToFile =
            File('${appDocDir.path}/${message.timestamp}.jpg');
        await ref.writeToFile(downloadToFile);
        await GallerySaver.saveImage(downloadToFile.path, albumName: 'Embrom');

        data['imagePrefTo'] = downloadToFile.path;
      }

      if (message.messageType == 'video') {
        Directory appDocDir = await getApplicationDocumentsDirectory();

// Recieve Thumbnail
        final ref = FirebaseStorage.instance
            .ref()
            .child(message.groupId!)
            .child(message.timestamp.toString() + '.jpg');

        File downloadToFile =
            File('${appDocDir.path}/${message.timestamp}.jpg');
        await ref.writeToFile(downloadToFile);
        data['imagePrefTo'] = downloadToFile.path;

// Recieve Video
        final refVideo = FirebaseStorage.instance
            .ref()
            .child(message.groupId!)
            .child('video' + message.timestamp.toString() + '.mp4');

        File downloadToFileVideo =
            File('${appDocDir.path}/${message.timestamp}.mp4');
        await refVideo.writeToFile(downloadToFileVideo);
        await GallerySaver.saveVideo(downloadToFileVideo.path,
            albumName: 'Embrom');
        data['videoPrefTo'] = downloadToFileVideo.path;
      }

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(message.groupId)
          .collection(message.groupId!)
          .doc(message.timestamp!.toString())
          .update(
        {
          'localTo': false,
          'imagePrefTo': data['imagePrefTo'],
          'videoPrefTo': data['videoPrefTo']
        },
      ).then((_) {
        updateStatus(data);
        loadingReceive = false;
        notifyListeners();
      });
    }
  }
}
