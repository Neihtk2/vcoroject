import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundcolor;
  final Color bordercolor;
  final String text;
  final Color textcolor;
  final double width;
  const FollowButton(
      {Key? key,
      required this.function,
      required this.backgroundcolor,
      required this.bordercolor,
      required this.text,
      required this.textcolor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          child: Container(
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: bordercolor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.bold,
              ),
            ),
            width: width,
            height: 27,
          ),
        ),
      ),
    );
  }
}
