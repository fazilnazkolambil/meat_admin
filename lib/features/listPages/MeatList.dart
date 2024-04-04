import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/listPages/BeefList.dart';
import 'package:meat_admin/features/listPages/ChickenList.dart';
import 'package:meat_admin/features/listPages/MuttonList.dart';

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
                if(!snapshot.hasData){
                  return Center(child: Text("No Data Found"));
                }
                var data = snapshot.data!.docs;
                return data.length == 0? Lottie.asset(gifs.loadingGif)
                :ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        data[index]["type"] == "Beef"?
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BeefList(),)):
                            data[index]["type"] == "Mutton"?
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MuttonList(),)):
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChickenList(),));
                      },
                      child: Container(
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
                        child: Center(child: Text(data[index]["type"]),),
                      ),
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
