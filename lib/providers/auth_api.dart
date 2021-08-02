import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth? _auth = FirebaseAuth.instance;
  final GoogleSignIn? googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await (googleSignIn?.signIn());

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential authResult =
          await _auth!.signInWithCredential(credential);
      final User user = authResult.user!;
      assert(!user.isAnonymous);
      final User currentUser = _auth!.currentUser!;
      assert(currentUser.uid == user.uid);

      List<String> splitList = user.displayName!.split(" ");
      List<String> indexList = [user.displayName!];
      for (int i = 0; i < splitList.length; i++) {
        for (int y = 1; y < splitList[i].length + 1; y++) {
          indexList.add(splitList[i].substring(0, y).toLowerCase());
        }
      }

      var status = await OneSignal.shared.getDeviceState();
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'nickname': user.displayName,
        'id': user.uid,
        'photo': user.photoURL,
        'createdAt': Timestamp.now(),
        'chattingWith': null,
        'searchIndex': indexList,
        'oneSignal': status!.userId,
      });
      var groupChatId;

      var peerId = 'KSgTOKF4kifJqsfIfNuUvnY2JrJ2';
      if (user.uid.hashCode <= peerId.hashCode) {
        groupChatId = '${user.uid}-$peerId';
      } else {
        groupChatId = '$peerId-${user.uid}';
      }
      Map<String, dynamic> data2 = {
        'id': 'KSgTOKF4kifJqsfIfNuUvnY2JrJ2',
        'nickname': 'Steve Harris',
        'groupChatId': groupChatId,
        'createdAt': DateTime.now(),
        'photo':
            'https://lh3.googleusercontent.com/a-/AOh14GjOrDoBKgqPp80UM5t5__HXZxlyN-AK269Br8sh=s96-c',
        'oneSignal': '9d70b8b8-dab0-4df4-ae7c-110a4631f9c9',
        'before': 0,
        'lastMessage': 'Hai, I am Embrom',
        'readed': false,
        'senderId': 'KSgTOKF4kifJqsfIfNuUvnY2JrJ2'
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(user.uid)
          .doc(peerId)
          .set(data2);
      return;
    } catch (err) {}
  }

  Future<void> clearPrefs() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'oneSignal': ''});
    await googleSignIn?.signOut();
    await _auth!.signOut();

    notifyListeners();
  }
}
