import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/screens/introduction_screen.dart';
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
      create: (ctx) => Messages2(),
    ),
    ChangeNotifierProxyProvider<Messages2, APIService>(
      update: (context, value, previous) => previous!..update(value),
      create: (ctx) => APIService(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print("ebuild global");
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(76, 175, 80, 1),
        accentColor: Colors.grey,
        primarySwatch: Colors.green,
      ),
      title: 'Embrom',
      debugShowCheckedModeBanner: false,
      home:
          FirebaseAuth.instance.currentUser != null
              ?
          TabsScreen()
      :
      Introduction(),
      
      initialRoute: '/',
    );
  }
}
