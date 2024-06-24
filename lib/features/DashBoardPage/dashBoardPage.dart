import 'package:flutter/material.dart';
import 'package:meat_admin/core/colorPage.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConst.primaryColor,
      body: Center(child: Text("Currently working on DashBoard!")),
    );
  }
}
