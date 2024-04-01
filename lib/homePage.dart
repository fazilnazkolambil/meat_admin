import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meat_admin/colorPage.dart';
import 'package:meat_admin/imageConst.dart';

import 'main.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(imageConst.logo)),
            Text("Users",style: TextStyle(
              fontSize: scrHeight*0.03,
              color: colorConst.mainColor
            )),
            Text("Meats",style: TextStyle(
                fontSize: scrHeight*0.03,
                color: colorConst.mainColor
            )),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home Page",style: TextStyle(color: colorConst.primaryColor),),
            backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: scrHeight*0.4,
          child: Image(image: AssetImage(imageConst.logo),),),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: scrHeight*0.1,
                  width: scrHeight*0.4,
                  margin: EdgeInsets.all(scrHeight*0.01),
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
                        radius: scrHeight*0.045,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order ID:#23584",style: TextStyle(
                              fontSize: scrHeight*0.02,
                              fontWeight: FontWeight.w700,
                              color: colorConst.secondaryColor
            
                          ),),
                          Text("15 Mar 2024 - 11 PM"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: scrHeight*0.07,
                                height: scrHeight*0.03,
                                child: Center(child: Text("Cancel",style: TextStyle(color:colorConst.red),),),
                              ),
                              SizedBox(
                                width: scrHeight*0.07,
                                height: scrHeight*0.03,
                                child: Center(child: Text("Done",style: TextStyle(color:colorConst.green))),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
                }
            ),
          ),
          SizedBox(width: scrHeight*0.4)
        ],
      ),
    );
  }
}
