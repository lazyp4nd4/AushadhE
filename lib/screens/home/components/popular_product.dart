// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/components/product_card.dart';
// import 'package:shop_app/models/Product.dart';
// import 'package:shop_app/providers/popularProductsProvider.dart';

// import '../../../size_config.dart';
// import 'section_title.dart';

// class PopularProducts extends StatefulWidget {
//   @override
//   _PopularProductsState createState() => _PopularProductsState();
// }

// class _PopularProductsState extends State<PopularProducts> {
//   @override
//   Widget build(BuildContext context) {
//     final popProducts = Provider.of<PopularProductsProvider>(context);
//     return Column(
//       children: [
//         Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//           child: SectionTitle(title: "Popular Products", press: () {}),
//         ),
//         SizedBox(height: getProportionateScreenWidth(20)),
//         // SingleChildScrollView(
//         //   scrollDirection: Axis.horizontal,
//         //   child: Row(
//         //     children: [
//         //       ...List.generate(
//         //         demoProducts.length,
//         //         (index) {
//         //           if (demoProducts[index].isPopular)
//         //             return ProductCard(product: demoProducts[index]);

//         //           return SizedBox
//         //               .shrink(); // here by default width and height is 0
//         //         },
//         //       ),
//         //       SizedBox(width: getProportionateScreenWidth(20)),
//         //     ],
//         //   ),
//         // )
//         ListView.builder(scrollDirection: Axis.horizontal, itemCount: 3, itemBuilder: (_, index)  )
//       ],
//     );
//   }
// }

// List<Product> demoProducts = [
//   Product(
//     id: 1,
//     images: [
//       "assets/images/ps4_console_white_1.png",
//       "assets/images/ps4_console_white_2.png",
//       "assets/images/ps4_console_white_3.png",
//       "assets/images/ps4_console_white_4.png",
//     ],
//     title: "Wireless Controller for PS4™",
//     price: 64.99,
//     description: description,
//     rating: 4.8,
//     isPopular: true,
//   ),
//   Product(
//     id: 2,
//     images: [
//       "assets/images/Image Popular Product 2.png",
//     ],
//     title: "Nike Sport White - Man Pant",
//     price: 50.5,
//     description: description,
//     rating: 4.1,
//     isPopular: true,
//   ),
//   Product(
//     id: 3,
//     images: [
//       "assets/images/glap.png",
//     ],
//     title: "Gloves XC Omega - Polygon",
//     price: 36.55,
//     description: description,
//     rating: 4.1,
//     isPopular: true,
//   ),
//   Product(
//     id: 4,
//     images: [
//       "assets/images/wireless headset.png",
//     ],
//     title: "Logitech Head",
//     price: 20.20,
//     description: description,
//     rating: 4.1,
//   ),
// ];
