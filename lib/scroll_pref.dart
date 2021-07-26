// import 'dart:async';
// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_complete_guide/models/message_model.dart';
// import 'package:flutter_complete_guide/providers/messages_data.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import './message_bubble.dart';
// import 'package:grouped_list/grouped_list.dart';

// class Messages extends StatefulWidget {
//   final String? groupChatId;

//   Messages(this.groupChatId);

//   @override
//   _MessagesState createState() => _MessagesState();
// }

// class _MessagesState extends State<Messages> with WidgetsBindingObserver {
//   ScrollController? _scrollController;
//   SharedPreferences? _sharedPreferences;

//   Future<void> resumeController() async {
//     _sharedPreferences =
//         await SharedPreferences.getInstance().then((_sharedPreferences) {
//       if (_sharedPreferences.getKeys().contains("scroll-offset-0"))
//         _scrollController = ScrollController(
//             initialScrollOffset:
//                 _sharedPreferences.getDouble("scroll-offset-0")!);
//       else
//         _sharedPreferences.setDouble("scroll-offset-0", 1000);
//       setState(() {});
//       return _sharedPreferences;
//     });
//   }

//   @override
//   void initState() {
   
//     resumeController();
//     WidgetsBinding.instance!.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     print('didsp');
//     WidgetsBinding.instance!.removeObserver(this);
//     _sharedPreferences!.setDouble("scroll-offset-0", _scrollController!.offset);
//     _scrollController!.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.detached)
//       _sharedPreferences!
//           .setDouble("scroll-offset-0", _scrollController!.offset);
//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Smart Scroll View"),
//         ),
//         body: ListView.builder(
//           itemCount: 50,
//           controller: _scrollController,
//           itemBuilder: (c, i) {
//             print(_scrollController!.offset);
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//               child: Text((i + 1).toString()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
