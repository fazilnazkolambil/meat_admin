import 'dart:js';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import '../main.dart';


class OrderStatusList extends ConsumerWidget {
  final QuerySnapshot<Map<String, dynamic>> data;
  final bool isSmallScreen;
  final String status;

   OrderStatusList({super.key,
    required this.data,
    required this.isSmallScreen,
    required this.status,
  });

   int selectindex = 0;
   List a = [];
   List b = [];
   List c = [];


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final dropdownNotifier = ref.watch(dropdownProvider);
    // final dropdownValue = dropdownNotifier.state.dropdownValue;
    var listItems=[
      "Packed","Out for delivery","delivered",
    ];
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: data.size,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return data.docs[index]["orderStatus"] == status?
          Container(
            height: 130,
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
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                // CircleAvatar(
                //   radius: isSmallScreen ? 40 : 50,
                //   //backgroundImage:NetworkImage(data[index]["image"].isEmpty?"":data[index]["image"]),
                // ),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Order ID: ${data.docs[index]["orderId"]}",
                      style: TextStyle(
                          fontSize:
                          isSmallScreen ? 12 : 17,
                          fontWeight: FontWeight.w700,
                          color:
                          colorConst.primaryColor),
                    ),
                    InkWell(
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context){
                          return AlertDialog(
                            title: Column(
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
                              ],
                            ),
                          );
                        }
                        );
                      },
                      child: Container(
                        height: scrHeight * 0.04,
                        //width: scrHeight * 0.13,
                        padding: EdgeInsets.only(
                            left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                scrHeight * 0.03),
                            color:
                            colorConst.mainColor),
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
                                  width: scrWidth*1,
                                  child: ListView.separated(
                                    itemCount: itemsData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 250,
                                        width: scrWidth*1,
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
                                                          text: itemsData[index]['quantity'].toString(),
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
                        height: scrHeight * 0.04,
                        //width: scrHeight * 0.13,
                        padding: EdgeInsets.only(
                            left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                scrHeight * 0.03),
                            color:
                            colorConst.mainColor),
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
                        //userId = data[index]["userId"];
                        // DocumentSnapshot<
                        //     Map<String, dynamic>>
                        // users =
                        // await FirebaseFirestore
                        //     .instance
                        //     .collection('')
                        //     .doc(data.docs[index]
                        // ['userId'])
                        //     .get();
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
                                                ))
                                          ])),
                                  // RichText(
                                  //     text: TextSpan(
                                  //         children: [
                                  //          const TextSpan(
                                  //               text: "Address: ",
                                  //               style: TextStyle(
                                  //                   color: colorConst.mainColor,
                                  //                   fontWeight: FontWeight.w600,
                                  //                   fontSize: 20)),
                                  //           TextSpan(
                                  //               text: "${users.data()!['address']}",
                                  //               style:const TextStyle(
                                  //                   color: colorConst.canvasColor,
                                  //                   fontWeight: FontWeight.w500,
                                  //                   fontSize: 20))
                                  //         ])),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: scrHeight * 0.04,
                        //width: scrHeight * 0.13,
                        padding: EdgeInsets.only(
                            left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                scrHeight * 0.03),
                            color:
                            colorConst.mainColor),
                        child: Center(
                          child: Text(
                            "User details",
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
                   Container(
                       height: scrHeight*0.115,
                       width: 540,
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(scrWidth * 0.015),
                         border: Border.all(color: colorConst.mainColor)),
                     child: Center(
                       child: ListView.builder(
                         itemCount: 1,
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemBuilder: (BuildContext context, int index) {
                           return  Container(
                             height: scrHeight * 0.11,
                             width: scrWidth * 0.5,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(scrWidth * 0.02),
                                 border: Border.all(color: colorConst.primaryColor)),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Container(
                                   width: scrWidth * 0.11,
                                   height: scrWidth * 0.04,
                                   decoration: BoxDecoration(
                                       color: colorConst.mainColor,
                                       borderRadius: BorderRadius.circular(
                                           scrWidth * 0.01)),
                                   child: Center(
                                     child: Row(
                                       children: [
                                         Radio(
                                           fillColor: MaterialStatePropertyAll(colorConst.primaryColor),
                                             activeColor: colorConst.primaryColor,
                                             value: 0,
                                             groupValue: selectindex,
                                             onChanged: (value) {

                                             },),
                                         Text(
                                           "Packed\nConfirmed",
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: scrWidth * 0.01,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                                 SizedBox(
                                   width: scrWidth * 0.015,
                                 ),
                                 Container(
                                   width: scrWidth * 0.11,
                                   height: scrWidth * 0.04,
                                   decoration: BoxDecoration(
                                       color: colorConst.mainColor,
                                       borderRadius: BorderRadius.circular(
                                           scrWidth * 0.01)),
                                   child: Center(
                                     child: Row(
                                       children: [
                                         Radio(
                                           fillColor: MaterialStatePropertyAll(colorConst.primaryColor),
                                           activeColor: colorConst.primaryColor,
                                           value: 0,
                                           groupValue: selectindex,
                                           onChanged: (value) {

                                           },),
                                         Text(
                                           "Out for Delivered",
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: scrWidth * 0.01,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                                 SizedBox(
                                   width: scrWidth * 0.015,
                                 ),
                                 Container(
                                   width: scrWidth * 0.11,
                                   height: scrWidth * 0.04,
                                   decoration: BoxDecoration(
                                       color: colorConst.mainColor,
                                       borderRadius: BorderRadius.circular(
                                           scrWidth * 0.01)),
                                   child: Center(
                                     child: Row(
                                       children: [
                                         Radio(
                                           fillColor: MaterialStatePropertyAll(colorConst.primaryColor),
                                           activeColor: colorConst.primaryColor,
                                           value: 0,
                                           groupValue: selectindex,
                                           onChanged: (value) {

                                           },),
                                         Text(
                                           "Delivery",
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: scrWidth * 0.01,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           );
                         },
                       ),
                     ),
                     )
                  ],
                )
              ],
            ),
          ):SizedBox();
        });
  }
}

final orderStreamProvider = StreamProvider((ref) {
  return FirebaseFirestore.instance.collection("orderDetails").snapshots();
});

class OrderlistPage extends ConsumerStatefulWidget {
  const OrderlistPage({super.key});

  @override
  ConsumerState<OrderlistPage> createState() => _OrderlistPageState();
}

class _OrderlistPageState extends ConsumerState<OrderlistPage> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return DefaultTabController(
      length: 3,
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
                tabs: [
                  Text("Running"),
                  Text(
                    "Delivered",
                    style: TextStyle(color: colorConst.green),
                  ),
                  Text(
                    "Canceled",
                    style: TextStyle(color: colorConst.red),
                  ),
                ]),
            Expanded(
              child: ref.watch(orderStreamProvider).when(
                  data: (data){
                    return
                      data.docs.isEmpty? Center(child: Text("No Orders")):
                    TabBarView(children: [
                      OrderStatusList(
                        data: data,
                        isSmallScreen: isSmallScreen,
                        status: 'Ordered',
                      ),
                      OrderStatusList(
                        data: data,
                        isSmallScreen: isSmallScreen,
                        status: 'Delivered',
                      ),
                      OrderStatusList(
                        data: data,
                        isSmallScreen: isSmallScreen,
                        status: 'Canceled',
                      ),

                    ]);
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
