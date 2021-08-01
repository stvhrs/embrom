import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class SearchIndex extends StatefulWidget {
  static const routeName = '/SI';
  @override
  _SearchIndexState createState() => _SearchIndexState();
}

class _SearchIndexState extends State<SearchIndex> {
  TextEditingController? _addNameController;
  String? searchString = '';
  var focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _addNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                width: 270,
                height: 30,
                child: TextFormField(
                  cursorColor: Colors.white,
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    focusNode.unfocus();
                  },
                  keyboardType: TextInputType.name,
                  controller: _addNameController,
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      hoverColor: Colors.white,
                      contentPadding: EdgeInsets.all(1),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      suffixStyle: TextStyle(color: Colors.white),
                      hintText: 'Search Name',
                      counterStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: (searchString == null || searchString!.trim() == "")
              ? FirebaseFirestore.instance
                  .collection('users')
                  .where("id",
                      isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .limit(15)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('users')
                  // .where("id",
                  //     isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where("searchIndex", arrayContains: searchString!)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  Spacer(),
                  Text(
                    'Searching $searchString...',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer()
                ],
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No result',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => snapshot.data!.docs[index]
                          .data()['id'] !=
                      FirebaseAuth.instance.currentUser!.uid
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            Person person = Person.fromMap(
                                snapshot.data!.docs[index].data());

                            var groupChatId;
                            String myUid =
                                FirebaseAuth.instance.currentUser!.uid;
                            var peerId = snapshot.data!.docs[index]['id'];
                            if (myUid.hashCode <= peerId.hashCode) {
                              groupChatId = '$myUid-$peerId';
                            } else {
                              groupChatId = '$peerId-$myUid';
                            }

                            person.groupChatId = groupChatId;
                            QuerySnapshot<Map<String, dynamic>> asu =
                                await FirebaseFirestore.instance
                                    .collection('messages')
                                    .doc(person.groupChatId)
                                    .collection(person.groupChatId!)
                                    .get();
                            if (asu.docs.isEmpty || asu.docs.length == 0) {
                              Provider.of<Messages2>(context, listen: false)
                                  .fetchMessages(asu);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(person),
                                  ));
                            } else {
                              Provider.of<Messages2>(context, listen: false)
                                  .fetchMessages(asu);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(person),
                                  ));
                            }
                          },
                          child: ListTile(
                            title: Text(
                              snapshot.data!.docs[index]['nickname'],
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['photo']),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        )
                      ],
                    )
                  : SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
