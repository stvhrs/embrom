// // import 'dart:async';

// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class Utils {
// //   static StreamTransformer transformer<T>(
// //           T Function(Map<String, dynamic> json) fromJson) =>
// //       StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
// //         handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
// //           final snaps = data.docs.map((doc) => doc.data()).toList();
// //           final users = snaps.map((json) => fromJson(json as Map<String,dynamic>)).toList();

// //           sink.add(users);
// //         },
// //       );

 
// // }
// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:math' as math; // import this
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_complete_guide/providers/auth_api.dart';
// // import 'package:flutter_complete_guide/screens/tab_screen.dart';
// // import 'package:gallery_saver/gallery_saver.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class Introduction extends StatefulWidget {
// //   @override
// //   _IntroductionState createState() => _IntroductionState();
// // }

// // class _IntroductionState extends State<Introduction> {
// //   var asu = FirebaseAuth.instance.currentUser;
// //   final _controller = TextEditingController();
// //   var _nickName = '';
// //   File? _pickedImage;

// //   String _imagePath = '';

// //   String defaul = 'assets/embrom.png';
// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedImageGallery = await picker.getImage(
// //       source: ImageSource.gallery,
// //       imageQuality: 10,
// //     );
// //     if (pickedImageGallery == null) {
// //       return;
// //     }
// //     File dariImagePicker = File(pickedImageGallery.path);
// //     Directory appDir = await getApplicationDocumentsDirectory();
   
// //     File honto = await dariImagePicker.copy('${appDir.path}/heyeyeyey.jpg');

// //     await GallerySaver.saveImage(honto.path, albumName: 'Embrom');
// //     setState(() {
// //       _pickedImage = File(pickedImageGallery.path);
// //     });

// //     _imagePath = honto.path;
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     print(MediaQuery.of(context).viewInsets.bottom);

