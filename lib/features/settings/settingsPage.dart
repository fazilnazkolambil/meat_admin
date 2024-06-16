import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
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
                if(settingsController.text.isNotEmpty){
                  settingsData();
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Field is Empty!")));
                }
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
               return Center(child: Lottie.asset(gifs.loadingGif),);
             }
             var data=snapshot.data!.docs;
             return Expanded(
               child: ListView.separated(
                 itemCount:data.length,
                   shrinkWrap: true,
                   scrollDirection: Axis.vertical,
                   itemBuilder:(BuildContext context,int index){
                     return GestureDetector(
                       onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupport(name: "${data[index]["Text"]}"),));
                       },
                       child: Container(
                         height: 50,
                         margin: EdgeInsets.symmetric(horizontal: isSmallScreen?30:scrWidth*0.2),
                         decoration: BoxDecoration(
                             border: Border.all(color: colorConst.mainColor),
                           gradient: LinearGradient(colors: [
                             colorConst.mainColor,
                             colorConst.canvasColor
                           ])
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             SizedBox(
                               height: 30,
                               width: 150,
                               child: Center(
                                 child: Text("${data[index]["Text"]}",
                                 style: TextStyle(
                                   color: colorConst.primaryColor,
                                   fontWeight:FontWeight.w600,
                                   fontSize:  isSmallScreen?13:16
                                 ),),
                               ),
                             ),
                             IconButton(
                                 onPressed: () {
                                   showDialog(
                                     barrierDismissible: false,
                                     context: context,
                                     builder: (context) {
                                       return AlertDialog(
                                         title: Text("Are you sure you want to delete this Option?",
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                               fontSize: scrHeight*0.02,
                                               fontWeight: FontWeight.w600
                                           ),),
                                         content: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                           children: [
                                             InkWell(
                                               onTap: () {
                                                 Navigator.pop(context);
                                               },
                                               child: Container(
                                                 height: 30,
                                                 width: 100,
                                                 decoration: BoxDecoration(
                                                   color: Colors.blueGrey,
                                                   borderRadius: BorderRadius.circular(scrWidth*0.03),
                                                 ),
                                                 child: Center(child: Text("No",
                                                   style: TextStyle(
                                                       color: Colors.white
                                                   ),)),
                                               ),
                                             ),
                                             InkWell(
                                               onTap: () async {
                                                 await FirebaseFirestore.instance.collection('settings').doc(data[index]['Text']).delete();
                                                 Navigator.pop(context);
                                               },
                                               child: Container(
                                                 height: 30,
                                                 width: 100,
                                                 decoration: BoxDecoration(
                                                   color: colorConst.mainColor,
                                                   borderRadius: BorderRadius.circular(scrWidth*0.03),
                                                 ),
                                                 child: Center(child: Text("Yes",
                                                   style: TextStyle(
                                                       color: Colors.white
                                                   ),)),
                                               ),
                                             ),
                                           ],
                                         ),
                                       );
                                     },
                                   );
                                 },
                                 icon: Icon(CupertinoIcons.delete,color: colorConst.red,)
                             )
                           ],
                         ),
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
