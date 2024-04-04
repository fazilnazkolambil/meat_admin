import 'package:flutter/material.dart';
import 'package:meat_admin/core/colorPage.dart';

class ChickenList extends StatefulWidget {
  const ChickenList({super.key});

  @override
  State<ChickenList> createState() => _ChickenListState();
}

class _ChickenListState extends State<ChickenList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chicken List",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
    );
  }
}
