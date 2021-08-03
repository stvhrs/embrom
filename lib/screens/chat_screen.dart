import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/widgets/chat/messages.dart';
import 'package:flutter_complete_guide/widgets/chat/new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Person? person;

  ChatScreen(
    this.person,
  );
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>  {
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
   
    print('init chat');
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'chattingWith': widget.person!.uid});
  }

  

  @override
  void didChangeDependencies() async {
    if (!widget.person!.messageIsMe!) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.person!.uid!)
          .collection(widget.person!.uid!)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'readed': true,
        'before': 0,
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(widget.person!.uid!)
          .update({'before': 0});
      var col = FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.person!.groupChatId!)
          .collection(widget.person!.groupChatId!)
          .where('idTo', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('readed', isEqualTo: false);

      var querySnapshots = await col.get();
      for (var doc in querySnapshots.docs) {
        // print(doc);
        await doc.reference.update({
          'readed': true,
        });
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
   
    if (widget.person!.messageIsMe == false) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.person!.uid!)
          .collection(widget.person!.uid!)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'before': 0,
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(widget.person!.uid!)
          .update({
        'readed': true,
        'before': 0,
      });
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'chattingWith': null});
    print("Back To old Screen");
    super.dispose();
  }

  Future<bool> willpop(BuildContext contexts) async {
    if (Provider.of<Messages2>(contexts, listen: false).loadingSend == true ||
        Provider.of<Messages2>(contexts, listen: false).loadingReceive ==
            true) {
      bool asu = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure want to quit?'),
          content: Text('Some Process may cancled'),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Quit'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.red.withOpacity(0.5);
                      return Colors.red;
                      // Use the component's default.
                    },
                  ),
                )),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No')),
          ],
        ),
      );
      return asu;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return willpop(context);
        },
        child: Scaffold(
            backgroundColor: Colors.grey.shade900,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.grey.shade800,
              automaticallyImplyLeading: false,
              leadingWidth: 100,
              centerTitle: false,
              leading: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () async {
                        bool pop = await willpop(context);
                        if (pop) Navigator.pop(context);
                      }),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.person!.photoUrl!),
                  ),
                ],
              ),
              title: Text(widget.person!.nickName!),
            ),
            body: Container(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.person!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData&&snapshot.connectionState==ConnectionState.active) {
                        bool asu = ((snapshot.data!.data()!['chattingWith'] ==
                            FirebaseAuth.instance.currentUser!.uid));

                        if (asu == true) {
                          Provider.of<Messages2>(context, listen: false)
                              .updateRead(asu);
                        } else {
                          Provider.of<Messages2>(context, listen: false)
                              .updateUnRead(asu);
                        }
                      }
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data!.data()!['nickname'] !=
                                Person.toMap(widget.person!)['nickname'] ||
                            snapshot.data!.data()!['oneSignal'] !=
                                Person.toMap(widget.person!)['oneSignal'])
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection(
                                  FirebaseAuth.instance.currentUser!.uid)
                              .doc(widget.person!.uid)
                              .update({
                            'oneSignal': snapshot.data!.data()!['oneSignal'],
                            'nickname': snapshot.data!.data()!['nickname'],
                          });
                      }

                      return Column(
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: Provider.of<Messages2>(context,
                                          listen: false)
                                      .hen
                                      .isEmpty
                                  ? null
                                  : FirebaseFirestore.instance
                                      .collection('messages')
                                      .doc(widget.person!.groupChatId)
                                      .collection(widget.person!.groupChatId!)
                                      .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.last
                                              .data()['idFrom'] !=
                                          FirebaseAuth
                                              .instance.currentUser!.uid &&
                                      snapshot.data!.docs.last
                                              .data()['readed'] ==
                                          false) {
                                    Provider.of<Messages2>(context,
                                            listen: false)
                                        .addMessages(
                                      snapshot.data!.docs.last.data(),
                                      false,
                                    );
                                  }
                                }
                                return Expanded(child: Messages());
                              }),
                          NewMessage(widget.person, _focusNode)
                        ],
                      );
                    }),
              ),
            )));
  }
}
