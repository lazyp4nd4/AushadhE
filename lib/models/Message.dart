import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from, to, message;
  Timestamp time;
  Message({this.from, this.message, this.time, this.to});
}
