import 'package:flutter/material.dart';
import 'package:meat_admin/core/colorPage.dart';

class MuttonList extends StatefulWidget {
  const MuttonList({super.key});

  @override
  State<MuttonList> createState() => _MuttonListState();
}

class _MuttonListState extends State<MuttonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mutton List",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
    );
  }
}
