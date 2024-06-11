import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/features/addingPages/screen/AddMeats.dart';
import 'package:meat_admin/features/listPages/UsersStream/Screen/UsersPage.dart';

import 'package:meat_admin/features/settings/HelpAndSupport.dart';

import '../../main.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({Key? key}) : super(key: key);

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
 

  TextEditingController settingsController = TextEditingController();
  settingsData(){
    FirebaseFirestore.instance.collection("settings").doc(settingsController.text).set({
      "Text" : settingsController.text
    }).then((value) =>
        settingsController.clear()
    );
  }
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Help and Support"),
      // ),
      body: Padding(
        padding:  EdgeInsets.all(scrHeight*0.04),
        child: Column(
          children: [
            SizedBox(height: scrHeight*0.02,),
            Container(
              height: scrHeight*0.06,
              width: scrHeight*0.6,
              child: TextFormField(
                controller: settingsController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                cursorColor: colorConst.canvasColor,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: "Enter New Settings",
                    labelStyle: TextStyle(
                        color: colorConst.secondaryColor,
                        fontSize: isSmallScreen?12:16
                        // isSmallScreen?12:15
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colorConst.canvasColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(scrWidth * 0.03),
                        borderSide:
                        BorderSide(color: colorConst.canvasColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(scrWidth * 0.03),
                        borderSide:
                        BorderSide(color: colorConst.canvasColor))),
              ),
            ),
            SizedBox(height: scrHeight*0.03,),
            InkWell(
              onTap: (){
                settingsData();
                setState(() {

                });
                },
              child: Container(
                  height: scrHeight * 0.05,
                  width: scrHeight * 0.1,
                  decoration: BoxDecoration(
                    color: colorConst.canvasColor,
                    borderRadius:
                    BorderRadius.circular(scrHeight * 0.07),
                  ),
                  child: Center(
                      child: Text("Add",
                          style: TextStyle(
                              color: colorConst.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: scrHeight * 0.02)))),
            ),
            SizedBox(height:scrHeight*0.05,),
            StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("settings").snapshots(),
            builder: (context, snapshot) {
             if(!snapshot.hasData){
               return CircularProgressIndicator();
             }
             var data=snapshot.data!.docs;
             return Expanded(
               child: ListView.separated(
                 itemCount:data.length,
                   shrinkWrap: true,
                   scrollDirection: Axis.vertical,
                   itemBuilder:(BuildContext context,int index){
                     return InkWell(
                       onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupport(name: "${data[index]["Text"]}"),));
                       },
                       child: Container(
                         // color: colorConst.canvasColor,
                         child: Text("${data[index]["Text"]}",
                         style: TextStyle(
                           fontWeight:FontWeight.w500,
                           fontSize:  isSmallScreen?10:16
                         ),),
                       ),
                     );
                   },
                 separatorBuilder: (BuildContext context, int index) {
                   return SizedBox(height: 10,);
                 },),
             );
           }
         )
          ],
        ),
      ),
    );
  }
}
