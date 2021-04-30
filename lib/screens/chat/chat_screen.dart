import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/models/Chat.dart';
import 'package:shop_app/screens/chat/chat_head.dart';
import 'package:shop_app/screens/chat/chat_page.dart';
import 'package:shop_app/services/sharedPreferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String uid, name;
  bool isAdmin = false;

  void fun() async {
    String hello = await SharedFunctions.getUserUid();
    bool he = await SharedFunctions.getUserAdminStatus();
    String n = await SharedFunctions.getUserName();

    setState(() {
      if (hello != null) {
        setState(() {
          uid = hello;
          isAdmin = he;
          name = n;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: isAdmin
            ? CustomBottomNavBar(selectedMenu: MenuState.message)
            : Padding(padding: EdgeInsets.zero),
        body: !isAdmin
            ? ChatPage(
                uid: uid,
                name: name,
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .where('hasMessage', isEqualTo: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          List<Widget> listChat = [];

                          final chatHeads = snapshot.data.docs;
                          print(chatHeads.length);

                          for (var chatHead in chatHeads) {
                            Chat chat = Chat(
                                uid: chatHead['uid'],
                                adminUid: chatHead['adminId'],
                                lastMessage: chatHead['lastMessage'],
                                userName: chatHead['userName']);

                            ChatHead chath = ChatHead(
                              chat: chat,
                            );
                            listChat.add(chath);
                          }
                          print('list length:');
                          print(listChat.length);

                          return new ListView.builder(
                              itemCount: listChat.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  child: listChat[index],
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  uid: chatHeads[index]['uid'],
                                                  name: chatHeads[index]
                                                      ['userName'],
                                                )));
                                  },
                                );
                              });
                        },
                      ),
                    ))
                  ],
                ),
              ));
  }
}
