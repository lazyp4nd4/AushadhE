import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/home/components/home_header.dart';
import 'package:shop_app/screens/more/more_product_card.dart';
import 'package:shop_app/services/sharedPreferences.dart';

class MorePopularProducts extends StatefulWidget {
  @override
  _MorePopularProductsState createState() => _MorePopularProductsState();
}

class _MorePopularProductsState extends State<MorePopularProducts> {
  bool isAdmin = false;

  void fun() async {
    bool admin = await SharedFunctions.getUserAdminStatus();
    if (admin != null) {
      if (admin) {
        setState(() {
          isAdmin = admin;
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
      body: Column(
        children: [
          HomeHeader(
            isAdmin: isAdmin,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('isPopular', isEqualTo: true)
                  .orderBy('id', descending: false)
                  .snapshots(),
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
                  Product productH = Product(
                      rating: product['rating'],
                      title: product['title'],
                      description: product['description'],
                      images: product['images'],
                      price: product['price'],
                      productId: product['productId'],
                      id: product['id'],
                      isPopular: product['isPopular']);

                  final card = MoreProductCard(
                    product: productH,
                  );
                  productCards.add(card);
                  count++;
                }
                print(count);

                return new ListView.builder(
                    itemCount: productCards.length,
                    itemBuilder: (_, index) {
                      return productCards[index];
                    });

                //
              },
            ),
          ),
        ],
      ),
    );
  }
}
