import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/home/components/section_title.dart';
import 'package:shop_app/screens/more/more_popular_products.dart';
import 'package:shop_app/screens/more/more_products.dart';
import 'package:shop_app/services/sharedPreferences.dart';

import '../../../size_config.dart';
import 'discount_banner.dart';
import 'home_header.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isAdmin = false;

  void fun() async {
    bool admin = await SharedFunctions.getUserAdminStatus();
    if (admin != null) {
      if (admin) {
        setState(() {
          isAdmin = true;
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
    CollectionReference productCollection =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          children: [
            HomeHeader(
              isAdmin: isAdmin,
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            DiscountBanner(),
            SizedBox(height: getProportionateScreenWidth(30)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                  title: "Popular Products",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MorePopularProducts()));
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: productCollection
                      .where('isPopular', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    List<Widget> popularProductCards = [];
                    final products = snapshot.data.docs;
                    for (var product in products) {
                      Product productH = Product(
                          title: product['title'],
                          description: product['description'],
                          images: product['images'],
                          rating: product['rating'],
                          price: product['price'],
                          productId: product['productId'],
                          id: product['id'],
                          isPopular: product['isPopular']);

                      final card = ProductCard(
                        product: productH,
                      );
                      popularProductCards.add(card);
                    }

                    return new ListView.builder(
                        itemCount: popularProductCards.length,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return popularProductCards[index];
                        });

                    //
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                  title: "All Products",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MoreProducts()));
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: productCollection.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    List<Widget> productCards = [];
                    final products = snapshot.data.docs;
                    int count = 0;
                    for (var product in products) {
                      if (count <= 4) {
                        Product productH = Product(
                            rating: product['rating'],
                            title: product['title'],
                            description: product['description'],
                            images: product['images'],
                            price: product['price'],
                            productId: product['productId'],
                            id: product['id'],
                            isPopular: product['isPopular']);

                        final card = ProductCard(
                          product: productH,
                        );
                        productCards.add(card);
                      }
                      count++;
                    }

                    return new ListView.builder(
                        itemCount: productCards.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return productCards[index];
                        });

                    //
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
