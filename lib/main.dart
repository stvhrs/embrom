import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/route/custom_route.dart';

import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:flutter_complete_guide/screens/display_image.dart';
import 'package:flutter_complete_guide/screens/image_view.dart';
import 'package:flutter_complete_guide/screens/introduction_screen.dart';
import 'package:flutter_complete_guide/screens/people_screen.dart';

import 'package:flutter_complete_guide/screens/video_screen.dart';
import 'package:flutter_complete_guide/screens/video_view.dart';
import 'package:flutter_complete_guide/screens/youtube_screen.dart';
import 'package:flutter_complete_guide/screens/display_video.dart';
import 'package:flutter_complete_guide/screens/tab_screen.dart';
import 'package:flutter_complete_guide/providers/youtube_api.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/auth_api.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.grey.shade900));
  WidgetsFlutterBinding.ensureInitialized();
  await OneSignal.shared.setAppId("b157051e-b42d-463e-bcf7-982a2d7e05ee");
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  //cameras = await availableCameras();

  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  //cameras = await availableCameras();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (ctx) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => APIService(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Messages2(),
    ),
   
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    print(state == AppLifecycleState.inactive);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(76, 175, 80, 1),
        accentColor: Colors.grey,
        primarySwatch: Colors.green,
      ),
      title: 'Embrom',
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? TabsScreen()
          : Introduction(),
      initialRoute: '/',
    );
  }
}
