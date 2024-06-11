import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:readmore/readmore.dart';

import '../../main.dart';

class HelpAndSupport extends StatefulWidget {
  final String name;
  const HelpAndSupport({Key? key, required this.name}) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}  String? chooseCategory;
  String? chooseCategory1;

class _HelpAndSupportState extends State<HelpAndSupport> {
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
       //"category" : chooseCategory.toString(),
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
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body:Padding(
        padding: EdgeInsets.all(scrHeight*0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.name=="FAQs"?
            SizedBox(
              width: scrWidth*0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: SizedBox(
                        height:scrHeight*0.07,
                        child: TextFormField(
                          controller: categoryController,
                          onFieldSubmitted: (value) {
                            addCategory();
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
                      trailing: CircleAvatar(
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
                    ),
                    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                     stream: FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).snapshots(),
                        builder: (context, snapshot) {
                     var data=snapshot.data!.docs;
                     return SizedBox(
                       width: 500,
                       height: scrHeight*0.8,
                       child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                        return ListTile(
                        leading: Text("${index + 1}.",style: TextStyle(
                            color: colorConst.canvasColor,
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen?12:15
                                                 ),),
                        title: Text(data[index]["category"],style: TextStyle(
                            color: colorConst.canvasColor,
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen?12:15
                                             ),),
                        trailing: InkWell(
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
                                      Navigator.pop(context);
                                      await FirebaseFirestore.instance
                                          .collection("settings").doc(widget.name)
                                          .collection(widget.name).doc(data[index]["category"]).delete();
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
                            child: Icon(CupertinoIcons.delete,color: colorConst.red,)),
                        );
                        }),
                     );
                                  }
                                )
                  ],),
              )
              ,):
            SizedBox(
              width: scrHeight*0.6,
              child: Column(
                children: [
                  TextFormField(
                    controller: TextController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.canvasColor,
                    onFieldSubmitted: (value) {
                      settingsData();
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
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      if(
                      TextController.text!=""
                      ){
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
                ],
              ),
            ),
             Column(
                    children: [
                      widget.name=="FAQs"?
                      Column(
                        children: [
                          SizedBox(
                              width: scrWidth*0.4,
                              child: Column(
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection("settings").doc(widget.name).collection(widget.name).snapshots(),
                                        builder: (context, snapshot) {
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
                                    Container(
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
                                    Container(
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
                                        widget.name=="FAQs"?
                                        questionController.text !=""&&
                                            answerController.text !="":
                                        TextController.text!=""
                                        //formkey.currentState!.validate()

                                        ){
                                          widget.name=="FAQs"?addQN():
                                          settingsData();
                                        }
                                        else if(widget.name=="FAQs"){
                                          //TextController.text==""?
                                          questionController.text==""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Question"))):
                                          answerController.text==""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Answer"))):
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter details")));
                                        }
                                        else{
                                          TextController.text==""?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Text"))):
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
                          SizedBox(height: 20,),
                          Divider(),
                          Container(
                             height: scrHeight*0.4,
                             width: scrWidth*0.5,
                            //color: Colors.green,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: scrHeight*0.4,
                                    width: scrWidth*0.5,
                                    child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                                      stream: FirebaseFirestore.instance.collection('settings').doc(widget.name).collection(widget.name).snapshots(),
                                      builder: (context, snapshot) {
                                        if(!snapshot.hasData){
                                          return CircularProgressIndicator();
                                        }
                                        var data = snapshot.data!.docs;
                                        return ListView.separated(
                                          itemCount: 2,
                                          itemBuilder: (BuildContext context, int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                tap = !tap;
                                                setState(() {

                                                });
                                              },
                                              child: SizedBox(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(data[index]['category']),
                                                      Icon(CupertinoIcons.chevron_down)
                                                    ],
                                                  )),
                                            );
                                          },
                                          separatorBuilder: (BuildContext context, int index) => SizedBox(),
                                        );
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ):
                      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                        stream: FirebaseFirestore.instance.collection('settings')
                          .doc(widget.name).collection(widget.name).snapshots(),
                        builder: (context, snapshot) {
                            var data = snapshot.data!.docs;
                          return data.isEmpty?
                              Center(child: Text("No ${widget.name}"),)
                          :Center(
                            child: SizedBox(
                              width: scrWidth*0.5,
                              child: Text(data[0]['Text'])
                            ),
                          );
                        }
                      ),

                    ],
                  ),

                  ],
                ),
        ),
    );
  }
}
