import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/databaseServices.dart';
import 'package:shop_app/services/sharedPreferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String uid;
  List<Cart> listCarts = [];

  void populateList(String productId, int quantity) async {
    Product product = await createProduct(productId);
    final cart = Cart(product: product, numOfItem: quantity);
    listCarts.add(cart);
  }

  void fun() async {
    String hello = await SharedFunctions.getUserUid();
    setState(() {
      uid = hello;
    });
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
      description = value['description'];
      title = value['title'];
      price = value['price'];
      isPopular = value['isPopular'];
      id = value['id'];
      productid = value['productId'];
      images = value['images'];
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
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('profiles')
                    .doc(uid)
                    .collection('cart')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitFadingCircle(
                      color: kPrimaryColor,
                      size: 100,
                    ));
                  }

                  if (!snapshot.hasData || snapshot.data.docs.length == 0) {
                    return Center(child: Text('Nothing in Cart!'));
                  } else {
                    final cartItems = snapshot.data.docs;
                    print(cartItems.length);
                    //

                    for (var cartItem in cartItems) {
                      populateList(cartItem['productId'], cartItem['quantity']);
                    }

                    return ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await DatabaseServices().removeFromCart(
                                      uid,
                                      listCarts[index].product.productId,
                                      listCarts[index].product.price,
                                      listCarts[index].numOfItem);
                                  listCarts.removeAt(index);
                                },
                                background: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      SvgPicture.asset(
                                          "assets/icons/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: CartCard(cart: listCarts[index])),
                          );
                        });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// addToCart(String uid, String productId, int quantity, double price) async {
//     await FirebaseFirestore.instance.collection('profiles').doc(uid).update({
//       'cart': FieldValue.arrayUnion([
//         {
//           'productId': productId,
//           'quantity': quantity,
//           'amount': (price * quantity)
//         }
//       ]),
//       'cartTotalItems': FieldValue.increment(quantity),
//       'cartTotal': FieldValue.increment(price * quantity)
//     });
//   }
// 

/*
key: Key(listCarts[index].product.id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                listCarts.removeAt(index);
                              });
                            },
 */