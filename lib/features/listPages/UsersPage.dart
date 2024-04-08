import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/main.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          SizedBox(
            width: scrHeight*0.5,

          ),

             StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }
                var data=snapshot.data!.docs;
                return Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    // shrinkWrap: true,
                    padding: EdgeInsets.all(scrHeight*0.09),
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent:scrHeight*0.4,
                        crossAxisCount: 2,
                        mainAxisSpacing: scrHeight*0.03,
                        crossAxisSpacing:scrHeight*0.03,
                        childAspectRatio: 2
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: scrHeight*0.07,
                        width: scrHeight*0.01,
                        // margin: EdgeInsets.all( scrHeight*0.012),
                        decoration: BoxDecoration(
                            color: colorConst.primaryColor,
                            borderRadius: BorderRadius.circular(scrHeight*0.03),
                            boxShadow: [
                              BoxShadow( color: colorConst.secondaryColor.withOpacity(0.15),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  offset: Offset(0, 4))
                            ]
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(left: scrHeight*0.05,top: scrHeight*0.03),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage("${data?[index]["image"]}"),
                                  radius: 40,
                                ),
                              ),
                              SizedBox(height: scrHeight*0.03,),
                              Text("Name:${data?[index]["name"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: scrHeight*0.02
                              ),),
                              Text("Number:${data?[index]["number"]}"),
                              Text("email:${data?[index]["email"]}"),


                               InkWell(
                                 onTap: (){
                                   showCupertinoModalPopup(
                                     context: context,
                                     builder: (context) {
                                       return AlertDialog(
                                         title: Text(":${data?[index]["address"]}"),

                                       );
                                     },
                                   );
                                 },
                                 child: Container(
                                   height: scrHeight*0.04,
                                  width: scrHeight*0.09,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(scrHeight*0.03),
                                    color: colorConst.mainColor
                                  ),
                                   child: Center(
                                     child: Text("Address",
                                       style: TextStyle(
                                           fontSize:scrHeight*0.02 ,
                                           color: colorConst.primaryColor
                                       ),),
                                   ),


                                 ),
                               )


                            ],
                          ),
                        ),
                      );
                    },

                  ),
                );
              }
            ),


        ],
      ),

    );
  }
}
