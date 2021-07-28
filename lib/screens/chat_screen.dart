import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/widgets/chat/messages.dart';
import 'package:flutter_complete_guide/widgets/chat/new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  final Person? person;

  ChatScreen([
    this.person,
  ]);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    if (!widget.person!.messageIsMe!) {
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

  @override
  Widget build(BuildContext context) {
    print('build chat');
    return  WillPopScope(
      onWillPop: () async {
        if (Provider.of<Messages2>(context, listen: false).loadingSend ==
                true ||
            Provider.of<Messages2>(context, listen: false).loadingReceive ==
                true) {
          bool asu = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context, true),
                    icon: Icon(Icons.ac_unit)),
                IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: Icon(Icons.ac_unit))
              ],
            ),
          );
          return asu;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,leadingWidth: 100,centerTitle: false,
          leading: Row(
            children: [ IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                    
                  }),CircleAvatar(backgroundImage: NetworkImage(widget.person!.photoUrl!),),
              
            ],
          ),
          title: Text(widget.person!.nickName!),
        ),
        body: Container(
          child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child:Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      Provider.of<Messages2>(context, listen: false).hen.isEmpty
                          ? null
                          : FirebaseFirestore.instance
                              .collection('messages')
                              .doc(widget.person!.groupChatId)
                              .collection(widget.person!.groupChatId!)
                              .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.last.data()['idFrom'] !=
                              FirebaseAuth.instance.currentUser!.uid &&
                          snapshot.data!.docs.last.data()['readed'] == false) {
                        print('incoming message');

                        Provider.of<Messages2>(context, listen: false)
                            .addMessages(
                          snapshot.data!.docs.last.data(),
                          false,
                        );
                      }
                    }

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.person!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot?> snapshot) {
                          print('build cchattingwith');
                          if (snapshot.hasData) {
                            bool asu = ((snapshot.data!.data()
                                    as Map<String, dynamic>)['chattingWith'] ==
                                FirebaseAuth.instance.currentUser!.uid);

                            Provider.of<Messages2>(context, listen: false)
                                .updateRead(asu);
                          }

                          return Expanded(child: Messages());
                        });
                  }),
              NewMessage(widget.person,_focusNode)
            ],
          ),
        ),
      ),
    ));
  }
}
