import 'package:flutter/material.dart';
import 'package:meat_admin/colorPage.dart';
import 'package:meat_admin/main.dart';

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
              child: Center(child: Text("Categories"),),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
              child: Center(child: Text("Beef"),),
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
