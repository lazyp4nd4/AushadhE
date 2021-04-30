import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String uid, adminUid, userName;
  Timestamp lastMessage;
  bool hasMessage;

  Chat({
    this.uid,
    this.adminUid,
    this.lastMessage,
    this.hasMessage,
    this.userName,
  });
}
