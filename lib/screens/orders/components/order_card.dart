import 'package:flutter/material.dart';
import 'package:shop_app/models/Order.dart';

import '../../../constants.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  OrderCard({this.order});
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
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
                  'Order Number: ' + widget.order.orderNumber.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Rs. ${widget.order.amount}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                    children: [
                      TextSpan(
                          text:
                              " Number of Products: ${widget.order.numberOfItems}",
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                )
              ],
            ),
            Spacer(),
            Text(
              "${widget.order.status}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
