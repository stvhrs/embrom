import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/models/people_model.dart';

import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:flutter_complete_guide/route/custom_route.dart';
import 'package:flutter_complete_guide/screens/search_service.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: CircleAvatar(
            backgroundColor: Colors.green.shade300,
            child: Icon(
              Icons.person_search_rounded,
              color: Colors.white,
              size: 35,
            )),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SearchIndex(),
        )),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              List<Person> tempList = [];
              if (snapshot.hasData) {
                snapshot.data!.docs.forEach((element) {
                  tempList.add(Person.fromMap(element.data()));
                });
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: tempList.length,
                    itemBuilder: (context, index) => buildPeople(
                        index,
                        tempList.reversed.toList()[index],
                        snapshot.data!.docs[index])),
              );
            }),
      ),
    );
  }

  buildPeople(int i, Person person, DocumentSnapshot<Map<String, dynamic>> d) {
    Person person = Person.fromMap(d.data()!);

    return Card(
        child: InkWell(
            splashColor: Colors.green,
            onTap: () async {
              QuerySnapshot<Map<String, dynamic>> asu = await FirebaseFirestore
                  .instance
                  .collection('messages')
                  .doc(person.groupChatId)
                  .collection(person.groupChatId!)
                  .get();
              if (asu.docs.isEmpty || asu.docs.length == 0) {
                Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) => ChatScreen(person),
                    ));
              } else {
                Provider.of<Messages2>(context, listen: false)
                    .fetchMessages(asu);

                Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) => ChatScreen(person),
                    ));
              }
            },
            child: ListTile(
              trailing: Text(DateFormat.Hm().format(
                  DateTime.fromMillisecondsSinceEpoch(
                      (d.data()!['createdAt'] as Timestamp)
                          .millisecondsSinceEpoch))),
              leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: FadeInImage(
                  placeholder: AssetImage('assets/picture.png'),
                  image: NetworkImage(d.data()!['photo']),
                  width: 50,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(d.data()!['nickname']),
              subtitle: person.messageIsMe!
                  ? Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,size: 15,
                          color: person.readed! ? Colors.green : Colors.grey,
                        ),
                        Flexible(
                            child: Text(
                          d.data()!['lastMessage'],
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            d.data()!['lastMessage'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        if (d.data()!['before'] != 0)
                          person.readed!
                              ? SizedBox()
                              : Stack(alignment: Alignment.topCenter,
                                  children: [
                                    CircleAvatar(
                                      radius: 8,
                                    ),
                                   Text(
                                      d.data()!['before'].toString(),
                                      style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,
                                    ) ,
                                  ],
                                )
                      ],
                    ),
              key: ValueKey(i),
            )));
    ;
  }
}
