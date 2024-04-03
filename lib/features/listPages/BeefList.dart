import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/main.dart';

class BeefList extends StatefulWidget {
  const BeefList({super.key});

  @override
  State<BeefList> createState() => _BeefListState();
}

class _BeefListState extends State<BeefList> {
  int selectIndex=0;
  List beefmeat=[
    "Beef cut", "Boneless Beef", "Liver", "Botti"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beef List",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body:
      Row(
        children: [
          SizedBox(
            width: scrHeight*0.5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  height: scrHeight*0.08,
                  width: scrHeight*1.3,
                  child:ListView.separated(
                    itemCount:beefmeat.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectIndex=index;
                          });
                        },
                        child: Container(
                          height: scrHeight*0.07,
                          margin: EdgeInsets.only(left: scrWidth*0.04,right: scrWidth*0.04),
                          child: Center(
                            child: Text(beefmeat[index],
                              style: TextStyle(
                                  color: selectIndex==index? colorConst.secondaryColor:colorConst.secondaryColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w600
                              ),),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(scrWidth*0.05),
                              color: selectIndex==index? colorConst.mainColor:colorConst.primaryColor,
                              border: Border.all(
                                color: selectIndex==index? colorConst.mainColor:colorConst.secondaryColor.withOpacity(0.5),
                              )
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: scrHeight*0.02,
                      );
                    },
                  )
              ),
              Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: scrHeight*0.8,
                      width: scrHeight*1.3,
                    
                      child: ListView.separated(
                        itemCount: 4,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: scrHeight*0.3,
                            width: scrHeight*1.3,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: scrHeight*0.13,
                                  backgroundImage: NetworkImage(""),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Name:"),
                                      Text("Ingredients:"),
                                      Text("Price:"),
                                      Text("Qnty:"),
                                      Text("Description:"),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.edit),
                                    Icon(Icons.delete),
                                  ],
                                )
                              ],
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: scrHeight*0.05,
                        );
                      },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
