import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/auth_api.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/providers/youtube_api.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:flutter_complete_guide/screens/introduction_screen.dart';
import 'package:flutter_complete_guide/screens/people_screen.dart';
import 'package:flutter_complete_guide/screens/youtube_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tab';

  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen>
// with AutomaticKeepAliveClientMixin
{
  int _selectedPageIndex = 0;
  PageController? _pageController;
  Future<void> initPlatformState() async {
    if (!mounted) return;

    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      log('NOTIFICATION OPENED HANDLER CALLED WITH: ${result.notification.additionalData!}');
      Person person = Person.fromMap(result.notification.additionalData!);
      QuerySnapshot<Map<String, dynamic>> asu = await FirebaseFirestore.instance
          .collection('messages')
          .doc(person.groupChatId)
          .collection(person.groupChatId!)
          .get();

      Provider.of<Messages2>(context, listen: false).fetchMessages(asu);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(person),
          ));
    });

 
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    Provider.of<APIService>(context, listen: false).fetchVideosFromPlaylist(
        playlistId: 'PLw1gWHeiDeN4BMrVPKRANEEnXelq1fn6k');
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.grey.shade900,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  foregroundColor: Colors.red,
                  leading: CircleAvatar(
                      radius: 22,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/embrom.png'),
                      )),
                  actions: [
                    Text('Logout'),
                    Consumer<AuthProvider>(
                        builder: (context, auth, _) => IconButton(
                            tooltip: 'Logout',
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              await auth.clearPrefs().then((value) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Introduction()),
                                );
                              });
                            })),
                  ],
                  snap: true,
                  floating: true,
                  toolbarHeight: 45,
                  expandedHeight: 120,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(60),
                    child: TabBar(
                      indicatorColor: Colors.green,
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(fontSize: 20),
                      unselectedLabelStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15, left: 0),
                          child: Text(
                            'CHATS',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child:
                                Text('YOUTUBE', style: TextStyle(fontSize: 20)))
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                
                ChatRooms(),
                HomeScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //@override
//  bool get wantKeepAlive => true;
}
