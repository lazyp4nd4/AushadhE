import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final String me;
  MessageBubble({this.message, this.me});
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: widget.message.from == widget.me
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 240),
          decoration: BoxDecoration(
            color: widget.message.from == widget.me
                ? Colors.grey[100]
                : kPrimaryColor,
            borderRadius: widget.message.from == widget.me
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment: widget.message.from == widget.me
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.message.message}',
            style: TextStyle(
                color: widget.message.from == widget.me
                    ? Colors.black
                    : Colors.white),
            textAlign: widget.message.from == widget.me
                ? TextAlign.end
                : TextAlign.start,
          ),
        ],
      );
}
