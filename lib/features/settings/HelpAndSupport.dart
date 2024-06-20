import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';

import '../../main.dart';



class HelpAndSupport extends ConsumerStatefulWidget {
  final String name;
  const HelpAndSupport({Key? key, required this.name}) : super(key: key);

  @override
  ConsumerState<HelpAndSupport> createState() => _HelpAndSupportState();
}  String? chooseCategory;

class _HelpAndSupportState extends ConsumerState<HelpAndSupport> {
  TextEditingController TextController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  addCategory()async{
    FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).doc(categoryController.text).set({
      "category" : categoryController.text,

    }).then((value){
      categoryController.clear();
    });
  }
  addQN() async {
    await FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).doc(chooseCategory.toString()).update({
      "questions":FieldValue.arrayUnion([{
        "Question" : questionController.text,
        "Answer" : answerController.text,
      }])
    }).then((value) {
      questionController.clear();
      answerController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("submitted Successfully")));
  }
  settingsData() async {
    await FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).doc(widget.name).set({
      "Text" : TextController.text,
    }).then((value) {
      TextController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("submitted Successfully")));
  }
  final formkey = GlobalKey<FormState>();
  bool tap = false;
  List tapList = [];
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body:Padding(
        padding: EdgeInsets.all(scrHeight*0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.name=="FAQs"?
            SizedBox(
              width: scrWidth*0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: scrWidth*0.3,
                          height: 40,
                          child:  TextFormField(
                            controller: categoryController,
                            onFieldSubmitted: (value) {
                              if (categoryController.text != "") {
                                addCategory();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Please Enter Data!")));
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                label: Text("Add new Category",style: TextStyle(
                                    fontSize: isSmallScreen?10:15
                                ),),
                                hintText: "Enter the Category",
                                hintStyle: TextStyle(
                                    fontSize: isSmallScreen?10:15
                                )),
                          ),
                        ),
                        CircleAvatar(
                          radius: isSmallScreen?15:20,
                          child: InkWell(
                              onTap: () {
                                if (categoryController.text != "") {
                                  addCategory();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Please Enter Data!")));
                                }
                              },
                              child: Icon(Icons.add)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                     stream: FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).snapshots(),
                        builder: (context, snapshot) {
                       if(!snapshot.hasData){
                         return Center(child: Lottie.asset(gifs.loadingGif,height:100 ));
                       }
                     var data=snapshot.data!.docs;
                     return SizedBox(
                       width: scrWidth*0.3,
                       height: scrHeight*0.4,
                       child: ListView.separated(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                        return SizedBox(
                          height: 30,
                         // width: scrWidth*0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${index + 1}.",style: TextStyle(
                                  color: colorConst.canvasColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isSmallScreen?12:15
                              )),
                              Text(data[index]["category"],style: TextStyle(
                                  color: colorConst.canvasColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isSmallScreen?12:15
                              )),
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Are you sure you want to delete this Category?",
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
                                                  chooseCategory = null;
                                                  Navigator.pop(context);
                                                  await FirebaseFirestore.instance
                                                      .collection("settings").doc(widget.name)
                                                      .collection(widget.name).doc(data[index]["category"]).delete();
                                                  setState(() {

                                                  });
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
                                  child: Icon(CupertinoIcons.delete,color: colorConst.red,size:
                                    isSmallScreen?20:25,
                                  )),
                            ],
                          ),
                        );
                        },
                         separatorBuilder: (context, index) => SizedBox(height: 10))
                     );
                                  }
                                ),
                    SizedBox(
                        width: scrWidth*0.4,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return Center(child: Text("Loading..."),);
                                  }
                                  var data=snapshot.data!.docs;
                                  return data.isEmpty?Text('No Categories found')
                                      :Container(
                                    height: scrHeight * 0.06,
                                    width: scrHeight * 0.6,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(scrHeight * 0.03),
                                        border:
                                        Border.all(color: colorConst.canvasColor)),
                                    child: Center(
                                      child: DropdownButton(
                                        padding: EdgeInsets.all(scrHeight * 0.01),
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text(
                                          "Select Category",
                                          style: TextStyle(
                                              color: colorConst.secondaryColor,
                                              fontSize: isSmallScreen?12:15
                                          ),
                                        ),
                                        style: TextStyle(
                                            color: colorConst.secondaryColor),
                                        value: chooseCategory,
                                        items: List.generate(data.length,
                                                (index) => data[index]['category']).map((e) {
                                          return DropdownMenuItem(
                                              value: e, child: Text(e));
                                        }).toList(),
                                        onChanged: (value) {
                                          chooseCategory = value.toString();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                }
                            ),
                            SizedBox(height: scrHeight*0.05,),
                            SizedBox(
                              height: scrHeight*0.06,
                              width: scrHeight*0.6,
                              child: TextFormField(
                                controller: questionController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                cursorColor: colorConst.canvasColor,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    labelText:"Enter Question",
                                    labelStyle: TextStyle(
                                        color: colorConst.secondaryColor,
                                        fontSize: isSmallScreen?10:15
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
                            SizedBox(
                              height: scrHeight*0.06,
                              width: scrHeight*0.6,
                              child: TextFormField(
                                controller: answerController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                cursorColor: colorConst.canvasColor,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    labelText:"Enter Answer",
                                    labelStyle: TextStyle(
                                        color: colorConst.secondaryColor,
                                        fontSize: isSmallScreen?10:15
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
                                if(
                                chooseCategory != null &&
                                    questionController.text !=""&&
                                    answerController.text !=""
                                ){
                                  addQN();
                                }
                                else{
                                  chooseCategory == null? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please choose Category!"))):
                                  questionController.text==""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Question"))):
                                  answerController.text==""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Answer"))):
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter details")));
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
                                      child: Text("Submit",
                                          style: TextStyle(
                                              color: colorConst.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: scrHeight * 0.02)))),
                            ),
                          ],
                        )
                    ),
                  ],),
              )
              ,):
            SizedBox(
              width: isSmallScreen?scrWidth*0.8:scrWidth*0.4,
              height: scrHeight*0.8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: isSmallScreen?scrWidth*0.8:350,
                      child: TextFormField(
                        controller: TextController,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        cursorColor: colorConst.canvasColor,
                        onFieldSubmitted: (value) {
                          if(TextController.text.isNotEmpty){
                            settingsData();
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Text")));
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            labelText:"Enter ${widget.name}",
                            labelStyle: TextStyle(
                                color: colorConst.secondaryColor,
                                fontSize: isSmallScreen?10:15
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
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        if(TextController.text.isNotEmpty){
                          settingsData();
                        } else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Text")));
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
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: colorConst.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: scrHeight * 0.02)))),
                    ),
                    SizedBox(height: 20,),
                    if(isSmallScreen)
                      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('settings')
                              .doc(widget.name).collection(widget.name).snapshots(),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return Center(child: Lottie.asset(gifs.loadingGif,height: scrWidth*0.3),);
                            }
                            var data = snapshot.data!.docs;
                            return data.isEmpty?
                            Center(child: Text("No ${widget.name}"),)
                                :Center(
                              child: Center(child: Text(data[0]['Text'])),
                            );
                          }
                      ),
                  ],
                ),
              ),
            ),
             //if(!isSmallScreen)
             SingleChildScrollView(
               child: Column(
                      children: [
                        widget.name=="FAQs"?
                        Column(
                          children: [
                            SizedBox(height: 20,),
                            SizedBox(
                              height: scrHeight*0.8,
                              width: scrWidth*0.5,
                              child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                                stream: FirebaseFirestore.instance.collection('settings').doc(widget.name).collection(widget.name).snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return Center(child:Text("Loading..."));
                                  }
                                  var data = snapshot.data!.docs;
                                  return ListView.separated(
                                    itemCount: data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if(tapList.contains(data[index]['category'])){
                                            tapList.remove(data[index]['category']);
                                          }else{
                                            tapList.add(data[index]['category']);
                                          }
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          //color: colorConst.red,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: colorConst.mainColor),

                                          ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(data[index]['category'],style: TextStyle(
                                                      fontSize:isSmallScreen?15:20,
                                                      fontWeight: FontWeight.w600,

                                                    ),),
                                                    Icon(!tapList.contains(data[index]['category'])?
                                                    CupertinoIcons.chevron_down:CupertinoIcons.chevron_up),
                                                  ],
                                                ),
                                                if(tapList.contains(data[index]['category']))
                                                 SizedBox(
                                                   height: 200,
                                                   //width: scrWidth*0.4,
                                                   child: ListView.separated(
                                                     itemCount: data[index]['questions'].length,
                                                       itemBuilder: (context, index2) {
                                                         return SingleChildScrollView(
                                                           scrollDirection: Axis.horizontal,
                                                           child: Row(
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               Text('${index2 + 1} - '),
                                                               SizedBox(width: 10,),
                                                               Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                 children: [
                                                                   SizedBox(
                                                                     width: isSmallScreen?scrWidth*0.3:scrWidth*0.45,
                                                                     child: RichText(
                                                                       text: TextSpan(
                                                                         children: [
                                                                           TextSpan(
                                                                             text: 'Question : ',
                                                                             style: TextStyle(
                                                                                 color: colorConst.mainColor,
                                                                               fontWeight: FontWeight.bold
                                                                             )
                                                                           ),
                                                                           TextSpan(
                                                                             text: data[index]['questions'][index2]['Question'],
                                                                             style: TextStyle(
                                                                               color: colorConst.secondaryColor
                                                                             )
                                                                           )
                                                                         ]
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   SizedBox(
                                                                     width: isSmallScreen?scrWidth*0.3:scrWidth*0.45,
                                                                     child: RichText(
                                                                       text: TextSpan(
                                                                         children: [
                                                                           TextSpan(
                                                                             text: 'Answer : ',
                                                                             style: TextStyle(
                                                                                 color: colorConst.mainColor,
                                                                               fontWeight: FontWeight.bold
                                                                             )
                                                                           ),
                                                                           TextSpan(
                                                                             text: data[index]['questions'][index2]['Answer'],
                                                                               style: TextStyle(
                                                                                   color: colorConst.secondaryColor
                                                                               )
                                                                           )
                                                                         ]
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   InkWell(
                                                                       onTap: () {
                                                                         showDialog(
                                                                           barrierDismissible: false,
                                                                           context: context,
                                                                           builder: (context) {
                                                                             return AlertDialog(
                                                                               title: Text("Are you sure you want to delete this QN?",
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
                                                                                       Navigator.pop(context);
                                                                                       await FirebaseFirestore.instance
                                                                                           .collection("settings").doc(widget.name)
                                                                                           .collection(widget.name).doc(data[index]["category"]).update({
                                                                                         'questions' : FieldValue.arrayRemove([data[index]['questions'][index2]])
                                                                                       });
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
                                                                       child: Container(
                                                                         padding: EdgeInsets.symmetric(horizontal: 10),
                                                                         decoration: BoxDecoration(
                                                                           border: Border.all(color: colorConst.mainColor)
                                                                         ),
                                                                         child: Center(child: Text('Delete',style: TextStyle(
                                                                           color: colorConst.red
                                                                         ),),),
                                                                       )),
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                         );
                                                       },
                                                     separatorBuilder: (context, index) => SizedBox(height: 10,),
                                                   ),
                                                 )
                                              ],
                                            )),
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20,),
                                  );
                                }
                              ),
                            )
                          ],
                        ):
                            isSmallScreen?SizedBox():
                        StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('settings')
                            .doc(widget.name).collection(widget.name).snapshots(),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return Center(child: Lottie.asset(gifs.loadingGif,width: 300),);
                            }
                              var data = snapshot.data!.docs;
                            return data.isEmpty?
                                Center(child: Text("No ${widget.name}"),)
                            :SizedBox(
                              height: scrHeight*0.8,
                              width: scrWidth*0.3,
                              child: Center(child: Text(data[0]['Text'],textAlign: TextAlign.center,)),
                            );
                          }
                        ),
               
                      ],
                    ),
             ),

                  ],
                ),
        ),
    );
  }
}
