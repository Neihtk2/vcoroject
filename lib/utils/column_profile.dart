// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ColumnProfile extends StatefulWidget {
  int number;
  String title;
  ColumnProfile({
    Key? key,
    required this.number,
    required this.title,
  }) : super(key: key);

  @override
  State<ColumnProfile> createState() => _ColumnProfileState();
}

class _ColumnProfileState extends State<ColumnProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(widget.number.toString(),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w400, color: Colors.grey))
      ],
    );
  }
}
