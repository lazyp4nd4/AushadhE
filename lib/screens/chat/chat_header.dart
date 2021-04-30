import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ChatHeader extends StatefulWidget {
  final String me;
  final String name;
  ChatHeader({this.me, this.name});
  @override
  _ChatHeaderState createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ignore: deprecated_member_use
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              height: getProportionateScreenWidth(36),
              width: getProportionateScreenWidth(36),
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset("assets/icons/Back ICon.svg"),
            ),
            SizedBox(
              height: getProportionateScreenHeight(56),
              // ignore: deprecated_member_use
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: kPrimaryColor,
                onPressed: () {},
                child: Text(
                  widget.me == "User" ? "Chat with Admin" : "${widget.name}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
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
