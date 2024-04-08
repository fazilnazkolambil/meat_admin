import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meat_admin/core/colorPage.dart';

import '../../main.dart';

class MuttonList extends StatefulWidget {
  const MuttonList({super.key});

  @override
  State<MuttonList> createState() => _MuttonListState();
}

class _MuttonListState extends State<MuttonList> {
  int selectIndex = -1;
  String selectCategory = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mutton List",
            style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body: Row(
        children: [
          SizedBox(
            width: scrHeight * 0.5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  height: scrHeight * 0.08,
                  width: scrHeight * 1.3,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('category')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        var data = snapshot.data!.docs;
                        return data.length == 0
                            ? Text("No categories found!")
                            : ListView.separated(
                                itemCount: data.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectIndex = index;
                                      selectCategory = data[index]["category"];
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: scrHeight * 0.07,
                                      width: scrHeight * 0.25,
                                      margin: EdgeInsets.only(
                                          right: scrWidth * 0.04),
                                      child: Center(
                                        child: Text(
                                          data[index]['category'],
                                          style: TextStyle(
                                              color: selectIndex == index
                                                  ? colorConst.primaryColor
                                                  : colorConst.secondaryColor
                                                      .withOpacity(0.5),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              scrWidth * 0.05),
                                          color: selectIndex == index
                                              ? colorConst.mainColor
                                              : colorConst.primaryColor,
                                          border: Border.all(
                                            color: selectIndex == index
                                                ? colorConst.mainColor
                                                : colorConst.secondaryColor
                                                    .withOpacity(0.5),
                                          )),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: scrHeight * 0.01,
                                  );
                                },
                              );
                      })),
              Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: scrHeight * 0.8,
                      width: scrHeight * 1.3,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: selectCategory == ""
                              ? FirebaseFirestore.instance
                                  .collection('meats')
                                  .where('type', isEqualTo: "Mutton")
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection("meats")
                                  .where('type', isEqualTo: "Mutton")
                                  .where('category', isEqualTo: selectCategory)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            var data = snapshot.data!.docs;
                            return data.length == 0
                                ? Text("No Meats found!")
                                : ListView.separated(
                                    itemCount: data.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: scrHeight * 0.3,
                                        width: scrHeight * 1.3,
                                        decoration: BoxDecoration(
                                            color: colorConst.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                                scrHeight * 0.03),
                                            border: Border.all(
                                                color: colorConst.mainColor),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: colorConst
                                                      .secondaryColor
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                              radius: scrHeight * 0.13,
                                              backgroundImage: NetworkImage(
                                                  data[index]["Image"]),
                                            ),
                                            SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "NAME:${data[index]["name"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                  Text(
                                                    "INGREDIENTS:${data[index]["ingredients"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                  Text(
                                                    "PRICE:${data[index]["rate"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                  Text(
                                                    "QUANTITY:${data[index]["quantity"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                  Text(
                                                    "DESCRIPTION:${data[index]["description"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                  Text(
                                                    "Type:${data[index]["type"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                  Text(
                                                    "Category:${data[index]["category"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            scrWidth * 0.01),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(Icons.edit),
                                                InkWell(
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection('meats')
                                                          .doc(data[index].id)
                                                          .delete();
                                                    },
                                                    child: Icon(Icons.delete)),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: scrHeight * 0.05,
                                      );
                                    },
                                  );
                          }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
