import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/listPages/MeatsEdit.dart';
import 'package:meat_admin/main.dart';

class MeatList extends StatefulWidget {
  final String type;
  const MeatList({super.key, required this.type});

  @override
  State<MeatList> createState() => _MeatListState();
}

class _MeatListState extends State<MeatList> {
  int selectIndex = -1;
  String selectCategory = '';
  List beefmeat = ["Beef cut", "Boneless Cut", "Liver", "Botti"];
  List? meatMap = [];
  getMeatData() async {
    var meats = await FirebaseFirestore.instance
        .collection("meatTypes")
        .where("type", isEqualTo: widget.type)
        .get();
    meatMap = meats.docs;
  }

  List categoryCollection = [];
  List meatCollection = [];
  getMeats() async {
    var category = await FirebaseFirestore.instance
        .collection("meatTypes")
        .doc(widget.type)
        .collection(widget.type)
        .get();
    categoryCollection = category.docs;
    setState(() {});
  }
  var users;
  var fav;
  List favUserId = [];
  List favId = [];
getUsers() async {
  var userCollection = await FirebaseFirestore.instance.collection("users").get();
  users = userCollection.docs;
  for (int i = 0; i < users.length; i++){
    fav = users[i]["favourites"];
    if (fav.isEmpty){
      //print("$i is empty");
    }else{
      favUserId.add(users[i]['id']);
      for (int j = 0; j < fav.length; j++){
        favId.add(fav[j]["id"]);
      }
    }
    //   if(data[index]["id"].contains(users[i]["favourites"][i]["id"])){
    //    print("yesssssss");
    //   }else{
    //     print("nooooooooo");
    //   }
  }
}
  @override
  void initState() {
    getMeats();
    getUsers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            print(meatMap!);
          },
          child: Text("${widget.type} Adding Page",
              style: TextStyle(color: colorConst.primaryColor)),
        ),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body: Row(
        children: [
          SizedBox(
            width: scrHeight * 0.3,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: scrHeight * 0.08,
                width: scrHeight * 1.3,
                child: ListView.separated(
                  itemCount: categoryCollection.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectIndex = index;
                        selectCategory = categoryCollection[index]["category"];
                        setState(() {});
                      },
                      child: Container(
                        height: scrHeight * 0.07,
                        width: scrHeight * 0.25,
                        margin: EdgeInsets.only(right: scrWidth * 0.04),
                        child: Center(
                          child: Text(
                            categoryCollection[index]['category'],
                            style: TextStyle(
                                color: selectIndex == index
                                    ? colorConst.primaryColor
                                    : colorConst.secondaryColor
                                        .withOpacity(0.5),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(scrWidth * 0.05),
                            color: selectIndex == index
                                ? colorConst.mainColor
                                : colorConst.primaryColor,
                            border: Border.all(
                              color: selectIndex == index
                                  ? colorConst.mainColor
                                  : colorConst.secondaryColor.withOpacity(0.5),
                            )),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: scrHeight * 0.01,
                    );
                  },
                ),
              ),
              Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: scrHeight * 0.8,
                      width: scrHeight * 1.7,
                      child: categoryCollection.isEmpty
                          ? Center(child: Lottie.asset(gifs.loadingGif))
                          : StreamBuilder<QuerySnapshot>(
                              stream: selectCategory == ""
                                  ? FirebaseFirestore.instance
                                      .collection('meatTypes')
                                      .doc(widget.type)
                                      .collection(widget.type)
                                      .doc(categoryCollection[0]["category"])
                                      .collection(widget.type)
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection("meatTypes")
                                      .doc(widget.type)
                                      .collection(widget.type)
                                      .doc(selectCategory)
                                      .collection(widget.type)
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Lottie.asset(gifs.loadingGif);
                                }
                                var data = snapshot.data!.docs;
                                return data.length == 0
                                    ? Text("No Meats Available!")
                                    : ListView.separated(
                                      itemCount: data.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context,
                                          int index) {
                                        return Container(
                                          height: scrHeight * 0.3,
                                          width: scrHeight * 1.7,
                                          decoration: BoxDecoration(
                                              color:
                                                  colorConst.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      scrHeight * 0.03),
                                              border: Border.all(
                                                  color:
                                                      colorConst.mainColor),
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
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                            children: [
                                              CircleAvatar(
                                                radius: scrHeight * 0.13,
                                                backgroundImage:
                                                    NetworkImage(data[index]
                                                        ["Image"]),
                                              ),
                                              SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "NAME:${data[index]["name"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize:
                                                              scrWidth *
                                                                  0.01),
                                                    ),
                                                    Text(
                                                      "INGREDIENTS:${data[index]["ingredients"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize:
                                                              scrWidth *
                                                                  0.01),
                                                    ),
                                                    Text(
                                                      "PRICE:${data[index]["rate"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize:
                                                              scrWidth *
                                                                  0.01),
                                                    ),
                                                    Text(
                                                      "QUANTITY: 1 KG - ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize:
                                                              scrWidth *
                                                                  0.01),
                                                    ),
                                                    Text(
                                                      "DESCRIPTION:${data[index]["description"]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize:
                                                              scrWidth *
                                                                  0.01),
                                                    ),
                                                    // Text(
                                                    //   "Type:${data[index]["type"]}",
                                                    //   style: TextStyle(
                                                    //       fontWeight:
                                                    //           FontWeight.w600,
                                                    //       fontSize:
                                                    //           scrWidth * 0.01),
                                                    // ),
                                                    // Text(
                                                    //   "Category:${data[index]["category"]}",
                                                    //   style: TextStyle(
                                                    //       fontWeight:
                                                    //           FontWeight.w600,
                                                    //       fontSize:
                                                    //           scrWidth * 0.01),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MeatsEdit(
                                                                id: data[index].id,
                                                                Image: data[index]['Image'],
                                                                name: data[index]['name'],
                                                                rate: data[index]['rate'].toString(),
                                                                ingredients: data[index]['ingredients'],
                                                                description: data[index]['description'],
                                                                quantity: data[index]['quantity'].toString(),
                                                                category: selectCategory.isEmpty?
                                                                categoryCollection[0]["category"]
                                                                        :selectCategory,
                                                                        type: widget.type,

                                                              ),
                                                            ));
                                                      },
                                                      child:
                                                          Icon(Icons.edit)),
                                                  InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text("Are you sure you want to delete this Item?",
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
                                                                      height: scrHeight*0.04,
                                                                      width: scrWidth*0.1,
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
                                                                      // FirebaseFirestore.instance.collection('meatTypes').doc(widget.type)
                                                                      //     .collection(widget.type).doc(selectCategory)
                                                                      //     .collection(widget.type).doc(data[index]["id"])
                                                                      //     .delete();

                                                                      if (favId.contains(data[index]["id"])){

                                                                      }else{
                                                                        print("NOOOOOOOOOOO");
                                                                      }
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      height: scrHeight*0.04,
                                                                      width: scrWidth*0.1,
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

                                                      child: Icon(
                                                          Icons.delete)),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context,
                                              int index) {
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
