import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Order.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/cart/components/cart_card.dart';
import 'package:shop_app/screens/details/components/top_rounded_container.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OrderDetails extends StatefulWidget {
  final bool isAdmin;
  final Order order;
  OrderDetails({this.order, this.isAdmin});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<Cart> listCarts = [];
  String userName, address, phoneNumber;
  String status;
  void fun() async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.order.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value['name'];
        phoneNumber = value['phoneNumber'];
        address = value['address'];
        status = widget.order.status;
      });
    });
  }

  changeStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.order.orderId)
        .update({'status': status});
  }

  void populateList() async {
    for (int i = 0; i < widget.order.products.length; i++) {
      Product product =
          await createProduct(widget.order.products[i]['productId']);
      final cart = Cart(
          product: product, numOfItem: widget.order.products[i]['quantity']);
      setState(() {
        listCarts.add(cart);
      });
    }
  }

  Future<Product> createProduct(String productId) async {
    String title, description, productid;
    int id, rating;
    int price;
    bool isPopular;
    List<dynamic> images;
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get()
        .then((value) {
      print("hello from beginning of then");
      description = value['description'];
      title = value['title'];
      price = value['price'];
      isPopular = value['isPopular'];
      id = value['id'];
      images = value['images'];
      productid = value['productId'];
      rating = value['rating'];
    });

    return Product(
        productId: productid,
        id: id,
        rating: rating,
        title: title,
        price: price,
        images: images,
        isPopular: isPopular,
        description: description);
  }

  @override
  void initState() {
    super.initState();
    populateList();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30),
        ),
        decoration: BoxDecoration(
          color: Color(0xFFF6F7F9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: "Rs. ${widget.order.amount}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(190),
                    child: DefaultButton(
                      text: "$status",
                      press: () {
                        widget.isAdmin
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              top: 65,
                                              right: 20,
                                              bottom: 20),
                                          margin: EdgeInsets.only(top: 45),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                "Change Status",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DefaultButton(
                                                      text: "Ordered",
                                                      press: () {
                                                        changeStatus("Ordered");
                                                        setState(() {
                                                          status = "Ordered";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DefaultButton(
                                                      text: "Shipped",
                                                      press: () {
                                                        changeStatus("Shipped");
                                                        setState(() {
                                                          status = "Shipped";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DefaultButton(
                                                      text: "Delivered",
                                                      press: () {
                                                        changeStatus(
                                                            "Delivered");
                                                        setState(() {
                                                          status = "Delivered";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ), // bottom part
                                        Positioned(
                                          left: 20,
                                          right: 20,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 45,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(45)),
                                                child: Image.asset(
                                                    "assets/images/splash_1.png")),
                                          ),
                                        ), // top part
                                      ],
                                    ),
                                  );
                                })
                            : print("lol");
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: ListView.builder(
              itemCount: listCarts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CartCard(cart: listCarts[index]),
                );
              },
            ),
          )),
          widget.isAdmin
              ? TopRoundedContainer(
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
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(20)),
                                  child: Text(
                                    'Address:',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text('$address'),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ))
              : Container(),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Order Number: ${widget.order.orderNumber}",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${widget.order.numberOfItems} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
