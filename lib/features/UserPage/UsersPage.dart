import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/IntroPages/splashScreen.dart';
import 'package:meat_admin/features/UserPage/UsersControllerPage.dart';
import 'package:meat_admin/main.dart';
import 'package:meat_admin/models/userModel.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  TextEditingController search_controller = TextEditingController();
  final searchProvider = StateProvider<TextEditingController?>((ref) => null);
  // bool search = false;
  // List userData = [];

  // void _search (String value){
  //   setState(() {
  //     filteredUsers = userData.where((map) {
  //       return map.name.toLowerCase().contains(value.toLowerCase()) ||
  //           map.number.contains(value) ||
  //           map.email.toLowerCase().contains(value.toLowerCase()) ||
  //           map.id.contains(value);
  //     }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final isHalfScreen = MediaQuery.of(context).size.width < 900;
    final search = ref.watch(searchProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: SizedBox(
        height: 100,
        width: isSmallScreen?scrWidth*1:500,
        child: Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  // onTap: () async{
                  //   var data = await FirebaseFirestore.instance.collection('users').get();
                  //   for(var data in data.docs){
                  //     print(data['name']);
                  //
                  //     FirebaseFirestore.instance.collection('users').doc(data.id).update(
                  //         {
                  //           'search':setSearchParam("${data['name']} ${data['number']} ${data['email']}")
                  //         });
                  //
                  //   }
                  //
                  // },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  //onChanged: (value) => _search(value),
                  onChanged: (value) {
                   // ref.read(searchProvider.notifier).update((state) => search_controller);
                      setState(() { });
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
              )
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ref.watch(streamUsersDataStreamProvider(search_controller.text.toUpperCase())).when(
              data: (data) {
                return SizedBox(
                  height: scrHeight*1,
                  width: isSmallScreen?scrWidth*1:scrWidth*0.8,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
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
                              child: data[index].image.isNotEmpty?
                              CircleAvatar(
                                backgroundImage:
                                NetworkImage(data[index].image.toString()),
                                radius: 40,
                              )
                                  : CircleAvatar(
                                backgroundImage:
                                AssetImage(imageConst.logo),
                                radius: 40,
                              ),
                            ),
                            //SizedBox(height: scrHeight*0.03,),
                            Text("Name:${data[index].name}",
                                style: TextStyle(
                                    color: colorConst.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: scrHeight*0.02
                                )),
                            Text("Number:${data[index].number}",
                                style: TextStyle(
                                    color: colorConst.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: scrHeight*0.02
                                )),
                            Text("email:${data[index].email}",
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
                                          //height: 350,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Center(
                                                    child: data[index].image.isNotEmpty?
                                                    CircleAvatar(
                                                      backgroundImage:
                                                      NetworkImage(data[index].image.toString()),
                                                      radius: 40,
                                                    )
                                                        : CircleAvatar(
                                                      backgroundImage:
                                                      AssetImage(imageConst.logo),
                                                      radius: 40,
                                                    ),
                                                  ),
                                                  Text("User Name: ${data[index].name}"),
                                                  Text("User Phone Number: ${data[index].number}"),
                                                  Text("User email: ${data[index].email}"),
                                                  Text("User id: ${data[index].id}"),
                                                  Center(child: Text("Address",style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  ),)),
                                                  SizedBox(
                                                    height: 200,
                                                    width: 250,
                                                    child: ListView.separated(
                                                      separatorBuilder: (context, index) => Divider(),
                                                      itemCount: data[index].address.length,
                                                      itemBuilder: (context, index2) {
                                                        var address = data[index].address;
                                                        return Column(
                                                          children: [
                                                            SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('${address[index2]['type']} : ',style: TextStyle(
                                                                      color: colorConst.mainColor
                                                                  ),),
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text('${address[index2]['buildingName']}, '
                                                                            '${address[index2]['street']}, '
                                                                            '${address[index2]['town']}, '
                                                                            '${address[index2]['pincode']}'
                                                                        ),
                                                                        Text('Location : ${address[index2]['location']}')
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },),
                                                  )
                                                ],
                                              ),
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
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(data[index].blocked?"Are you sure you want to unblock this User?"
                                              :"Are you sure you want to block this User?",
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
                                                  HapticFeedback.lightImpact();
                                                  await FirebaseFirestore.instance.collection('users').doc(data[index].id).update({
                                                    "blocked" : data[index].blocked? false:true
                                                  });
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
                                      color: data[index].blocked?colorConst.green:
                                      colorConst.red,
                                    ),
                                    child: Center(child: Text(
                                        data[index].blocked?"UnBlock":
                                        "Block",style: TextStyle(
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
                                              )),
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
                                                  FirebaseFirestore.instance.collection("users").doc(data[index].id).delete();
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
                                    child: Center(child: Text("Delete",style: TextStyle(
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
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => Center(child: Lottie.asset(gifs.loadingGif)),
          )

        ],
      ),

    );
  }
}


setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";

  List<String> nameSplits = caseNumber.split(" ");
  for (int i = 0; i < nameSplits.length; i++) {
    String name = "";
    for (int k = i; k < nameSplits.length; k++) {
      name =
      i == nameSplits.length - 1 ? name + nameSplits[k] : name + nameSplits[k] +
          " ";
    }
    temp = "";

    for (int j = 0; j < name.length; j++) {
      temp = temp + name[j];
      caseSearchList.add(temp.toUpperCase());
    }
  }
  return caseSearchList;
}