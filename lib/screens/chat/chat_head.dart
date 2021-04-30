import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Chat.dart';

class ChatHead extends StatefulWidget {
  final Chat chat;
  ChatHead({this.chat});
  @override
  _ChatHeadState createState() => _ChatHeadState();
}

class _ChatHeadState extends State<ChatHead> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.chat.userName}',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: DateFormat.MMMMEEEEd()
                            .format(widget.chat.lastMessage.toDate()) +
                        "   ",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                    children: [
                      TextSpan(
                          text: DateFormat.jm()
                              .format(widget.chat.lastMessage.toDate()),
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
