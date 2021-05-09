import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class PaymentProductCard extends StatefulWidget {
  final String productId;
  final int quantity;
  PaymentProductCard({this.productId, this.quantity});
  @override
  _PaymentProductCardState createState() => _PaymentProductCardState();
}

class _PaymentProductCardState extends State<PaymentProductCard> {
  String title, description, productId;
  int id, rating;
  List<dynamic> images;
  bool isPopular;
  int price;
  int amount;

  void fun() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get()
        .then((value) {
      setState(() {
        title = value['title'];
        price = value['price'];
        description = value['description'];
        id = value['id'];
        rating = value['rating'];
        images = value['images'];
        isPopular = value['isPopular'];
        productId = value['productId'];
      });
    });
    setState(() {
      amount = price * widget.quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(images[0]),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "Rs. $price",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " x${widget.quantity}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          ),
          Spacer(),
          Text(
            '$amount',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
