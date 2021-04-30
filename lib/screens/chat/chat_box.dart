import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Message.dart';
import 'package:shop_app/services/databaseServices.dart';
import 'package:shop_app/services/sharedPreferences.dart';

import '../../constants.dart';

class ChatBox extends StatefulWidget {
  final String uid;
  ChatBox({this.uid});
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _controller = TextEditingController();
  String message = '';
  String me, notMe;

  void fun() async {
    bool isAdmin = await SharedFunctions.getUserAdminStatus();
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

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: kPrimaryLightColor,
                labelText: 'Type your message',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) => setState(() {
                message = value;
              }),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: _controller.text.trim().isEmpty
                ? null
                : () async {
                    Message msg = Message(
                        from: me,
                        to: "Admin",
                        time: Timestamp.fromDate(DateTime.now()),
                        message: _controller.text);
                    await DatabaseServices().sendMessage(msg, widget.uid);
                    setState(() {
                      _controller.clear();
                      message = " ";
                    });
                  },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
