import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';

import '../main.dart';


class OrderStatusList extends StatelessWidget {
  final QuerySnapshot<Map<String, dynamic>> data;
  final bool isSmallScreen;
  final String status;

  const OrderStatusList({super.key,
    required this.data,
    required this.isSmallScreen,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                CircleAvatar(
                  radius: isSmallScreen ? 40 : 50,
                  //backgroundImage:NetworkImage(data[index]["image"].isEmpty?"":data[index]["image"]),
                ),
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
                    Text("Time: ",
                        style: TextStyle(
                            fontSize:
                            isSmallScreen ? 12 : 17,
                            fontWeight: FontWeight.w700,
                            color: colorConst
                                .primaryColor)),
                    Text("Location:",
                        style: TextStyle(
                            fontSize:
                            isSmallScreen ? 12 : 17,
                            fontWeight: FontWeight.w700,
                            color: colorConst
                                .primaryColor)),
                    InkWell(
                      onTap: () async {
                        //userId = data[index]["userId"];
                        DocumentSnapshot<
                            Map<String, dynamic>>
                        users =
                        await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(data.docs[index]
                        ['userId'])
                            .get();
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
                                                text: users.data()!['name'],
                                                style: const TextStyle(
                                                    color: colorConst.canvasColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20))
                                          ])),
                                  RichText(
                                      text: TextSpan(
                                          children: [
                                           const TextSpan(
                                                text: "Email: ",
                                                style: TextStyle(
                                                    color: colorConst.mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20)),
                                            TextSpan(
                                                text: users.data()!['email'],
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
                                                text: "Phone: ",
                                                style: TextStyle(
                                                    color: colorConst.mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20)),
                                            TextSpan(
                                                text: users.data()!['number'],
                                                style: const TextStyle(
                                                    color: colorConst.canvasColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20))
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
                                                text: "${users.data()!['address']}",
                                                style:const TextStyle(
                                                    color: colorConst.canvasColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20))
                                          ])),
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
                        status: '',
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
