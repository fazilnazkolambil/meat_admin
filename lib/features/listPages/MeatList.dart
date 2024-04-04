import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/features/listPages/BeefList.dart';

import '../../main.dart';

class MeatList extends StatefulWidget {
  const MeatList({super.key});

  @override
  State<MeatList> createState() => _MeatListState();
}

class _MeatListState extends State<MeatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meat List",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body:  Row(
        children: [
          SizedBox(
            width: scrHeight*0.5,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("meatTypes").snapshots(),
              builder: (context, snapshot) {
                return ListView.separated(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      height: scrHeight*0.06,
                      width: scrHeight*0.3,
                      decoration: BoxDecoration(
                          color: colorConst.primaryColor,
                          borderRadius: BorderRadius.circular(scrHeight*0.03),
                          border: Border.all(color: colorConst.mainColor),
                          boxShadow: [
                            BoxShadow(
                                color: colorConst.secondaryColor.withOpacity(0.5),
                                blurRadius: 4,
                                offset: Offset(0, 2)
                            )
                          ]
                      ),
                      child: Center(child: Text("Beef"),),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: scrHeight*0.04,);
                },
                );
              }
            ),
          ),
          SizedBox(
            width: scrHeight*0.5,
          ),
        ],
      ),
    );
  }
}
