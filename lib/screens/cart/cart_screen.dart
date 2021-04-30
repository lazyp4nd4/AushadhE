import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/services/sharedPreferences.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int items;
  int total;
  String uid;

  void fun() async {
    String hello = await SharedFunctions.getUserUid();
    if (hello != null) {
      setState(() {
        uid = hello;
      });
    }
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        total = value['cartTotal'];
        print(total);
        items = value['cartTotalItems'];
      });
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
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: CheckoutCard(total: total, uid: uid),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "$items items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
