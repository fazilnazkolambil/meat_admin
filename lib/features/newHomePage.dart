import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/MeatPage.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/listPages/MeatTypeList.dart';
import 'package:meat_admin/features/listPages/UsersStream/Screen/UsersPage.dart';
import 'package:meat_admin/main.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: isSmallScreen
            ? AppBar(
                backgroundColor: colorConst.canvasColor,
                title: Text(
                  _getTitleByIndex(_controller.selectedIndex),
                  style: TextStyle(color: colorConst.primaryColor),
                ),
                leading: IconButton(
                  onPressed: () {
                    // if (!Platform.isAndroid && !Platform.isIOS) {
                    //   _controller.setExtended(true);
                    // }
                    _key.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: colorConst.primaryColor,
                  ),
                ),
              )
            : null,
        drawer: SideBarModel(controller: _controller),
        body: Row(
          children: [
            if (!isSmallScreen) SideBarModel(controller: _controller),
            Expanded(
              child: Center(
                child: _ScreensExample(
                  controller: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideBarModel extends StatelessWidget {
  const SideBarModel({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorConst.canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: colorConst.mainColor,
        textStyle: TextStyle(color: colorConst.primaryColor.withOpacity(0.7)),
        selectedTextStyle: TextStyle(color: colorConst.primaryColor),
        hoverTextStyle: TextStyle(
          color: colorConst.primaryColor,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: EdgeInsets.only(left: scrWidth * 0.03),
        selectedItemTextPadding: EdgeInsets.only(left: scrWidth * 0.03),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scrWidth * 0.02),
          border: Border.all(color: colorConst.accentCanvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorConst.actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [colorConst.accentCanvasColor, colorConst.canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: colorConst.secondaryColor.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: colorConst.canvasColor,
        ),
      ),
      footerDivider: colorConst.divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(imageConst.logo),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.timer_sharp,
          label: 'Orders',
        ),
        const SidebarXItem(
          icon: Icons.shopping_cart_outlined,
          label: 'Meats',
        ),
        const SidebarXItem(
          icon: Icons.people,
          label: 'Users',
        ),
        SidebarXItem(
          icon: Icons.wallpaper,
          label: 'Banners',
        ),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);
    String? userId;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return StreamBuilder<QuerySnapshot>(
                stream:  FirebaseFirestore.instance.collection("orderDetails").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Lottie.asset(gifs.loadingGif);
                  }
                  var data = snapshot.data!.docs;
                  return
                    data.isEmpty?
                        Center(child: Text("No Orders")):
                    ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
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
                                    color: colorConst.canvasColor
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: colorConst.secondaryColor
                                          .withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: isSmallScreen?40:50,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Order ID: ${data[index]["orderId"]}",
                                      style: TextStyle(
                                          fontSize: isSmallScreen?12:17,
                                          fontWeight: FontWeight.w700,
                                          color: colorConst.primaryColor
                                      ),),
                                    Text("Time: ",
                                        style: TextStyle(
                                            fontSize: isSmallScreen?12:17,
                                            fontWeight: FontWeight.w700,
                                            color: colorConst.primaryColor
                                        )
                                    ),
                                    Text("Location:",
                                        style: TextStyle(
                                            fontSize: isSmallScreen?12:17,
                                            fontWeight: FontWeight.w700,
                                            color: colorConst.primaryColor
                                        )
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        //userId = data[index]["userId"];
                                        DocumentSnapshot<Map<String,dynamic>> users = await FirebaseFirestore.instance.collection('users').doc(data[index]['userId']).get();
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  // Text("Name:${users.data()!['name']}"),
                                                  RichText(text: TextSpan(children: [
                                                    TextSpan(text: "Name: ",style: TextStyle(
                                                      color: colorConst.mainColor,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20
                                                    )),
                                                    TextSpan(text: users.data()!['name'],style: TextStyle(
                                                        color: colorConst.canvasColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 20
                                                    ))
                                                  ])),
                                                  RichText(text: TextSpan(children: [
                                                    TextSpan(text: "Email: ",style: TextStyle(
                                                      color: colorConst.mainColor,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20
                                                    )),
                                                    TextSpan(text: users.data()!['email'],style: TextStyle(
                                                        color: colorConst.canvasColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 20
                                                    ))
                                                  ])),
                                                  RichText(text: TextSpan(children: [
                                                    TextSpan(text: "Phone: ",style: TextStyle(
                                                      color: colorConst.mainColor,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20
                                                    )),
                                                    TextSpan(text: users.data()!['number'],style: TextStyle(
                                                        color: colorConst.canvasColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 20
                                                    ))
                                                  ])),
                                                  RichText(text: TextSpan(children: [
                                                    TextSpan(text: "Address: ",style: TextStyle(
                                                      color: colorConst.mainColor,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20
                                                    )),
                                                    TextSpan(text: "${users.data()!['address']}",style: TextStyle(
                                                        color: colorConst.canvasColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 20
                                                    ))
                                                  ])),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: scrHeight * 0.04,
                                        width: scrHeight * 0.13,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius
                                                .circular(scrHeight * 0.03),
                                            color: colorConst.mainColor
                                        ),
                                        child: Center(
                                          child: Text("User details",
                                            style: TextStyle(
                                                fontSize: isSmallScreen?12:15,
                                                color: colorConst
                                                    .primaryColor
                                            ),),
                                        ),


                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                    );
                }


            );
          case 1:
            return MeatTypeList(type: "",);
          case 2:
            return UsersPage();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Meats';
    case 2:
      return 'Users';
    case 3:
      return 'Banners';
    default:
      return 'No page found';
  }
}