// //     var _width = MediaQuery.of(context).size.width;
// //     var _height =
// //         MediaQuery.of(context).size.height + MediaQuery.of(context).padding.top;
// //     var _theme = Theme.of(context);
// //     return Stack(
// //       children: [
// //         Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [_theme.accentColor, _theme.primaryColor],
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //             ),
// //           ),
// //         ),
// //         Opacity(
// //           opacity: 0.6,
// //           child: Transform(
// //             alignment: Alignment.center,
// //             transform: Matrix4.rotationY(math.pi),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 image: DecorationImage(
// //                   fit: BoxFit.fitWidth,
// //                   image: AssetImage(
// //                     'assets/skolkov.png',
// //                   ),
// //                   colorFilter:
// //                       ColorFilter.mode(Colors.white, BlendMode.modulate),
// //                   alignment: Alignment.topLeft,
// //                 ),
// //                 gradient: LinearGradient(
// //                   colors: [Colors.white, Colors.green.shade600],
// //                   begin: Alignment.topRight,
// //                   end: Alignment.bottomLeft,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //         Container(
// //           margin: EdgeInsets.only(
// //             top: _height * 0.10,
// //           ),
// //           child: SafeArea(
// //             child: Scaffold(
// //               resizeToAvoidBottomInset: true,
// //               backgroundColor: Colors.transparent,
// //               body: ListView(
// //                 physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
// //                 children: [
// //                   Container(
// //                     margin: EdgeInsets.only(
// //                         bottom: _height * 0.05, left: _width * 0.05),
// //                     child: Text('Login',
// //                         style: GoogleFonts.ptSans(
// //                             letterSpacing: 2,
// //                             shadows: [
// //                               BoxShadow(
// //                                 color: _theme.accentColor,
// //                                 spreadRadius: 2,
// //                                 blurRadius: 2,
// //                                 offset:
// //                                     Offset(1, 3), // changes position of shadow
// //                               ),
// //                             ],
// //                             fontSize: 54,
// //                             fontWeight: FontWeight.w600,
// //                             color: Colors.green[50])),
// //                   ),
// //                   Container(
// //                     margin: EdgeInsets.only(right: _width * 0.4, left: 1),
// //                     decoration: BoxDecoration(
// //                       color: _theme.accentColor,
// //                       borderRadius: BorderRadius.only(
// //                         topRight: Radius.circular(20),
// //                       ),
// //                     ),
// //                     child: Text('  Displayed Profile',
// //                         textAlign: TextAlign.start,
// //                         style: GoogleFonts.nunito(
// //                           color: Colors.white,
// //                           fontSize: 25,
// //                         )),
// //                   ),
// //                   Container(
// //                     constraints: BoxConstraints(maxHeight: _height * 0.8),
// //                     decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius:
// //                             BorderRadius.only(topRight: Radius.circular(30))),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       children: [
// //                         Container(
// //                           margin: EdgeInsets.only(top: 25, bottom: 30),
// //                           child: Stack(
// //                             children: [
// //                               _pickedImage == null
// //                                   ? CircleAvatar(
// //                                       radius: 50,
// //                                       backgroundColor: Colors.green.shade200,
// //                                       child: IconButton(
// //                                           color: Colors.white,
// //                                           iconSize: 75,
// //                                           onPressed: _pickImage,
// //                                           icon: Icon(Icons.person)),
// //                                     )
// //                                   : CircleAvatar(
// //                                       radius: 50,
// //                                       backgroundImage: FileImage(_pickedImage!),
// //                                     ),
// //                               Positioned(
// //                                 bottom: -10,
// //                                 right: -10,
// //                                 child: IconButton(
// //                                     alignment: Alignment.center,
// //                                     color: Colors.green,
// //                                     iconSize: 34,
// //                                     onPressed: _pickImage,
// //                                     icon: Icon(Icons.add_circle)),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           width: _width * 0.7,
// //                           child: TextField(
// //                             cursorColor: _theme.primaryColor,
// //                             textInputAction: TextInputAction.done,
// //                             onTap: () {
// //                               print('tapp');
// //                             },
// //                             keyboardType: TextInputType.name,
// //                             controller: _controller,
// //                             style: TextStyle(
// //                               fontSize: 20,
// //                             ),
// //                             decoration: InputDecoration(
// //                               filled: true,
// //                               enabledBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                       color: _theme.accentColor, width: 2),
// //                                   borderRadius:
// //                                       BorderRadius.all(Radius.circular(5))),
// //                               labelText: 'Username',
// //                               contentPadding: EdgeInsets.all(8.4),
// //                             ),
// //                             onChanged: (val) {
// //                               setState(() {
// //                                 _nickName = val;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         Container(
// //                           margin: EdgeInsets.only(top: 10, bottom: 20),
// //                           width: _width * 0.7,
// //                           child: TextField(
// //                             textInputAction: TextInputAction.done,
// //                             onTap: () {
// //                               print('tapp');
// //                             },
// //                             keyboardType: TextInputType.name,
// //                             controller: _controller,
// //                             style: TextStyle(
// //                               fontSize: 20,
// //                             ),
// //                             decoration: InputDecoration(
// //                               filled: true,
// //                               enabledBorder: OutlineInputBorder(
// //                                   borderSide: BorderSide(
// //                                       color: _theme.accentColor, width: 2),
// //                                   borderRadius:
// //                                       BorderRadius.all(Radius.circular(5))),
// //                               focusedBorder: OutlineInputBorder(
// //                                   borderSide:
// //                                       BorderSide(color: _theme.primaryColor),
// //                                   borderRadius:
// //                                       BorderRadius.all(Radius.circular(10))),
// //                               labelText: 'Name (Optional)',
// //                               contentPadding: EdgeInsets.all(8.4),
// //                             ),
// //                             onChanged: (val) {
// //                               setState(() {
// //                                 _nickName = val;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         Container(
// //                           height: _height / 20,
// //                           margin: EdgeInsets.only(top: 20, bottom: 30),
// //                           width: _width * 0.75,
// //                           child: ElevatedButton(
// //                               style: ElevatedButton.styleFrom(
// //                                 primary: _theme.accentColor, // background
// //                                 onPrimary: Colors.white, // foreground
// //                               ),
// //                               child: Text('Continue With Google',
// //                                   style: GoogleFonts.nunito(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w600)),
// //                               onPressed: () async {
// //                                 print('coba2');
// //                                 if (_controller.text == '' ||
// //                                     _controller.text.trim() == '' ||
// //                                     _pickedImage == null) {
// //                                   return null;
// //                                 }
// //                                 print('coba22');
// //                                 Provider.of<AuthProvider>(context,
// //                                         listen: false)
// //                                     .signInWithGoogle(
// //                                         _pickedImage!, _imagePath, _nickName)
// //                                     .then((value) {
// //                                   Navigator.of(context)
// //                                       .pushReplacement(MaterialPageRoute(
// //                                     builder: (context) => TabsScreen(),
// //                                   ));
// //                                 });
// //                               }),
// //                         ),
// //                         CircleAvatar(
// //                           backgroundColor: Colors.white,
// //                           radius: 20,
// //                           backgroundImage: AssetImage('assets/google.png'),
// //                         ),
// //                         Container(
// //                           margin: EdgeInsets.only(top: 30),
// //                           child: Text(
// //                               '*OAuth doesn\'t fetching your credentials*',
// //                               style: TextStyle(
// //                                   fontSize: 15,
// //                                   color: _theme.primaryColor,
// //                                   decoration: TextDecoration.underline)),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_complete_guide/models/people_model.dart';
// import 'package:flutter_complete_guide/providers/messages_data.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:intl/intl.dart';

