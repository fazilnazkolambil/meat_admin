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
import '../add_meat_types/screen/AddMeatTypes.dart';

class MeatTypeList extends StatefulWidget {
  const MeatTypeList({super.key, required type});

  @override
  State<MeatTypeList> createState() => _MeatTypeListState();
}

class _MeatTypeListState extends State<MeatTypeList> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Meat List",style: TextStyle(color: colorConst.primaryColor)),
      //   backgroundColor: colorConst.mainColor,
      //   centerTitle: true,
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isSmallScreen?
      InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeatTypes(),));
        },
        child: Container(
          height: 50,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorConst.canvasColor),
              // color: colorConst.mainColor
              gradient: LinearGradient(colors: [
                colorConst.thirdColor,
                colorConst.canvasColor
              ])
          ),
          child: Center(
            child: Text("Add Meat Types",style: TextStyle(
                color: colorConst.primaryColor,
                fontWeight: FontWeight.w500
            ),),
          ),
        ),
      ):SizedBox(),
      body:  Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            if(!isSmallScreen)
            SizedBox(
              height: scrHeight*1,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child:InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeatTypes(),));
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: colorConst.primaryColor,
                          borderRadius: BorderRadius.circular(scrHeight*0.03),
                          border: Border.all(color: colorConst.canvasColor),
                          gradient: LinearGradient(
                              colors: [
                                colorConst.thirdColor,
                                colorConst.canvasColor
                              ]
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: colorConst.secondaryColor.withOpacity(0.5),
                                blurRadius: 4,
                                offset: Offset(0, 2)
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_box_outlined,size: scrHeight*0.05,
                            color:colorConst.primaryColor ,
                          ),
                          Center(child: Text("Add Meat Types",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorConst.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: scrHeight*0.02
                          ),)),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("meatTypes").snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Lottie.asset(gifs.loadingGif);
                  }
                  var data = snapshot.data!.docs;
                  return data.isEmpty?
                  Center(child: Text("No Types Found",style: TextStyle(
                      fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorConst.canvasColor
                  ),),)
                  :ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MeatList(type: data[index]['type'],
                          )));
                        },
                        child: Container(
                          height: 100,
                          width: 300,
                          decoration: BoxDecoration(
                              //color: colorConst.primaryColor,
                              gradient: LinearGradient(
                                  colors: [
                                    colorConst.mainColor,
                                    colorConst.canvasColor
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(scrHeight*0.03),
                              border: Border.all(color: colorConst.canvasColor),
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
                                radius: 40,
                                backgroundImage: NetworkImage(data[index]["mainImage"]),
                              ),
                              Center(child: Text("${data[index]["type"]}",style: TextStyle(
                                  color: colorConst.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                              ),)),
                              Icon(CupertinoIcons.forward,color: colorConst.primaryColor,)
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
      ),
    );
  }
}
