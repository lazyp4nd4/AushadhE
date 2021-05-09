import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/details/details_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.width = 140,
    this.aspectRetio = 1.02,
    @required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(width),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: ProductDetailsArguments(product: product),
        ),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.02,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Hero(
                      tag: product.productId,
                      child: Image.network(product.images[0]),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      product.title,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          "Rs. ${product.price}",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                        // InkWell(
                        //   borderRadius: BorderRadius.circular(50),
                        //   onTap: () {},
                        //   child: Container(
                        //     padding:
                        //         EdgeInsets.all(getProportionateScreenWidth(8)),
                        //     height: getProportionateScreenWidth(28),
                        //     width: getProportionateScreenWidth(28),
                        //     decoration: BoxDecoration(
                        //       color: kSecondaryColor.withOpacity(0.1),
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: SvgPicture.asset(
                        //       "assets/icons/Heart Icon_2.svg",
                        //       color: Color(0xFFDBDEE4),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
