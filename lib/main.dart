

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meat_admin/BeefPage.dart';
import 'package:meat_admin/firebase_options.dart';
import 'package:meat_admin/homePage.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}
 var scrWidth;
 var scrHeight;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(
        textTheme:GoogleFonts.manropeTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home:  homePage(),
    );
  }
}

