import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';

class MyBadge extends StatelessWidget {
  final String color;
  final String status;
  const MyBadge({super.key, required this.color, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor(color),
      ),
      width: 90,
      height: 25,
      child: Center(
        child: Text(
          status,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
