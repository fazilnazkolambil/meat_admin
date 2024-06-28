import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/MeatPage.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/IntroPages/splashScreen.dart';
import 'package:meat_admin/features/Meats/screen/MeatTypeList.dart';
import 'package:meat_admin/features/UserPage/UsersPage.dart';
import 'package:meat_admin/features/settings/settingsPage.dart';
import 'package:meat_admin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../AdminPages/AddAdminPage.dart';
import '../Banner/BannerPage.dart';
import '../DashBoardPage/dashBoardPage.dart';
import '../OrderPage/orderListPage.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  getPrefs () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUser = prefs.getString('currentUser') ?? '';
  }
  @override
  void initState() {
    getPrefs();
    super.initState();
  }
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
                  style:const TextStyle(color: colorConst.primaryColor),
                ),
                leading: IconButton(
                  onPressed: () {
                    // if (!Platform.isAndroid && !Platform.isIOS) {
                    //   _controller.setExtended(true);
                    // }
                    _key.currentState?.openDrawer();
                  },
                  icon: const Icon(
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
                child: _Screens(
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
    super.key,
    required SidebarXController controller,
  })  : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorConst.canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: colorConst.mainColor,
        textStyle: TextStyle(color: colorConst.primaryColor.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: colorConst.primaryColor),
        hoverTextStyle:const TextStyle(
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

      items: const
      [
        SidebarXItem(
          icon: Icons.dashboard_customize_outlined,
          label: 'DashBoard',
        ),
        SidebarXItem(
          icon: Icons.timer_sharp,
          label: 'Orders',
        ),
         SidebarXItem(
          icon: Icons.shopping_cart_outlined,
          label: 'Meats',
        ),
         SidebarXItem(
          icon: Icons.people,
          label: 'Users',
        ),
        SidebarXItem(
          icon: Icons.wallpaper,
          label: 'Banners',
        ),
        SidebarXItem(
          icon: Icons.person_outline,
          label: 'Admins',
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
        ),
      ],
    );
  }
}

class _Screens extends StatelessWidget {
  const _Screens({
    super.key,
    required this.controller,
  });

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return const DashBoardPage();
          case 1:
            return const OrderlistPage();
          case 2:
            return const MeatTypeList();
          case 3:
            return const UsersPage();
          case 4:
            return const BannerPage();
          case 5:
            return const AddAdminPage();
          case 6:
            return  const settingsPage();
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
    case 4:
      return 'Settings';
    default:
      return 'No page found';
  }
}
