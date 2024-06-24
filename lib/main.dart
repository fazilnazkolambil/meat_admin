

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meat_admin/features/Banner/BannerPage.dart';
// import 'package:meat_admin/features/addingPages/AddMeats.dart';
import 'package:meat_admin/features/Meats/screen/MeatTypeList.dart';
import 'package:meat_admin/features/UserPage/UsersPage.dart';
import 'package:meat_admin/features/IntroPages/splashScreen.dart';
import 'package:meat_admin/features/IntroPages/newHomePage.dart';
import 'package:meat_admin/features/settings/settingsPage.dart';
import 'package:meat_admin/firebase_options.dart';
import 'package:meat_admin/core/homePage/Screen/homePage.dart';
import 'package:meat_admin/models/MeatModel.dart';
import 'features/Meats/screen/AddMeats.dart';
import 'features/Meats/screen/meatList.dart';

// import 'features/addingPages/meatTypes.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(child:  MyApp()));
}
MeatModel? currentMeatModel;
 var scrWidth;
 var scrHeight;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: MaterialApp(
        theme: ThemeData(
          textTheme:GoogleFonts.manropeTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home:SplashScreen()
      ),
    );
  }
}

