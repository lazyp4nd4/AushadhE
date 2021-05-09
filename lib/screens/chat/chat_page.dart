import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Message.dart';
import 'package:shop_app/screens/chat/chat_box.dart';
import 'package:shop_app/screens/chat/chat_header.dart';
import 'package:shop_app/screens/chat/message_bubble.dart';
import 'package:shop_app/services/sharedPreferences.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  final String name;
  ChatPage({this.uid, this.name});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool isSignedIn = false;

  String message = '';
  String me, notMe;
  String username;

  void fun() async {
    bool isAdmin = await SharedFunctions.getUserAdminStatus();
    String uid = await SharedFunctions.getUserUid();
    if (uid != null) {
      setState(() {
        isSignedIn = true;
      });
    }
    if (isAdmin != null) {
      if (isAdmin) {
        setState(() {
          me = "Admin";
          notMe = "User";
        });
      } else {
        setState(() {
          me = "User";
          notMe = "Admin";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fun();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSignedIn
          ? Column(
              children: [
                ChatHeader(
                  me: me,
                  name: widget.name,
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.uid)
                        .collection('messages')
                        .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text("Loading"));
                      }

                      List<MessageBubble> listMessageBubbles = [];

                      final messages = snapshot.data.docs;
                      print(messages.length);

                      for (var message in messages) {
                        Message msg = Message(
                            from: message['from'],
                            time: message['time'],
                            to: message['to'],
                            message: message['message']);

                        MessageBubble msgBub = MessageBubble(
                          message: msg,
                          me: me,
                        );
                        listMessageBubbles.add(msgBub);
                      }

                      return new ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: listMessageBubbles.length,
                          itemBuilder: (_, index) {
                            return listMessageBubbles[index];
                          });
                    },
                  ),
                )),
                ChatBox(
                  uid: widget.uid,
                )
              ],
            )
          : Center(
              child: Text('Sign In to chat with the Admin!'),
            ),
    );
  }
}
