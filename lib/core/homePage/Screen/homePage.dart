import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/features/add_meat_types/screen/meatTypes.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/listPages/MeatTypeList.dart';
import '../../../features/listPages/UsersStream/Screen/UsersPage.dart';
import '../../../main.dart';

class homePage extends StatefulWidget {


  const homePage({super.key,   });

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String? userId;

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: AssetImage(imageConst.logo)),
            InkWell(
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) => UsersPage(),));
              },
              child: Text("Users",style: TextStyle(
                fontSize: scrHeight*0.03,
                color: colorConst.mainColor
              )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MeatTypeList(type: "",),));
              },
              child: Text("Meats",style: TextStyle(
                  fontSize: scrHeight*0.03,
                  color: colorConst.mainColor
              )),
            ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                child: Center(child: Text("Banner"),),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MeatTypes(),));
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
                  child: Center(child: Text("Add Meat"),),
                ),
              ),
            ],
          )),


                StreamBuilder<QuerySnapshot>(
                    stream:  FirebaseFirestore.instance.collection("orderDetails").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      var data = snapshot.data!.docs;

                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: scrHeight * 0.15,
                                width: scrHeight * 0.4,
                                margin: EdgeInsets.all(scrHeight * 0.01),
                                decoration: BoxDecoration(
                                    color: colorConst.primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        scrHeight * 0.03),
                                    border: Border.all(
                                        color: colorConst.mainColor),
                                    boxShadow: [
                                      BoxShadow(
                                          color: colorConst.secondaryColor
                                              .withOpacity(0.5),
                                          blurRadius: 4,
                                          offset: Offset(0, 2)
                                      )
                                    ]
                                ),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      radius: scrHeight * 0.045,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [

                                        Text(
                                          "Order ID: ${data[index]["orderId"]}",
                                          style: TextStyle(
                                              fontSize: scrHeight * 0.02,
                                              fontWeight: FontWeight.w700,
                                              color: colorConst.secondaryColor

                                          ),),
                                        Text("15 Mar 2024 - 11 PM"),
                                        Text("Location:"),
                                        InkWell(
                                          onTap: () async {
                                            userId = data[index]["userId"];
                                            DocumentSnapshot<Map<String,dynamic>> userr = await FirebaseFirestore.instance.collection('users').doc(userId).get();
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    title:
                                                    Column(
                                                      children: [
                                                        Text("name:${userr.data()!['name']}"),
                                                        Text("email:${userr.data()!['email']}"),
                                                        Text("address:${userr.data()!['address']}"),
                                                        // Text("${userr.data()!['image']}"),
                                                        Text("phone:${userr.data()!['number']}"),
                                                        Text("${userr.data()!['favourites']}"),
                                                      ],
                                                    ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: scrHeight * 0.04,
                                            width: scrHeight * 0.13,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(scrHeight * 0.03),
                                                color: colorConst.mainColor
                                            ),
                                            child: Center(
                                              child: Text("User details",
                                                style: TextStyle(
                                                    fontSize: scrHeight * 0.02,
                                                    color: colorConst
                                                        .primaryColor
                                                ),),
                                            ),


                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                        ),
                      );
                    }


              )

        ],
      ),
    );
  }
}
