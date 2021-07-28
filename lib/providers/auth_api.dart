import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../models/http_execption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth? _auth = FirebaseAuth.instance;
  final GoogleSignIn? googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    try {
      print('sign in');
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

      //    await GallerySaver.saveImage(user.photoURL!, albumName: 'Embrom2',);
      var status = await OneSignal.shared.getDeviceState();
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'nickname': user.displayName,
        'id': user.uid,
        'photo': user.photoURL,
        'createdAt': Timestamp.now(),
        'chattingWith': null,
        'searchIndex': indexList,
        'oneSignal': status!.userId
      });
      return true;
    } catch (err) {
      throw HttpException(err.toString());
    }
  }

  Future<void> clearPrefs() async {
    await googleSignIn?.signOut();
    await _auth!.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    print('logout');
    notifyListeners();
  }
}
