import 'package:flutter/material.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/main.dart';

class Meatpage extends StatefulWidget {
  const Meatpage({super.key});

  @override
  State<Meatpage> createState() => _MeatpageState();
}

class _MeatpageState extends State<Meatpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 200,
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorConst.actionColor.withOpacity(0.37),
              ),
              gradient: const LinearGradient(
                colors: [
                  colorConst.accentCanvasColor,
                  colorConst.canvasColor
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorConst.secondaryColor.withOpacity(0.28),
                  blurRadius: 30,
                )
              ],
            ),
            child: Center(
              child: Text("Add Meats",style: TextStyle(
                color: colorConst.primaryColor
              ),),
            ),
          )
        ],
      ),
    );
  }
}
