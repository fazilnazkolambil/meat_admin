import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/IntroPages/newHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

final errorCheckProvider = StateProvider <bool?> ((ref) => null);
String currentUser = '';
class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
   AnimationController? _controller;
   Animation<double>? _animation;
   bool loaded = false;
   TextEditingController userEmailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   bool loggedIn = false;
   checkLoggedIn () async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     loggedIn = prefs.getBool('loggedIn') ?? false;
   }

   login () async {
     if(userEmailController.text.isNotEmpty && passwordController.text.isNotEmpty){
         var roles = await FirebaseFirestore.instance.collection('admins').get();
         for(int i = 0; i < roles.size; i++) {
             var adminLogin = await FirebaseFirestore.instance.collection('admins')
                 .doc(roles.docs[i]['role'])
                 .collection(roles.docs[i]['role']).where("userEmail", isEqualTo: userEmailController.text).get();
             if(adminLogin.docs.isNotEmpty){
               var password = adminLogin.docs[0]['password'];
               if(password == passwordController.text){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => NewHome()));
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${roles.docs[i]['role']} logged in successfully!')));
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 prefs.setBool("loggedIn", true);
                 prefs.setString('currentUser', adminLogin.docs[0]['role']);
               }else{
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong Password!')));
               }
               ref.read(errorCheckProvider.notifier).update((state) => false);
             }else{
               ref.read(errorCheckProvider.notifier).update((state) => true);
             }
         }
     }else{
       userEmailController.text.isEmpty?ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter the email!'))):
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter the password!')));
     }

   }
  @override
  void initState() {
     checkLoggedIn();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller!);
    Timer(Duration(seconds: 3), () {
      loggedIn?Navigator.push(context, MaterialPageRoute(builder: (context) => NewHome(),)):
      _controller!.forward();
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
     final noAdmin = ref.watch(errorCheckProvider) ?? false;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor:colorConst.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: isSmallScreen?scrWidth*0.8:scrWidth*0.3,
                  child: Transform.translate(
                    offset: isSmallScreen?Offset(0 , -scrWidth*0.2 * _animation!.value):Offset(-scrWidth*0.1 * _animation!.value, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50,),
                          Image(image: AssetImage(imageConst.mainIcon),height:isSmallScreen?100:150),
                          SizedBox(height: 20,),
                          Text("Meat Shop",style: TextStyle(
                              color: colorConst.mainColor,
                              fontSize: isSmallScreen?20:30,
                              fontWeight: FontWeight.w600
                          )),
                          loaded?SizedBox():
                          SizedBox(
                              height:isSmallScreen? scrWidth*0.3 : 300,
                              width: isSmallScreen? scrWidth*0.3 : 300,
                              child: Lottie.asset(gifs.loadingGif)),
                          if(isSmallScreen)
                            Opacity(
                              opacity: _animation!.value,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: userEmailController,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                        fontSize: scrWidth*0.04,
                                        fontWeight: FontWeight.w600
                                    ),
                                    decoration:
                                    InputDecoration(
                                        prefixIcon: Padding(
                                          padding:  EdgeInsets.all(scrWidth*0.04),
                                          child: Icon(CupertinoIcons.person)
                                        ),
                                        filled: true,
                                        fillColor: colorConst.primaryColor,
                                        hintText: "Email",
                                        border:OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorConst.red
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(scrWidth*0.03),
                                            borderSide: BorderSide(
                                                color: noAdmin?colorConst.red:colorConst.secondaryColor.withOpacity(0.1)
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(scrWidth*0.03),
                                            borderSide: BorderSide(
                                                color: noAdmin?colorConst.red:colorConst.secondaryColor.withOpacity(0.1)
                                            )
                                        )
                                    ),
                                  ),
                                  SizedBox(height: scrWidth*0.04,),
                                  TextFormField(
                                    controller: passwordController,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    style: TextStyle(
                                        fontSize: scrWidth*0.04,
                                        fontWeight: FontWeight.w600
                                    ),
                                    decoration:
                                    InputDecoration(
                                        prefixIcon: Padding(
                                            padding:  EdgeInsets.all(scrWidth*0.04),
                                            child: Icon(CupertinoIcons.lock)
                                        ),
                                        filled: true,
                                        fillColor: colorConst.primaryColor,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          fontSize: scrWidth*0.04,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        border:OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorConst.red
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(scrWidth*0.03),
                                            borderSide: BorderSide(
                                                color: colorConst.secondaryColor.withOpacity(0.1)
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(scrWidth*0.03),
                                            borderSide: BorderSide(
                                                color: colorConst.secondaryColor.withOpacity(0.1)
                                            )
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: (){
                                      login();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      margin: EdgeInsets.symmetric(horizontal: scrWidth*0.25),
                                      decoration: BoxDecoration(
                                        color: colorConst.mainColor,
                                        borderRadius: BorderRadius.circular(scrWidth*0.06),

                                      ),
                                      child: Center(
                                        child:Text("Log in",
                                          style: TextStyle(
                                              color: colorConst.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: scrWidth*0.03
                                          ),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if(!isSmallScreen)
                  Opacity(
                    opacity: _animation!.value,
                    child: SizedBox(
                      width: scrWidth*0.2,
                      height: scrHeight*0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: scrWidth*0.3,
                            height: 50,
                            child: TextFormField(
                              controller: userEmailController,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(CupertinoIcons.person),
                                  filled: true,
                                  fillColor: colorConst.primaryColor,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    fontSize: 15
                                  ),
                                  border:OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colorConst.red
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: noAdmin?colorConst.red:colorConst.secondaryColor.withOpacity(0.1)
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: noAdmin?colorConst.red:colorConst.secondaryColor.withOpacity(0.1)
                                      )
                                  )
                              ),
                            ),
                          ),
                          SizedBox(
                            width: scrWidth*0.3,
                            height: 50,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(CupertinoIcons.lock),
                                  filled: true,
                                  fillColor: colorConst.primaryColor,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      fontSize: 15
                                  ),
                                  border:OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colorConst.red
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: colorConst.secondaryColor.withOpacity(0.1)
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: colorConst.secondaryColor.withOpacity(0.1)
                                      )
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              login();
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: colorConst.mainColor,
                                borderRadius: BorderRadius.circular(scrWidth*0.06),

                              ),
                              child: Center(
                                child:Text("Log in",
                                  style: TextStyle(
                                      color: colorConst.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20
                                  ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}