import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/Meats/screen/MeatsEdit.dart';
import 'package:meat_admin/main.dart';

import 'AddMeats.dart';

class MeatList extends StatefulWidget {
  final String type;
  const MeatList({super.key, required this.type});

  @override
  State<MeatList> createState() => _MeatListState();
}

class _MeatListState extends State<MeatList> {
  int selectIndex = 0;
  String selectCategory = '';
  //List beefmeat = ["Beef cut", "Boneless Cut", "Liver", "Botti"];
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
deleteProduct(String productId) async {
  var userCollection = await FirebaseFirestore.instance.collection("users").get();
  users = userCollection.docs;
  for (int i = 0; i < users.length; i++){
    var favourites = users[i]["favourites"];
    if (favourites.isNotEmpty){
      for(int j=0;j<favourites.length;j++){
        if(favourites[j]["id"]==productId){
          favourites.remove(favourites[j]);
          FirebaseFirestore.instance.collection("users").doc(users[i]["id"]).update({
            "favourites": favourites
          });
        }
      }
    }
  }
}
  @override
  void initState() {
    getMeats();
    // getUsers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isSmallScreen?
      InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeats(type: widget.type,),));
        },
        child: Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorConst.canvasColor),
              // color: colorConst.mainColor
              gradient: LinearGradient(colors: [
                colorConst.thirdColor,
                colorConst.canvasColor
              ])
          ),
          child: Center(
            child: Text("Add New Meat",style: TextStyle(
                color: colorConst.primaryColor,
                fontWeight: FontWeight.w500
            ),),
          ),
        ),
      ):SizedBox(),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.arrow_left,color: colorConst.primaryColor,),
      ),
        title: Text("${widget.type} Adding Page",
            style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.canvasColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            if(!isSmallScreen)
              SizedBox(
                height: scrHeight*1,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child:InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddMeats(type: widget.type,),));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: colorConst.primaryColor,
                            borderRadius: BorderRadius.circular(scrHeight*0.03),
                            border: Border.all(color: colorConst.canvasColor),
                            gradient: LinearGradient(
                                colors: [
                                  colorConst.thirdColor,
                                  colorConst.canvasColor
                                ]
                            ),
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
                            Icon(Icons.add_box_outlined,size: scrHeight*0.05,
                              color:colorConst.primaryColor ,
                            ),
                            Center(child: Text("Add New Meat",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: colorConst.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: scrHeight*0.02
                              ),)),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: isSmallScreen?scrWidth*1:scrWidth*0.6,
                    //color: Colors.green,
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
                            height: 10,
                            //width: scrWidth*0.2,
                            padding: EdgeInsets.only(right: 20,left: 20),
                            child: Center(
                              child: Text(
                                categoryCollection[index]['category'],
                                style: TextStyle(
                                    color: selectIndex == index
                                        ? colorConst.primaryColor
                                        : colorConst.canvasColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(scrWidth * 0.05),
                                // color: selectIndex == index
                                //     ? colorConst.mainColor
                                //     : colorConst.primaryColor,
                                gradient:selectIndex == index?
                                    LinearGradient(colors: [
                                      colorConst.mainColor,
                                      colorConst.canvasColor
                                    ]):LinearGradient(
                                    colors: [
                                      colorConst.primaryColor,
                                      colorConst.primaryColor
                                    ]
                                ),
                                border: Border.all(
                                  color:colorConst.canvasColor
                                )),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 20,
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: scrHeight*0.75,
                          width: scrWidth*1,
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
                                        ? Center(child: Text("No Meats Available!"))
                                        : ListView.separated(
                                          itemCount: data.length,
                                          //shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  // color: colorConst.primaryColor,
                                                gradient: LinearGradient(colors: [
                                                  colorConst.mainColor,
                                                  colorConst.canvasColor
                                                ]),
                                                  borderRadius: BorderRadius.circular(scrHeight * 0.03),
                                                  border: Border.all(color: colorConst.canvasColor),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: colorConst.secondaryColor.withOpacity(0.5),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2))
                                                  ]),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  CircleAvatar(
                                                    radius: isSmallScreen?40:50,
                                                    backgroundImage:
                                                        NetworkImage(data[index]
                                                            ["Image"]),
                                                  ),
                                                  SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "NAME: ${data[index]["name"]}", style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: isSmallScreen?12:15,
                                                              color: colorConst.primaryColor
                                                           )),
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            "INGREDIENTS:${data[index]["ingredients"]}", style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: isSmallScreen?12:15,
                                                              color: colorConst.primaryColor
                                                          ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "PRICE: ${data[index]["rate"]}", style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: isSmallScreen?12:15,
                                                            color: colorConst.primaryColor
                                                        )),
                                                        Text(
                                                          "QUANTITY: ${data[index]["quantity"]}", style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: isSmallScreen?12:15,
                                                            color: colorConst.primaryColor
                                                        )),
                                                        // Text(
                                                        //   "DESCRIPTION:${data[index]["description"]}",
                                                        //   style: TextStyle(
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w600,
                                                        //       fontSize:
                                                        //           scrWidth *
                                                        //               0.01),
                                                        // ),
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
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MeatsEdit(
                                                                    id: data[index]["id"],
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
                                                              Icon(Icons.edit,color: colorConst.green,)),
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
                                                                          FirebaseFirestore.instance.collection('meatTypes').doc(widget.type)
                                                                              .collection(widget.type).doc(selectCategory)
                                                                              .collection(widget.type).doc(data[index]["id"])
                                                                              .delete();
                                                                          // for(var keys in favouriteMap.keys){
                                                                          //   for(int k = 0; k<favouriteMap[keys].length; k++){
                                                                          //       print('${favouriteMap[keys][k]["id"]}');
                                                                          //     //print(data[index]["id"]);
                                                                          //     if(data[index]["id"] == favouriteMap[keys][k]["id"]){
                                                                          //       print("YESSSSSSSSS");
                                                                          //     }else{
                                                                          //       print("NOOOOOOOOOO");
                                                                          //     }
                                                                          //   }
                                                                          // }
                                                                          deleteProduct(data[index]["id"]);
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

                                                          child: Icon(CupertinoIcons.delete,color: colorConst.red,)),
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
                                              height: 20,
                                            );
                                          },
                                        );
                                  }),
                        ),
                      ),
                    ],
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
