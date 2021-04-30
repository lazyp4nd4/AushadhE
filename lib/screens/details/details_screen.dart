import 'package:flutter/material.dart';
import 'package:shop_app/services/sharedPreferences.dart';

import '../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String uid;
  bool present = false;
  String productId;
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

  @override
  void initState() {
    super.initState();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context).settings.arguments;
    setState(() {
      productId = agrs.product.productId;
    });
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(
          rating: 4,
          signedIn: uid == null ? false : true,
          uid: uid,
          productId: productId),
      body: Body(
        product: agrs.product,
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({@required this.product});
}
