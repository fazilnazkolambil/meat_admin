import 'package:flutter/material.dart';
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
        title: Text("Types of Meats",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body:  Row(
        children: [
          SizedBox(
            width: scrHeight*0.5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BeefList(),));
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
                  child: Center(child: Text("Beef"),),
                ),
              ),
              Container(
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
                child: Center(child: Text("Mutton"),),
              ),
              Container(
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
                child: Center(child: Text("Chicken"),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
