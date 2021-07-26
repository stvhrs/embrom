// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart' as pref;

// Future<void> addMessages(Map<String, dynamic> message) async {
//   var prefs = await pref.SharedPreferences.getInstance();
//   String grouKey = message['groupId'];
//   List<dynamic> extractedDta = await json.decode(prefs.getString(grouKey)!);
//   extractedDta.add(message);
//   prefs.setString('data', json.encode(extractedDta));
// }

// Future<void> updateListPerson(Map person) async {
//   var prefs = await pref.SharedPreferences.getInstance();
//   List<dynamic> ex = await json.decode(prefs.getString('data')!);
//   ex.removeWhere((element) => element == person);
//   ex.add(person);
//   prefs.setString('data', json.encode(ex));
// }
