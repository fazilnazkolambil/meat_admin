import 'dart:js';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import '../main.dart';


var _listItems=[
  "Ordered", "Packed","Out for delivery","delivered",
];

class OrderStatusList extends ConsumerWidget {
  final QuerySnapshot<Map<String, dynamic>> data;
  final bool isSmallScreen;
  final bool isHalfScreen;
  final String status;

   OrderStatusList({super.key,
    required this.data,
    required this.isSmallScreen,
    required this.isHalfScreen,
    required this.status,
  });



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String nextStatus = '';
    for(int i = 0; i < _listItems.length; i++){
      if(_listItems[i] == status){
        if(i < _listItems.length-1){
          nextStatus = _listItems[i + 1];
          break;
        }else{
          nextStatus = _listItems[i];
        }

      }
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isSmallScreen || isHalfScreen?2:4
      ),
        itemCount: data.docs.where((element) => element["orderStatus"] == status).length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
        print(data.docs[index]['orderId']);
        String dateString = '${data.docs[index]['orderDate']},${data.docs[index]['orderTime']}';//
        DateFormat dateFormat = DateFormat("EEEE, MMMM d, y,h:mm a"); //
        DateTime dateTime = dateFormat.parse(dateString);
          return Container(
            //height: 70,
            margin: EdgeInsets.all(scrHeight * 0.01),
            decoration: BoxDecoration(
              //color: colorConst.primaryColor,
                gradient: LinearGradient(colors: [
                  colorConst.mainColor,
                  colorConst.canvasColor
                ]),
                borderRadius: BorderRadius.circular(
                    scrHeight * 0.03),
                border: Border.all(
                    color: colorConst.canvasColor),
                boxShadow: [
                  BoxShadow(
                      color: colorConst.secondaryColor
                          .withOpacity(0.5),
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ]),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "ID: ${data.docs[index]['orderId']}",
                  //"Delivery Time: $dateTime",
                  style: TextStyle(
                      fontSize:
                      isSmallScreen ? 12 : 15,
                      fontWeight: FontWeight.w700,
                      color:
                      colorConst.primaryColor),
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context){
                      return AlertDialog(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                                text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: "Order Date: ",
                                          style: TextStyle(
                                              color: colorConst.mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      TextSpan(
                                          text: data.docs[index]['orderDate'],
                                          style: const TextStyle(
                                              color: colorConst.canvasColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20))
                                    ])),
                            RichText(
                                text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: "Order Time: ",
                                          style: TextStyle(
                                              color: colorConst.mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      TextSpan(
                                          text: data.docs[index]['orderTime'],
                                          style: const TextStyle(
                                              color: colorConst.canvasColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20))
                                    ])),
                            RichText(
                                text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: "Payment Status: ",
                                          style: TextStyle(
                                              color: colorConst.mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      TextSpan(
                                          text: data.docs[index]['paymentStatus'],
                                          style: const TextStyle(
                                              color: colorConst.canvasColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20))
                                    ])),
                            RichText(
                                text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: "Total Price: ",
                                          style: TextStyle(
                                              color: colorConst.mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      TextSpan(
                                          text: data.docs[index]['totalPrice'].toString(),
                                          style: const TextStyle(
                                              color: colorConst.canvasColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20))
                                    ])),
                            RichText(
                                text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: "Order Id: ",
                                          style: TextStyle(
                                              color: colorConst.mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      TextSpan(
                                          text: data.docs[index]["orderId"].toString(),
                                          style: const TextStyle(
                                              color: colorConst.canvasColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20))
                                    ])),
                          ],
                        ),
                      );
                    }
                    );
                  },
                  child: Container(
                    height: scrHeight * 0.05,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            scrHeight * 0.03),
                        color:
                        colorConst.actionColor),
                    child: Center(
                      child: Text(
                        "Order details",
                        style: TextStyle(
                            fontSize: isSmallScreen
                                ? 12
                                : 15,
                            color: colorConst
                                .primaryColor),
                      ),

                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    var itemsData = data.docs[index]['items'];
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            content: SizedBox(
                              height: 500,
                              width: scrWidth*0.5,
                              child: ListView.separated(
                                itemCount: itemsData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 250,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                      text: "Item Name: ",
                                                      style: TextStyle(
                                                          color: colorConst.mainColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20)),
                                                  TextSpan(
                                                      text: itemsData[index]['name'],
                                                      style: const TextStyle(
                                                          color: colorConst.canvasColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20))
                                                ])),
                                        RichText(
                                            text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                      text: "Item Quantity: ",
                                                      style: TextStyle(
                                                          color: colorConst.mainColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20)),
                                                  TextSpan(
                                                      text: '${itemsData[index]['quantity']} KG',
                                                      style: const TextStyle(
                                                          color: colorConst.canvasColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20))
                                                ])),
                                        RichText(
                                            text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                      text: "Item Notes: ",
                                                      style: TextStyle(
                                                          color: colorConst.mainColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20)),
                                                  TextSpan(
                                                      text: itemsData[index]['notes'],
                                                      style: const TextStyle(
                                                          color: colorConst.canvasColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20))
                                                ])),
                                        RichText(
                                            text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                      text: "Item Rate: ",
                                                      style: TextStyle(
                                                          color: colorConst.mainColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20)),
                                                  TextSpan(
                                                      text: itemsData[index]['rate'].toString(),
                                                      style: const TextStyle(
                                                          color: colorConst.canvasColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20))
                                                ])),
                                        RichText(
                                            text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                      text: "Item Ingrediants: ",
                                                      style: TextStyle(
                                                          color: colorConst.mainColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20)),
                                                  TextSpan(
                                                      text: itemsData[index]['ingredients'],
                                                      style: const TextStyle(
                                                          color: colorConst.canvasColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20))
                                                ])),
                                        RichText(
                                            text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                      text: "Item Id: ",
                                                      style: TextStyle(
                                                          color: colorConst.mainColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20)),
                                                  TextSpan(
                                                      text: itemsData[index]['id'],
                                                      style: const TextStyle(
                                                          color: colorConst.canvasColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 20))
                                                ])),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider();
                                },

                              ),
                            )
                          );
                        }
                    );
                  },
                  child: Container(
                    height: scrHeight * 0.05,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            scrHeight * 0.03),
                        color:
                        colorConst.actionColor),
                    child: Center(
                      child: Text(
                        "Items",
                        style: TextStyle(
                            fontSize: isSmallScreen
                                ? 12
                                : 15,
                            color: colorConst
                                .primaryColor),
                      ),

                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var address = data.docs[index]['deliveryAddress'];
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,
                            children: [
                              // Text("Name:${users.data()!['name']}"),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: "Name: ",
                                            style: TextStyle(
                                                color: colorConst.mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                        TextSpan(
                                            text: address['name'],
                                            style: const TextStyle(
                                                color: colorConst.canvasColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20))
                                      ])),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                       const TextSpan(
                                            text: "Phone: ",
                                            style: TextStyle(
                                                color: colorConst.mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                        TextSpan(
                                            text: address['number'],
                                            //users.data()!['email'],
                                            style:const TextStyle(
                                                color: colorConst.canvasColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20
                                            ))
                                      ])),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                       const TextSpan(
                                            text: "Address: ",
                                            style: TextStyle(
                                                color: colorConst.mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                        TextSpan(
                                            text: "${address['buildingName']},"
                                                " ${address['street']},"
                                                "  ${address['town']}, ${address['pincode']},"
                                                ,
                                            //users.data()!['number'],
                                            style: const TextStyle(
                                                color: colorConst.canvasColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20))
                                      ])),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: "Location: ",
                                            style: TextStyle(
                                                color: colorConst.mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                        TextSpan(
                                            text: address['location'],
                                            //users.data()!['email'],
                                            style:const TextStyle(
                                                color: colorConst.canvasColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20
                                            ))
                                      ])),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: "Delivery Instructions: ",
                                            style: TextStyle(
                                                color: colorConst.mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                        TextSpan(
                                            text: address['deliveryInstruction'],
                                            //users.data()!['email'],
                                            style:const TextStyle(
                                                color: colorConst.canvasColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20
                                            )
                                        )
                                      ]
                                  )
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: scrHeight * 0.05,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            scrHeight * 0.03),
                        color:
                        colorConst.actionColor),
                    child: Center(
                      child: Text(
                        "Delivery Address",
                        style: TextStyle(
                            fontSize: isSmallScreen
                                ? 12
                                : 15,
                            color: colorConst
                                .primaryColor),
                      ),
                    ),
                  ),
                ),
               status == _listItems.last?
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       Container(
                         height: scrHeight * 0.05,
                         padding: EdgeInsets.symmetric(horizontal: 10),
                         //margin: EdgeInsets.symmetric(horizontal: 50),
                         decoration: BoxDecoration(
                           color: colorConst.green,
                         ),
                         child: Center(child: Text('Item Delivered',style: TextStyle(
                             color: colorConst.primaryColor,
                             fontWeight: FontWeight.w500
                         ),
                           textAlign: TextAlign.center,
                         )),
                       ),
                       IconButton(
                           onPressed: () {
                               showDialog(
                                 barrierDismissible: false,
                                 context: context,
                                 builder: (context) {
                                   return AlertDialog(
                                     title: Text("Are you sure you want to remove this order permanently?",
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
                                             await FirebaseFirestore.instance.collection('orderDetails').doc(data.docs[index]['orderId']).delete();
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
                   ):
               InkWell(
                 onTap: () {
                   showDialog(
                     barrierDismissible: false,
                     context: context,
                     builder: (context) {
                       return AlertDialog(
                         title: Text("Are you sure this order is $nextStatus?",
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
                                 // if(status == "Out for delivery"){
                                 //   await FirebaseFirestore.instance.collection('orderDetails').doc(data.docs[index]['orderId']).update({
                                 //     "orderStatus" : _listItems.last
                                 //   });
                                 // } else{
                                 print(data.docs[index]['orderId']);
                                 print(nextStatus);
                                   await FirebaseFirestore.instance.collection('orderDetails').doc(data.docs[index]['orderId']).update({
                                     "orderStatus" : nextStatus
                                   });
                                 // }



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
                   height: scrHeight * 0.05,
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   margin: EdgeInsets.symmetric(horizontal: 50),
                   decoration: BoxDecoration(
                     color: colorConst.red,
                   ),
                   child: Center(child: Text('Move to $nextStatus',style: TextStyle(
                     color: colorConst.primaryColor,
                     fontWeight: FontWeight.w500,
                     fontSize: isSmallScreen ? 12 : 15,
                   ),
                     textAlign: TextAlign.center,
                   )),
                 ),
               )
              ],
            ),
          );
        });
  }
}

final orderStreamProvider = StreamProvider.family((ref, String status) {
  return FirebaseFirestore.instance.collection("orderDetails").where("orderStatus",isEqualTo: status).snapshots();
});

class OrderlistPage extends ConsumerStatefulWidget {
  const OrderlistPage({super.key});

  @override
  ConsumerState<OrderlistPage> createState() => _OrderlistPageState();
}

class _OrderlistPageState extends ConsumerState<OrderlistPage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final isHalfScreen = MediaQuery.of(context).size.width < 1000;
    return DefaultTabController(
      length: _listItems.length,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
                padding: EdgeInsets.symmetric(vertical: 10),
                labelPadding: EdgeInsets.all(10),
                labelStyle: TextStyle(
                    color: colorConst.canvasColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 15 : 17),
                unselectedLabelStyle:
                    TextStyle(fontSize: isSmallScreen ? 12 : 15),
                overlayColor: MaterialStatePropertyAll(
                    colorConst.mainColor.withOpacity(0)),
                labelColor: colorConst.primaryColor,
                indicator: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    colorConst.mainColor,
                    colorConst.accentCanvasColor
                  ]),
                    border: Border.all(color: colorConst.canvasColor),
                    borderRadius: BorderRadius.circular(20)),
                indicatorPadding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? -scrWidth*0.08 : -100),
                tabs: List.generate(_listItems.length, (index) => Text(_listItems[index])),
              onTap: (value) {
                currentIndex=value;
                setState(() {

                });
              },
            ),
            Expanded(
              child: ref.watch(orderStreamProvider(_listItems[currentIndex!])).when(
                  data: (data){
                    return
                      data.docs.isEmpty? Center(child: Text("No Orders")):
                    TabBarView(children: List.generate(_listItems.length, (index) =>  OrderStatusList(
                      data: data,
                      isSmallScreen: isSmallScreen,
                      isHalfScreen: isHalfScreen,
                      status: _listItems[index],
                      //status: data.docs[index]['orderStatus'],
                    ),));
                  },
                  error: (error, stackTrace) => Center(child: Text(error.toString()),),
                  loading: () {
                   return Center(child: Lottie.asset(gifs.loadingGif),);
                  },
              )


            )
          ],
        ),
      ),
    );
  }
}
