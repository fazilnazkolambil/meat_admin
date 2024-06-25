import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';

import '../../main.dart';
import '../IntroPages/splashScreen.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {

  TextEditingController categoryController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RegExp emailValidation = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  String? chooseAdmin;
  final formkey = GlobalKey<FormState>();
  addCategory()async{
    if(categoryController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("admins").doc(categoryController.text).set({
        "role" : categoryController.text,
      }).then((value){
        categoryController.clear();
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the role of Admin!")));
    }

  }
  List userNames = [];
  bool sameUser = false;

  addAdmin()async{
      if(
      chooseAdmin != null &&
          !userNames.contains(usernameController.text) &&
      usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text == passwordController.text&&
      formkey.currentState!.validate()
      ){
        await FirebaseFirestore.instance.collection("admins").doc(chooseAdmin).collection('$chooseAdmin').add({
          "userEmail": usernameController.text,
          "password": passwordController.text,
          "role": chooseAdmin.toString()
        }).then((value) {
          chooseAdmin = null;
          usernameController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Admin added Successfully")));
        });
      }else{
        chooseAdmin == null? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Choose an Admin type!"))):
        usernameController.text.isEmpty? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter a valid Email!"))):
        passwordController.text.isEmpty? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter a Password"))):
        confirmPasswordController.text.isEmpty? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Confirm the Password"))):
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid details")));
      }


  }
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: colorConst.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(scrWidth*0.03),
          child: Column(
            children: [
              currentUser == "SuperAdmin"?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isSmallScreen?scrWidth*0.8:scrWidth*0.4,
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
                        constraints: BoxConstraints.expand(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          label: Text("Add admin type",style: TextStyle(
                              fontSize: isSmallScreen?10:15
                          ),),
                          hintText: "Enter the Admin type",
                          hintStyle: TextStyle(
                              fontSize: isSmallScreen?10:15
                          )),
                    ),
                  ),
                  SizedBox(width: 20,),
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
              ):SizedBox(),
              SizedBox(height: 10,),
              currentUser == "SuperAdmin"?
              StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("admins").snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: Lottie.asset(gifs.loadingGif,height:100 ));
                    }
                    var data=snapshot.data!.docs;
                    return SizedBox(
                        width: isSmallScreen?scrWidth*0.5:scrWidth*0.3,
                        height: scrHeight*0.3,
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
                                        fontSize: isSmallScreen?13:15
                                    )),
                                    Text(data[index]["role"],style: TextStyle(
                                        color: colorConst.canvasColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallScreen?13:15
                                    )),
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Are you sure you want to delete this Admin?",
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
                                                        chooseAdmin = null;
                                                        Navigator.pop(context);
                                                        await FirebaseFirestore.instance
                                                            .collection("admins").doc(data[index]["role"]).delete();
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
              ):SizedBox(),
              SizedBox(
                  width: isSmallScreen?scrWidth*0.8:scrWidth*0.4,
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection("admins").snapshots(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData){
                                return Center(child: Text("Loading..."),);
                              }
                              var data=snapshot.data!.docs;
                              return data.isEmpty?Text('No Admins added')
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
                                      "Select Admin type",
                                      style: TextStyle(
                                          color: colorConst.secondaryColor,
                                          fontSize: isSmallScreen?12:15
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: colorConst.secondaryColor),
                                    value: chooseAdmin,
                                    items: List.generate(data.length,
                                            (index) => data[index]['role']).map((e) {
                                      return DropdownMenuItem(
                                          value: e, child: Text(e));
                                    }).toList(),
                                    onChanged: (value) {
                                      currentUser == "SuperAdmin"?
                                      chooseAdmin = value.toString()
                                          :chooseAdmin = "DeliveryBoy";
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            }
                        ),
                        SizedBox(height: scrHeight*0.05,),
                        TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (!emailValidation.hasMatch(value!)) {
                              return "enter a valid Email";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            //suffixIcon: sameUser?Icon(Icons.close,color: Colors.red,):Icon(Icons.done,color: Colors.green,),
                              contentPadding: EdgeInsets.all(10),
                              labelText:"Email",
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
                        SizedBox(height: scrHeight*0.03,),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText:"Password",
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
                        SizedBox(height: scrHeight*0.03,),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (confirmPasswordController.text !=
                                passwordController.text) {
                              return "Password does not match";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText:"Confirm Password",
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
                        SizedBox(height: scrHeight*0.03,),
                        InkWell(
                          onTap: (){
                            addAdmin();
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
                        )
                      ],
                    ),
                  )
              ),
            ],),
        ),
      ),
    );
  }
}
