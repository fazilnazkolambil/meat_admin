import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meat_admin/colorPage.dart';
import 'package:meat_admin/main.dart';

class BeefPage extends StatefulWidget {
  const BeefPage({super.key});

  @override
  State<BeefPage> createState() => _BeefPageState();
}

class _BeefPageState extends State<BeefPage> {
  dynamic? valueChoose;
  List category=["Beef Cut","Boneless Beef","Liver","Botti"];

  TextEditingController nameController=TextEditingController();
  TextEditingController ingredientsController=TextEditingController();
  TextEditingController rateController=TextEditingController();
  TextEditingController quantityController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           Container(
             height:scrHeight*0.23 ,
             width:scrHeight*0.2 ,
             decoration: BoxDecoration(
               color: colorConst.primaryColor,
               border: Border.all(color: colorConst.mainColor),
             ),
           ),
           SizedBox(height: scrHeight*0.03,),
           Center(
             child: Container(
               height:scrHeight*0.09 ,
               width:scrHeight*0.4 ,
               padding: EdgeInsets.only(left: 16,right: 16),
               decoration: BoxDecoration(
                 color: colorConst.primaryColor,
                 border: Border.all(color: colorConst.mainColor,),
                 borderRadius: BorderRadius.circular(scrWidth*0.03),
                   boxShadow: [
                     BoxShadow(
                         color: colorConst.mainColor.withOpacity(0.1),
                         blurRadius: 5,
                         offset: Offset(0, 4),
                         spreadRadius: 0
                     )
                   ]
               ),
               child: DropdownButton(
                 hint: Text("Category : ",
                 style: TextStyle(
                     color: colorConst.secondaryColor,
                     fontWeight: FontWeight.w700),),
                 dropdownColor: colorConst.primaryColor,
                 icon: Icon(Icons.arrow_drop_down),
                 iconSize: 36,
                 isExpanded: true,
                 underline: SizedBox(),
                 style: TextStyle(
                   color: colorConst.secondaryColor,
                   // fontSize: 20
                 ),
                 value: valueChoose,

                 items:category.map((valueItem){
                   return DropdownMenuItem(
                     value: valueItem,
                     child: Text(valueItem),
                   );
                 }).toList(),
                 onChanged: (value) {
                   setState(() {
                     valueChoose=value;
                   });
                 },
               ),
             ),
           ),
           SizedBox(height: scrHeight*0.02,),
           Container(
             height:scrHeight*0.078 ,
             width:scrHeight*0.6 ,
             decoration: BoxDecoration(
                 color: colorConst.primaryColor,
                 borderRadius: BorderRadius.circular(scrWidth*0.03),
                 border: Border.all(
                     width: scrWidth*0.0003,
                     color: colorConst.secondaryColor.withOpacity(0.1)
                 ),
                 boxShadow: [
                   BoxShadow(
                       color: colorConst.mainColor.withOpacity(0.2),
                       blurRadius: 5,
                       offset: Offset(0, 4),
                       spreadRadius: 0
                   )
                 ]
             ),
             child: TextFormField(
               controller: nameController,
               keyboardType: TextInputType.text,
               textCapitalization: TextCapitalization.words,
               textInputAction: TextInputAction.newline,
               cursorColor: colorConst.mainColor,
               decoration: InputDecoration(
                 labelText: "Name",
                   labelStyle: TextStyle(
                       color: colorConst.secondaryColor,
                   ),
                   border:OutlineInputBorder(
                       borderSide: BorderSide(
                           color: colorConst.red
                       )
                   ),
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   )
               ),
             ),
           ),
           Container(
             height:scrHeight*0.078 ,
             width:scrHeight*0.6 ,
             decoration: BoxDecoration(
                 color: colorConst.primaryColor,
                 borderRadius: BorderRadius.circular(scrWidth*0.03),
                 border: Border.all(
                     width: scrWidth*0.0003,
                     color: colorConst.secondaryColor.withOpacity(0.1)
                 ),
                 boxShadow: [
                   BoxShadow(
                       color: colorConst.mainColor.withOpacity(0.2),
                       blurRadius: 5,
                       offset: Offset(0, 4),
                       spreadRadius: 0
                   )
                 ]
             ),
             child: TextFormField(
               controller: ingredientsController,
               keyboardType: TextInputType.text,
               textCapitalization: TextCapitalization.words,
               textInputAction: TextInputAction.newline,
               cursorColor: colorConst.mainColor,
               decoration: InputDecoration(
                   labelText: "Ingredients",
                   labelStyle: TextStyle(
                     color: colorConst.secondaryColor,
                   ),
                   border:OutlineInputBorder(
                       borderSide: BorderSide(
                           color: colorConst.red
                       )
                   ),
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   )
               ),
             ),
           ),
           Container(
             height:scrHeight*0.078 ,
             width:scrHeight*0.6 ,
             decoration: BoxDecoration(
                 color: colorConst.primaryColor,
                 borderRadius: BorderRadius.circular(scrWidth*0.03),
                 border: Border.all(
                     width: scrWidth*0.0003,
                     color: colorConst.secondaryColor.withOpacity(0.1)
                 ),
                 boxShadow: [
                   BoxShadow(
                       color: colorConst.mainColor.withOpacity(0.2),
                       blurRadius: 5,
                       offset: Offset(0, 4),
                       spreadRadius: 0
                   )
                 ]
             ),
             child: TextFormField(
               controller: rateController,
               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.done,
               inputFormatters: [
                 FilteringTextInputFormatter.digitsOnly,
                 LengthLimitingTextInputFormatter(8)
               ],
               cursorColor: colorConst.mainColor,
               decoration: InputDecoration(
                 labelText: "Rate",
                   labelStyle: TextStyle(
                     color: colorConst.secondaryColor,
                   ),
                   border:OutlineInputBorder(
                       borderSide: BorderSide(
                           color: colorConst.red
                       )
                   ),
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   )
               ),
             ),
           ),
           Container(
             height:scrHeight*0.078 ,
             width:scrHeight*0.6 ,
             decoration: BoxDecoration(
                 color: colorConst.primaryColor,
                 borderRadius: BorderRadius.circular(scrWidth*0.03),
                 border: Border.all(
                     width: scrWidth*0.0003,
                     color: colorConst.secondaryColor.withOpacity(0.1)
                 ),
                 boxShadow: [
                   BoxShadow(
                       color: colorConst.mainColor.withOpacity(0.2),
                       blurRadius: 5,
                       offset: Offset(0, 4),
                       spreadRadius: 0
                   )
                 ]
             ),
             child: TextFormField(
               controller: quantityController,
               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.done,
               inputFormatters: [
                 FilteringTextInputFormatter.digitsOnly,
                 LengthLimitingTextInputFormatter(8)
               ],
               cursorColor: colorConst.mainColor,
               decoration: InputDecoration(
                 labelText: "Quantity",
                   labelStyle: TextStyle(
                     color: colorConst.secondaryColor,
                   ),
                   border:OutlineInputBorder(
                       borderSide: BorderSide(
                           color: colorConst.red
                       )
                   ),
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   )
               ),
             ),
           ),
           Container(
             height:scrHeight*0.078 ,
             width:scrHeight*0.6 ,
             decoration: BoxDecoration(
                 color: colorConst.primaryColor,
                 borderRadius: BorderRadius.circular(scrWidth*0.03),
                 border: Border.all(
                     width: scrWidth*0.0003,
                     color: colorConst.secondaryColor.withOpacity(0.1)
                 ),
                 boxShadow: [
                   BoxShadow(
                       color: colorConst.mainColor.withOpacity(0.2),
                       blurRadius: 5,
                       offset: Offset(0, 4),
                       spreadRadius: 0
                   )
                 ]
             ),
             child: TextFormField(
               controller: descriptionController,
               keyboardType: TextInputType.multiline,
               textCapitalization: TextCapitalization.sentences,
               textInputAction: TextInputAction.next,
               maxLines: null,
               cursorColor: colorConst.mainColor,
               decoration: InputDecoration(
                 labelText: "Description",
                   labelStyle: TextStyle(
                     color: colorConst.secondaryColor,
                   ),
                   border:OutlineInputBorder(
                       borderSide: BorderSide(
                           color: colorConst.red
                       )
                   ),
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(scrWidth*0.03),
                       borderSide: BorderSide(
                           color: colorConst.mainColor
                       )
                   )
               ),
             ),
           ),
           SizedBox(height: scrHeight*0.04,),
           InkWell(
             onTap: () {

             },
             child: Container(
               height:scrHeight*0.07,
               width:scrHeight*0.2 ,
               decoration: BoxDecoration(
                 color: colorConst.mainColor,
                 borderRadius: BorderRadius.circular(scrHeight*0.02)
               ),
               child: Center(
                 child: Text("Submit",
                 style: TextStyle(
                   color: colorConst.primaryColor
                 ),),
               ),
             ),
           )


         ],
       ),
    );
  }
}
