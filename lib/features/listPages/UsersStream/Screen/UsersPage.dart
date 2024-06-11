import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/listPages/UsersStream/Controller/UsersControllerPage.dart';
import 'package:meat_admin/main.dart';
import 'package:meat_admin/models/userModel.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  TextEditingController search_controller = TextEditingController();
  List filteredUsers =[];
  bool search = false;
  List blockedUsers = [];
  List userData = [];

  void _search (String value){
    setState(() {
      filteredUsers = userData.where((map) {
        return map.name.toLowerCase().contains(value.toLowerCase()) ||
            map.number.contains(value) ||
            map.email.toLowerCase().contains(value.toLowerCase()) ||
            map.id.contains(value);
      }).toList();
    });
  }

  // void _search2(String value, List userdata) {
  //   users.clear();
  //   for (int i = 0; i < userdata.length; i++) {
  //     users.add({
  //       "name": userdata[i].name,
  //       "email": userdata[i].email,
  //       "number": userdata[i].number,
  //       "image": userdata[i].image,
  //       "id": userdata[i].id,
  //       "address": userdata[i].address,
  //     });
  //   }
  //     setState(() {
  //       filteredUsers = users.where((map) {
  //         return map['name'].toLowerCase().contains(value.toLowerCase()) ||
  //             map['number'].contains(value) ||
  //             map['email'].toLowerCase().contains(value.toLowerCase()) ||
  //             map['id'].contains(value);
  //       }).toList();
  //     });
  //   }
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final isHalfScreen = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: SizedBox(
        height: 100,
        width: isSmallScreen?scrWidth*1:500,
        child: ref.watch(streamUsersDataStreamProvider).when(
            data: (data){
               userData = data;
               search?null:
                   filteredUsers = data;
              return Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  //onChanged: (value) => _search(value),
                  onChanged: (value) {
                    //FirebaseFirestore.instance.collection("users").
                    // _search2(value,data);
                    _search(value);
                    search = true;
                    setState(() {

                    });
                  },
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: search_controller,
                  decoration: InputDecoration(
                    fillColor: colorConst.primaryColor,
                    filled: true,
                    constraints: BoxConstraints(
                      maxHeight: scrHeight*0.07,
                    ),
                    prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(CupertinoIcons.search)
                    ),
                    hintText: "Search in Users",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: colorConst.scaffoldBackgroundColor),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(scrWidth * 0.09),
                        borderSide: BorderSide(color: colorConst.scaffoldBackgroundColor)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(scrWidth * 0.09),
                        borderSide: BorderSide(color: colorConst.scaffoldBackgroundColor)),
                  ),
                ),
              );
            },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => Center(child: Lottie.asset(gifs.loadingGif)),
        )

      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          filteredUsers.isEmpty?
              Center(child: Text("No Users Found!")):
          SizedBox(
            height: scrHeight*1,
            width: isSmallScreen?scrWidth*1:scrWidth*0.8,
            //color: colorConst.green,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: filteredUsers.length,
              // shrinkWrap: true,
              padding: EdgeInsets.only(top: 100,left: 20,right: 20),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent:270,
                  crossAxisCount: isSmallScreen?1:isHalfScreen?2:3,
                  mainAxisSpacing: scrHeight*0.03,
                  crossAxisSpacing:scrHeight*0.03,
                  childAspectRatio: 2
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  //height: 100,
                  //width: scrHeight*0.01,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    //color: colorConst.primaryColor,
                      gradient: LinearGradient(colors: [
                        colorConst.mainColor,
                        colorConst.canvasColor
                      ]),
                      border: Border.all(color: colorConst.canvasColor),
                      borderRadius: BorderRadius.circular(scrHeight*0.03),
                      boxShadow: [
                        BoxShadow( color: colorConst.secondaryColor.withOpacity(0.15),
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(0, 4))
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: filteredUsers[index].image.isNotEmpty?
                        CircleAvatar(
                          backgroundImage:
                          NetworkImage(filteredUsers[index].image.toString()),
                          radius: 40,
                        )
                            : CircleAvatar(
                          backgroundImage:
                          AssetImage(imageConst.logo),
                          radius: 40,
                        ),
                      ),
                      //SizedBox(height: scrHeight*0.03,),
                      Text("Name:${filteredUsers[index].name}",
                          style: TextStyle(
                              color: colorConst.primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: scrHeight*0.02
                          )),
                      Text("Number:${filteredUsers[index].number}",
                          style: TextStyle(
                              color: colorConst.primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: scrHeight*0.02
                          )),
                      Text("email:${filteredUsers[index].email}",
                          style: TextStyle(
                              color: colorConst.primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: scrHeight*0.02
                          )),
                      Center(
                        child: InkWell(
                          onTap: (){
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  //title: Text(":${filteredUsers[index].address}"),
                                  //title: Text("User Details"),
                                  content: SizedBox(
                                    height: 350,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Center(
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(filteredUsers[index].image),
                                              radius: 50,
                                            ),
                                          ),
                                          Text("User Name: ${filteredUsers[index].name}"),
                                          Text("User Phone Number: ${filteredUsers[index].number}"),
                                          Text("User email: ${filteredUsers[index].email}"),
                                          Text("User id: ${filteredUsers[index].id}"),
                                          Container(
                                            //height: 250,
                                            //color: colorConst.green,
                                            child: Row(
                                              children: [
                                                Text("Address :"),
                                                //Text(filteredUsers[index].address.toString(),textAlign: TextAlign.center,),

                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: scrHeight*0.04,
                            //width: scrHeight*0.09,
                            margin:EdgeInsets.only(left: 20,right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(scrHeight*0.03),
                              color: colorConst.actionColor,
                            ),
                            child: Center(
                              child: Text("User Info",
                                style: TextStyle(
                                    fontSize:scrHeight*0.02 ,
                                    color: colorConst.primaryColor
                                ),),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              if(blockedUsers.contains(filteredUsers[index].id)){
                                blockedUsers.remove(filteredUsers[index].id);
                              }else{
                                blockedUsers.add(filteredUsers[index].id);
                              }
                              setState(() {

                              });
                            },
                            child: Container(
                              height: scrHeight*0.04,
                              width: 90,
                              //padding:EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(scrHeight*0.03),
                                color: blockedUsers.contains(filteredUsers[index].id)?colorConst.green:colorConst.red,
                              ),
                              child: Center(child: Text(blockedUsers.contains(filteredUsers[index].id)?"UnBlock":"Block",style: TextStyle(
                                //fontSize:scrHeight*0.02 ,
                                  color: colorConst.primaryColor
                              ))),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Are you sure you want to delete this User?",
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
                                            FirebaseFirestore.instance.collection("users").doc(filteredUsers[index]['id']).delete();
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
                            child: Container(
                              height: scrHeight*0.04,
                              width: 90,
                              //padding:EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(scrHeight*0.03),
                                color: colorConst.red,
                              ),
                              child: Center(child: Text(isSmallScreen?"Delete":"Delete",style: TextStyle(
                                //fontSize:scrHeight*0.02 ,
                                  color: colorConst.primaryColor
                              ))),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },

            ),
          )
        ],
      ),

    );
  }
}
