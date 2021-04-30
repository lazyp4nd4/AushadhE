import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/home/components/add_product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatefulWidget {
  final bool isAdmin;
  const HomeHeader({
    this.isAdmin,
    Key key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(30),
            getProportionateScreenWidth(20),
            getProportionateScreenHeight(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(56),
              // ignore: deprecated_member_use
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: kPrimaryColor,
                onPressed: () {},
                child: Text(
                  "AushadhE",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconBtnWithCounter(
              svgSrc: widget.isAdmin
                  ? "assets/icons/Plus Icon.svg"
                  : "assets/icons/Cart Icon.svg",
              press: () => widget.isAdmin
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProduct()))
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen())),
            ),
            // IconBtnWithCounter(
            //   svgSrc: "assets/icons/Bell.svg",
            //   numOfitem: 3,
            //   press: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
