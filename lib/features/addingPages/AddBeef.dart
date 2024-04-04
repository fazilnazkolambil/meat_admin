import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/models/MeatModel.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/main.dart';

class BeefPage extends StatefulWidget {
  const BeefPage({super.key});

  @override
  State<BeefPage> createState() => _BeefPageState();
}

class _BeefPageState extends State<BeefPage> {
  String? valueChoose;
  //List category=["Beef Cut","Boneless Beef","Liver","Botti"];

  TextEditingController nameController=TextEditingController();
  TextEditingController ingredientsController=TextEditingController();
  TextEditingController rateController=TextEditingController();
  TextEditingController quantityController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  PlatformFile? pickFile;
  Future selectfile (String name)async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;
    pickFile = result.files.first;
    final fileBytes = result.files.first.bytes;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uploading...")));
    uploadFileToFirebase(name, fileBytes);
    setState(() {

    });
  }
  UploadTask? uploadTask;
  String? mainImage;
  bool loading = false;
  Future uploadFileToFirebase(String name, file) async {
    loading = true;
    setState(() {

    });
    uploadTask = FirebaseStorage.instance
        .ref('Meats')
        .child(DateTime.now().toString())
        .putData(file, SettableMetadata(contentType: 'image/jpeg'));
    final snapshot = await uploadTask?.whenComplete(() {});
    mainImage = await snapshot?.ref.getDownloadURL();
    setState(() {
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             loading? SizedBox(height:scrHeight*0.2,width:scrHeight*0.2,child: Lottie.asset(gifs.loadingGif,fit: BoxFit.fill)) :
             InkWell(
                 onTap: () {
                   selectfile("name");
                 },
                 child: mainImage != null?
                 Container(
                     height: scrHeight*0.2,
                     width: scrHeight*0.2,
                     child:Image(image: NetworkImage(mainImage!))
                 )
                     : Container(
                   height: scrHeight*0.2,
                   width: scrHeight*0.2,
                   decoration: BoxDecoration(
                       color: colorConst.mainColor.withOpacity(0.8)
                   ),
                   child: Icon(Icons.add_a_photo),
                 )
             ),
             SizedBox(height: scrHeight*0.03,),
             Center(
               child: StreamBuilder<QuerySnapshot>(
                 stream: FirebaseFirestore.instance.collection('category').snapshots(),
                 builder: (context, snapshot) {
                   if(!snapshot.hasData){
                     return Text('No data found!');
                   }
                   var data = snapshot.data!.docs;
                   return data.length==0
                       ? Text("No category found!"):
                   Container(
                     height:scrHeight*0.06,
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
                            
                       items: List.generate(data.length, (index) => data[index]['category']).map((valueItem){
                         return DropdownMenuItem(
                           value: valueItem,
                           child: Text(valueItem),
                         );
                       }).toList(),
                       onChanged: (value) {
                         setState(() {
                           valueChoose=value.toString();
                         });
                       },
                     ),
                   );
                 }
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
                FirebaseFirestore.instance.collection("meats").add(
                  MeatModel(
                      image: "",
                      category: valueChoose,
                      name: nameController.text,
                      ingredients: ingredientsController.text,
                      rate: rateController.text,
                      quantity: quantityController.text,
                      description: descriptionController.text
                  ).toMap()

                ).then((value) {
                  value.update({
                    "id" : value.id
                  });
                });
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
       ),
    );
  }
}
