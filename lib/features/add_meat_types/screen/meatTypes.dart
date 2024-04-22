import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/add_meat_types/controller/controller_page.dart';
import 'package:meat_admin/features/addingPages/screen/AddMeats.dart';
import 'package:meat_admin/unWanted/AddCategory.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/main.dart';

import 'AddMeatTypes.dart';

class MeatTypes extends ConsumerStatefulWidget {
  const MeatTypes({super.key});

  @override
  ConsumerState<MeatTypes> createState() => _MeatTypesState();
}

class _MeatTypesState extends ConsumerState<MeatTypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Types of Meats",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeatTypes(),));
              },
              child: Container(
                height: scrHeight*0.2,
                width: scrWidth*0.1,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box_outlined,size: scrHeight*0.05,),
                    Center(child: Text("Add Meat Types",style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: scrHeight*0.02
                    ),)),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: scrHeight*0.9,
              width: scrWidth*0.5,
              child:
          // StreamBuilder(
              //   stream: FirebaseFirestore.instance.collection("meatTypes").snapshots(),
              //   builder: (context, snapshot) {
              //     if(!snapshot.hasData)
              //       return Lottie.asset(gifs.loadingGif);
              //     var data = snapshot.data!.docs;
              //     return data.length == 0?
              //     Center(child: Text("No Types Found"),):
              //
              //   }
          ref.watch(streamCategoryProvider).when(
              data: (data) {
                return
                ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeats(type: data[index].type),));
                      },
                      child: Container(
                          height: scrHeight*0.2,
                          width: scrWidth*0.3,
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
                                radius: scrHeight*0.09,
                                backgroundImage: NetworkImage(data[index].mainImage),
                              ),
                              Center(child: Text("Add ${data[index].type}",style: TextStyle(
                                  fontSize: scrHeight*0.025,
                                  fontWeight: FontWeight.w700
                              ),)),
                              Icon(CupertinoIcons.forward)
                            ],
                          )
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: scrHeight*0.03,);
                  },
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => Lottie.asset(gifs.loadingGif),)
              )
          ],
        ),
      ],
            ),
    );
  }
}
