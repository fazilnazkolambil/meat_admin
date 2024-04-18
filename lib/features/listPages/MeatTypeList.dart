import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';

import 'package:meat_admin/unWanted/ChickenList.dart';
import 'package:meat_admin/features/listPages/meatList.dart';
import 'package:meat_admin/unWanted/MuttonList.dart';

import '../../main.dart';

class MeatTypeList extends StatefulWidget {
  const MeatTypeList({super.key, required type});

  @override
  State<MeatTypeList> createState() => _MeatTypeListState();
}

class _MeatTypeListState extends State<MeatTypeList> {
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
            height: scrHeight*0.9,
            width: scrWidth*0.5,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("meatTypes").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Lottie.asset(gifs.loadingGif);
                }

                var data = snapshot.data!.docs;
                return data.length == 0?
                Center(child: Text("No Types Found"),)
                :ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (context, index) {


                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MeatList(type: data[index]['type'],

                        )));
                      },
                      child: Container(
                        height: scrHeight*0.2,
                        width: scrWidth*0.3,
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
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: scrHeight*0.09,
                              backgroundImage: NetworkImage(data[index]["mainImage"]),
                            ),
                            Center(child: Text("List ${data[index]["type"]}",style: TextStyle(
                                fontSize: scrHeight*0.025,
                                fontWeight: FontWeight.w700
                            ),)),
                            Icon(CupertinoIcons.forward)
                          ],
                        )
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: scrHeight*0.04,);
                },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
