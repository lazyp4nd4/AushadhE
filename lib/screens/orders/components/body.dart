import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Order.dart';
import 'package:shop_app/screens/orders/components/order_card.dart';
import 'package:shop_app/screens/orders/components/order_detail.dart';
import 'package:shop_app/services/sharedPreferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String uid;
  bool isSignedIn = false;
  bool isAdmin = false;
  void fun() async {
    bool admin = false;
    String hello = await SharedFunctions.getUserUid();
    admin = await SharedFunctions.getUserAdminStatus();
    if (hello != null) {
      setState(() {
        uid = hello;
        isSignedIn = true;
      });
    }
    if (admin != null) {
      if (admin) {
        setState(() {
          isAdmin = true;
        });
      } else {
        setState(() {
          isAdmin = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSignedIn
          ? Column(
              children: [
                isAdmin == false
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('uid', isEqualTo: uid)
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

                            if (!snapshot.hasData || snapshot.data == null) {
                              return Text(
                                  'Nothing ordered yet!\nPLease explore products to find something for yourself.');
                            } else {
                              final orderItems = snapshot.data.docs;
                              print(orderItems.length);
                              List<Order> orderList = [];
                              for (var orderItem in orderItems) {
                                Order order = Order(
                                    uid: orderItem['uid'],
                                    orderId: orderItem['orderId'],
                                    numberOfItems: orderItem['numberOfItems'],
                                    products: orderItem['products'],
                                    status: orderItem['status'],
                                    orderNumber: orderItem['orderNumber'],
                                    amount: orderItem['amount']);

                                orderList.add(order);
                              }
                              print("orderList length: ");
                              print(orderList.length);
                              return new ListView.builder(
                                  itemCount: orderList.length,
                                  itemBuilder: (_, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetails(
                                                        isAdmin: isAdmin,
                                                        order: orderList[index],
                                                      )));
                                        },
                                        child: OrderCard(
                                          order: orderList[index],
                                        ));
                                  });
                            }
                          },
                        ),
                      )
                    : Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('status', isNotEqualTo: "Delivered")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: SpinKitFadingCircle(
                                  color: kPrimaryColor,
                                  size: 100,
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return Text('No Orders!');
                            } else {
                              final orderItems = snapshot.data.docs;
                              print(orderItems.length);
                              List<Order> orderList = [];
                              for (var orderItem in orderItems) {
                                Order order = Order(
                                    uid: orderItem['uid'],
                                    orderId: orderItem['orderId'],
                                    numberOfItems: orderItem['numberOfItems'],
                                    products: orderItem['products'],
                                    status: orderItem['status'],
                                    orderNumber: orderItem['orderNumber'],
                                    amount: orderItem['amount']);

                                orderList.add(order);
                              }
                              print("orderList length: ");
                              print(orderList.length);
                              return new ListView.builder(
                                  itemCount: orderList.length,
                                  itemBuilder: (_, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetails(
                                                        isAdmin: isAdmin,
                                                        order: orderList[index],
                                                      )));
                                        },
                                        child: OrderCard(
                                          order: orderList[index],
                                        ));
                                  });
                            }
                          },
                        ),
                      ),
              ],
            )
          : Center(
              child: Text('Nothing to show!'),
            ),
    );
  }
}
