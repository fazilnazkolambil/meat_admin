import 'package:flutter/material.dart';
import 'package:meat_admin/features/addingPages/AddBeef.dart';
import 'package:meat_admin/features/addingPages/AddCategory.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/main.dart';

import 'AddMeatTypes.dart';

class MeatsPage extends StatefulWidget {
  const MeatsPage({super.key});

  @override
  State<MeatsPage> createState() => _MeatsPageState();
}

class _MeatsPageState extends State<MeatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Types of Meats",style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(),));
              },
              child: Container(
                height: scrHeight*0.06,
                width: scrHeight*0.3,
                decoration: BoxDecoration(
                    color: colorConst.primaryColor,
                    borderRadius: BorderRadius.circular(scrHeight*0.03),
                    border: Border.all(color: colorConst.mainColor),
                    boxShadow: [
                      BoxShadow(
                          color: colorConst.secondaryColor.withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(0, 2)
                      )
                    ]
                ),
                child: Center(child: Text("Categories"),),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MeatPage(),));
              },
              child: Container(
                height: scrHeight*0.06,
                width: scrHeight*0.3,
                decoration: BoxDecoration(
                    color: colorConst.primaryColor,
                    borderRadius: BorderRadius.circular(scrHeight*0.03),
                    border: Border.all(color: colorConst.mainColor),
                    boxShadow: [
                      BoxShadow(
                          color: colorConst.secondaryColor.withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(0, 2)
                      )
                    ]
                ),
                child: Center(child: Text("Meats")),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BeefPage(),));
              },
              child: Container(
                height: scrHeight*0.06,
                width: scrHeight*0.3,
                decoration: BoxDecoration(
                    color: colorConst.primaryColor,
                    borderRadius: BorderRadius.circular(scrHeight*0.03),
                    border: Border.all(color: colorConst.mainColor),
                    boxShadow: [
                      BoxShadow(
                          color: colorConst.secondaryColor.withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(0, 2)
                      )
                    ]
                ),
                child: Center(child: Text("Beef"),),
              ),
            ),
            Container(
              height: scrHeight*0.06,
              width: scrHeight*0.3,
              decoration: BoxDecoration(
                  color: colorConst.primaryColor,
                  borderRadius: BorderRadius.circular(scrHeight*0.03),
                  border: Border.all(color: colorConst.mainColor),
                  boxShadow: [
                    BoxShadow(
                        color: colorConst.secondaryColor.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(0, 2)
                    )
                  ]
              ),
              child: Center(child: Text("Mutton"),),
            ),
            Container(
              height: scrHeight*0.06,
              width: scrHeight*0.3,
              decoration: BoxDecoration(
                  color: colorConst.primaryColor,
                  borderRadius: BorderRadius.circular(scrHeight*0.03),
                  border: Border.all(color: colorConst.mainColor),
                  boxShadow: [
                    BoxShadow(
                        color: colorConst.secondaryColor.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(0, 2)
                    )
                  ]
              ),
              child: Center(child: Text("Chicken"),),
            ),
          ],
        ),
      ],
            ),
    );
  }
}