// class VideoViewPage extends StatefulWidget {
//   const VideoViewPage({this.path, this.person});
//   final String? path;
//   final Person? person;

//   @override
//   _VideoViewPageState createState() => _VideoViewPageState();
// }

// class _VideoViewPageState extends State<VideoViewPage> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(File(widget.path!))
//       ..initialize().then((_) {
//         print(widget.path);
//         _controller.setLooping(true);
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   var _enterMessage = '';
//   FocusNode _focusNode = FocusNode();
//   final _controllert = TextEditingController();

//   Future<void> _sendVideo() async {
//     final user = FirebaseAuth.instance.currentUser;
//     late Map<String, dynamic> data;
//     String messageType = 'video';
//     String? thumbnail = await VideoThumbnail.thumbnailFile(video: widget.path!);
//     data = {
//       'idFrom': user!.uid,
//       'message': _enterMessage.trim(),
//       'idTo': widget.person!.uid,
//       'nickname': user.displayName,
//       'readed': false,
//       "imagePrefFrom": thumbnail,
//       "imagePrefTo": "",
//       'videoUrl': '',
//       'imageUrl': '',
//       'videoPrefFrom': widget.path,
//       'videoPrefTo': '',
//       'localFrom': true,
//       'localTo': true,
//       'timestamp': Timestamp.now().millisecondsSinceEpoch,
//       'createdAt': DateFormat.Hm().format(DateTime.now()),
//       'day': DateFormat.MMMMEEEEd().format(DateTime.now()),
//       'groupId': widget.person!.groupChatId,
//       'messageType': messageType,
//     };
//     Provider.of<Messages2>(context, listen: false).addMessages(data, false);
//     FocusScope.of(context).unfocus();
//     setState(() {
//       _controllert.clear();
//       _enterMessage = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(alignment: Alignment.bottomCenter, children: [
//       Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: Container(
//             decoration: BoxDecoration(),
//             alignment: Alignment.center,
//             width: MediaQuery.of(context).size.width,
//             child: SingleChildScrollView(child: VideoPlayer(_controller)),
//           ),
//         ),
//       ),
//       Scaffold(
//           backgroundColor: Colors.transparent,
//           resizeToAvoidBottomInset: true,
//           body: ListView(
//             reverse: true,
//             children: [
//               Container(
//                   color: Colors.black38,
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                   child: Container(
//                     constraints: BoxConstraints(maxHeight: 170),
//                     margin: EdgeInsets.only(top: 8),
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: TextFormField(
//                             focusNode: _focusNode,
//                             onTap: () {
//                               print('tap');
//                             },
//                             keyboardType: TextInputType.multiline,
//                             maxLines: null,
//                             controller: _controllert,
//                             textInputAction: TextInputAction.newline,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(15))),
//                               labelText: 'Send a message',
//                             ),
//                             onChanged: (val) {
//                               setState(() {
//                                 _enterMessage = val;
//                               });
//                             },
//                           ),
//                         ),
//                         IconButton(
//                             icon: Icon(Icons.send,
//                                 color: _enterMessage.trim().isEmpty
//                                     ? Colors.grey
//                                     : Colors.green),
//                             onPressed: () {
//                               _sendVideo();
//                             }),
//                       ],
//                     ),
//                   )),
//             ],
//           ))
//     ]);
//   }
// }
