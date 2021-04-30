import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/rounded_icon_btn.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/cart/successful_cart_add.dart';
import 'package:shop_app/screens/details/components/product_images.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/services/databaseServices.dart';
import 'package:shop_app/services/sharedPreferences.dart';
import 'package:shop_app/size_config.dart';

import '../../../constants.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';

class Body extends StatefulWidget {
  final Product product;

  const Body({Key key, @required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String title, description;
  int price;
  int rating;
  bool isPopular;
  String uid;
  int quantity = 0;
  bool isAdmin = false;

  void fun() async {
    String hello = await SharedFunctions.getUserUid();
    bool admin = await SharedFunctions.getUserAdminStatus();
    if (hello != null) {
      setState(() {
        uid = hello;
      });
    }
    if (admin != null) {
      if (admin) {
        setState(() {
          isAdmin = true;
        });
      }
    }
  }

  void instantiateVariables() {
    setState(() {
      title = widget.product.title;
      description = widget.product.description;
      price = widget.product.price;
      rating = widget.product.rating;
      isPopular = widget.product.isPopular;
    });
  }

  @override
  void initState() {
    super.initState();
    fun();
    instantiateVariables();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    !isAdmin
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text("Quantity: $quantity"),
                                Spacer(),
                                RoundedIconBtn(
                                  icon: Icons.remove,
                                  press: () {
                                    setState(() {
                                      quantity = quantity - 1;
                                    });
                                  },
                                ),
                                SizedBox(
                                    width: getProportionateScreenWidth(20)),
                                RoundedIconBtn(
                                  icon: Icons.add,
                                  showShadow: true,
                                  press: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Price:\n",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600),
                                    children: [
                                      TextSpan(
                                        text: "Rs. $price",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'isPopular',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      color: isPopular
                                          ? Colors.greenAccent
                                          : Colors.redAccent),
                                )
                              ],
                            )),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: isAdmin ? "Update Details" : "Add To Cart",
                          press: () async {
                            if (uid == null) {
                              // ask to sign in
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      titlePadding: EdgeInsets.all(20),
                                      title: Text("Sign-In to Continue"),
                                      contentPadding: EdgeInsets.all(20),
                                      actionsPadding: EdgeInsets.all(20),
                                      content: Text(
                                          "Please sign-in to add product to Cart"),
                                      actions: [
                                        DefaultButton(
                                          text: "Sign - In",
                                          press: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                SignInScreen.routeName,
                                                (route) => false);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              // add order

                              if (isAdmin == false) {
                                if (quantity > 0) {
                                  await DatabaseServices().addToCart(
                                      uid,
                                      widget.product.productId.toString(),
                                      quantity,
                                      widget.product.price);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddToCartSuccessful()));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          titlePadding: EdgeInsets.all(20),
                                          title: Text("Insufficient Quantity"),
                                          contentPadding: EdgeInsets.all(20),
                                          actionsPadding: EdgeInsets.all(20),
                                          content: Text(
                                              "Please select 1 or more number of this item to add to cart"),
                                          actions: [
                                            DefaultButton(
                                              text: "Continue",
                                              press: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                margin:
                                                    EdgeInsets.only(top: 45),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "Update Details",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Title: '),
                                                            Expanded(
                                                                child:
                                                                    TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  title = value;
                                                                });
                                                              },
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                'Description: '),
                                                            Expanded(
                                                                child:
                                                                    TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  description =
                                                                      value;
                                                                });
                                                              },
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Price: '),
                                                            Expanded(
                                                                child:
                                                                    TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  price =
                                                                      int.parse(
                                                                          value);
                                                                });
                                                              },
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Rating: '),
                                                            Expanded(
                                                                child:
                                                                    TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  rating =
                                                                      int.parse(
                                                                          value);
                                                                });
                                                              },
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('isPopular: '),
                                                            Expanded(
                                                                child:
                                                                    TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  if (value ==
                                                                      "true") {
                                                                    isPopular =
                                                                        true;
                                                                  } else
                                                                    isPopular =
                                                                        false;
                                                                });
                                                              },
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        DefaultButton(
                                                          press: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc(widget
                                                                    .product
                                                                    .productId)
                                                                .update({
                                                              'title': title,
                                                              'description':
                                                                  description,
                                                              'price': price,
                                                              'rating': rating,
                                                              'isPopular':
                                                                  isPopular
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          text: "Save!",
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ), // bottom part
                                              Positioned(
                                                left: 20,
                                                right: 20,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 45,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  45)),
                                                      child: Image.asset(
                                                          "assets/images/splash_1.png")),
                                                ),
                                              ), // top part
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
