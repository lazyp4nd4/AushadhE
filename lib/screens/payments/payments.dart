import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/details/components/top_rounded_container.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/payments/payment_product_card.dart';
import 'package:shop_app/services/databaseServices.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

import '../../size_config.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  final int amount;
  final String uid;
  PaymentScreen({this.list, this.uid, this.amount});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String userName, address, phoneNumber;

  void fun() async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value['name'];
        phoneNumber = value['phoneNumber'];
        address = value['address'];
      });
    });
  }

  void _pay() {
    InAppPayments.setSquareApplicationId(
        "sandbox-sq0idb-HQDmlEZYFuR_Ez2nz67Cig");
    InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardNonceRequestSuccess,
        onCardEntryCancel: _onCardEntryCancel);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }

  void _onCardEntryCancel() {}

  void _onCardNonceRequestSuccess(CardDetails cardDetails) async {
    print(cardDetails.nonce);
    List<Map<String, dynamic>> list = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.uid)
        .collection('cart')
        .get();
    final docList = snapshot.docs;
    int count = 0;
    for (var doc in docList) {
      Map<String, dynamic> map1 = {
        'productId': doc['productId'],
        'price': doc['price'],
        'quantity': doc['quantity']
      };
      count += map1['quantity'];
      list.add(map1);
    }
    await DatabaseServices().placeOrder(widget.uid, widget.amount, count, list);

    InAppPayments.completeCardEntry(onCardEntryComplete: _onCardEntryComplete);
  }

  void _onCardEntryComplete() {}

  @override
  void initState() {
    super.initState();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kPrimaryColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  getProportionateScreenWidth(20),
                  getProportionateScreenWidth(30),
                  getProportionateScreenWidth(20),
                  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(12)),
                    height: getProportionateScreenWidth(36),
                    width: getProportionateScreenWidth(36),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/icons/Back ICon.svg")),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(56),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: kPrimaryColor,
                      onPressed: () {},
                      child: Text(
                        "Place Order",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (_, index) {
              // return Text("${widget.list[index]['productId']}");
              return PaymentProductCard(
                productId: widget.list[index]['productId'],
                quantity: widget.list[index]['quantity'],
              );
            },
          )),
          Expanded(
            child: TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Text(
                        '$userName',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text.rich(
                        TextSpan(
                          text: "Phone Number: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor),
                          children: [
                            TextSpan(
                                text: "$phoneNumber",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ),
                    ),
                    TopRoundedContainer(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(20)),
                              child: Text(
                                'Address:',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text('$address'),
                            ),
                            TopRoundedContainer(
                              color: Color(0xFFF6F7F9),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 40,
                                  right: 40,
                                  bottom: 15,
                                  top: getProportionateScreenWidth(15),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Total:\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: kPrimaryColor),
                                          children: [
                                            TextSpan(
                                              text: "Rs. ${widget.amount}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: DefaultButton(
                                        text: "Pay!",
                                        press: () {
                                          _pay();
                                          // List<Map<String, dynamic>> list = [];
                                          // QuerySnapshot snapshot =
                                          //     await FirebaseFirestore.instance
                                          //         .collection('profiles')
                                          //         .doc(widget.uid)
                                          //         .collection('cart')
                                          //         .get();
                                          // final docList = snapshot.docs;
                                          // int count = 0;
                                          // for (var doc in docList) {
                                          //   Map<String, dynamic> map1 = {
                                          //     'productId': doc['productId'],
                                          //     'quantity': doc['quantity']
                                          //   };
                                          //   count += map1['quantity'];
                                          //   list.add(map1);
                                          // }
                                          // await DatabaseServices().placeOrder(
                                          //     widget.uid,
                                          //     widget.amount,
                                          //     count,
                                          //     list);
                                          // _pay();
                                          // Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                )),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: kPrimaryColor,
      //   onPressed: () {
      //     _pay();
      //   },
      //   child: Icon(
      //     Icons.payment,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
