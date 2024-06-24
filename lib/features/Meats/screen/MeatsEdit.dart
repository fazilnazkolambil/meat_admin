import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/Meats/screen/MeatTypeList.dart';

import '../../../main.dart';
import '../../../models/MeatModel.dart';
import 'meatList.dart';

class MeatsEdit extends StatefulWidget {
  final String type;
  final String id;
  final String Image;
  final String name;
  final String rate;
  final String ingredients;
  final String description;
  final String quantity;
  final String category;

  const MeatsEdit({
    super.key,
    required this.id,
    required this.Image,
    required this.name,
    required this.rate,
    required this.ingredients,
    required this.description,
    required this.quantity,
    required this.type,
    required this.category,
  });

  @override
  State<MeatsEdit> createState() => _MeatsEditState();
}

class _MeatsEditState extends State<MeatsEdit> {
  //String? chooseCategory;


  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  PlatformFile? pickFile;
  Future selectfile(String name) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    pickFile = result.files.first;
    final fileBytes = result.files.first.bytes;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Uploading...")));
    uploadFileToFirebase(name, fileBytes);
    setState(() {});
  }

  UploadTask? uploadTask;
  String? meatImage;
  bool loading = false;
  Future uploadFileToFirebase(String name, file) async {
    loading = true;
    setState(() {});
    uploadTask = FirebaseStorage.instance
        .ref('Meats')
        .child(DateTime.now().toString())
        .putData(file, SettableMetadata(contentType: 'image/jpeg'));
    final snapshot = await uploadTask?.whenComplete(() {});
    meatImage = await snapshot?.ref.getDownloadURL();
    setState(() {
      loading = false;
    });
  }
  MeatModel? updateMeat;
  var users;
  editMeats() async {
    var userCollection = await FirebaseFirestore.instance.collection("users").get();
    users = userCollection.docs;
    for (int i = 0; i < users.length; i++){
      var favourites = users[i]["favourites"];
      if (favourites.isNotEmpty){
        for(int j = 0; j < favourites.length; j++){
          if(favourites[j]["id"] == widget.id){
            //favourites = favourites.map((value) => updateMeat!.toMap());
            favourites[j] = updateMeat!.toMap();
            FirebaseFirestore.instance.collection("users").doc(users[i]["id"]).update({
                "favourites" : favourites
            });
          }
        }
      }
    }
  }
  @override
  void initState() {
    nameController.text = widget.name;
    ingredientsController.text = widget.ingredients;
    rateController.text = widget.rate;
    descriptionController.text = widget.description;
    quantityController.text = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.arrow_left,color: colorConst.primaryColor,),
        ),
        title: Text("Edit ${widget.name}",
            style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.canvasColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
            // SizedBox(
            //   height: scrHeight * 0.9,
            //   width: scrWidth * 0.5,
            //   child: Column(
            //     children: [
            //       ListTile(
            //         title: TextFormField(
            //           controller: categoryController,
            //           onFieldSubmitted: (value) {
            //             addCategory();
            //           },
            //           decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(50)),
            //               label: Text("${widget.type} Categories"),
            //               hintText: "Enter the Category"),
            //         ),
            //         trailing: CircleAvatar(
            //           child: InkWell(
            //               onTap: () {
            //                 if (categoryController.text != "") {
            //                   addCategory();
            //                 } else {
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                       SnackBar(content: Text("Please Enter Data!")));
            //                 }
            //               },
            //               child: Icon(Icons.add)),
            //         ),
            //       ),
            //       Expanded(
            //         child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            //             stream: FirebaseFirestore.instance
            //                 .collection("meatTypes")
            //                 .doc(widget.type)
            //                 .collection(widget.type)
            //                 .snapshots(),
            //             builder: (context, snapshot) {
            //               if (!snapshot.hasData) {
            //                 return Center(child: Lottie.asset(gifs.loadingGif));
            //               }
            //               var data = snapshot.data!.docs;
            //               return data.isEmpty
            //                   ? Center(child: Text("No Data!"))
            //                   : ListView.builder(
            //                   itemCount: data.length,
            //                   itemBuilder: (context, index) {
            //                     return ListTile(
            //                       leading: Text("${index + 1}.",style: TextStyle(
            //                           color: colorConst.canvasColor,
            //                           fontWeight: FontWeight.w500,
            //                           fontSize: 15
            //                       ),),
            //                       title: Text(data[index]["category"],style: TextStyle(
            //                           color: colorConst.canvasColor,
            //                           fontWeight: FontWeight.w500,
            //                           fontSize: 15
            //                       ),),
            //                       trailing: InkWell(
            //                           onTap: () {
            //                             showDialog(
            //                               barrierDismissible: false,
            //                               context: context,
            //                               builder: (context) {
            //                                 return AlertDialog(
            //                                   title: Text("Are you sure you want to delete this Category?",
            //                                     textAlign: TextAlign.center,
            //                                     style: TextStyle(
            //                                         fontSize: scrHeight*0.02,
            //                                         fontWeight: FontWeight.w600
            //                                     ),),
            //                                   content: Row(
            //                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                                     children: [
            //                                       InkWell(
            //                                         onTap: () {
            //                                           Navigator.pop(context);
            //                                         },
            //                                         child: Container(
            //                                           height: 30,
            //                                           width: 120,
            //                                           decoration: BoxDecoration(
            //                                             color: Colors.blueGrey,
            //                                             borderRadius: BorderRadius.circular(scrWidth*0.03),
            //                                           ),
            //                                           child: Center(child: Text("No",
            //                                             style: TextStyle(
            //                                                 color: Colors.white
            //                                             ),)),
            //                                         ),
            //                                       ),
            //                                       InkWell(
            //                                         onTap: () async {
            //                                           Navigator.pop(context);
            //                                           await FirebaseFirestore.instance
            //                                               .collection("meatTypes").doc(widget.type)
            //                                               .collection(widget.type).doc(data[index]['category']).delete();
            //                                         },
            //                                         child: Container(
            //                                           height: 30,
            //                                           width: 120,
            //                                           decoration: BoxDecoration(
            //                                             color: colorConst.mainColor,
            //                                             borderRadius: BorderRadius.circular(scrWidth*0.03),
            //                                           ),
            //                                           child: Center(child: Text("Yes",
            //                                             style: TextStyle(
            //                                                 color: Colors.white
            //                                             ),)),
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 );
            //                               },
            //                             );
            //                           },
            //
            //
            //
            //                           child: Icon(CupertinoIcons.delete,color: colorConst.red,)),
            //                     );
            //                   });
            //             }),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(
              height: scrHeight * 0.9,
              //width: scrWidth * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  loading
                      ? SizedBox(
                          height: scrHeight * 0.2,
                          width: scrWidth * 0.2,
                          child: Lottie.asset(gifs.loadingGif))
                      : InkWell(
                          onTap: () {
                            selectfile("name");
                          },
                          child: meatImage != null
                              ? CircleAvatar(
                                  radius: scrHeight * 0.1,
                                  backgroundImage: NetworkImage(meatImage!),
                                )
                              : CircleAvatar(
                                  radius: scrHeight * 0.1,
                                  child: Center(child: Text("Change Image",style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: colorConst.canvasColor
                                  ),)),
                                  backgroundImage:NetworkImage(widget.Image),
                                    onBackgroundImageError: (exception, stackTrace) => Text(stackTrace.toString()),
                                )),
                  // StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection("meatTypes")
                  //         .doc(widget.type)
                  //         .collection(widget.type)
                  //         .snapshots(),
                  //     builder: (context, snapshot) {
                  //       if (!snapshot.hasData)
                  //         return SizedBox(
                  //             height: scrHeight * 0.1,
                  //             width: scrWidth * 0.1,
                  //             child: Lottie.asset(gifs.loadingGif));
                  //       var data = snapshot.data!.docs;
                  //       return data.isEmpty
                  //           ? Text("No Categories Found!")
                  //           : Container(
                  //               height: scrHeight * 0.06,
                  //               width: scrWidth * 0.3,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(scrHeight * 0.03),
                  //                   border: Border.all(color: colorConst.mainColor)),
                  //               child: Center(
                  //                 child: DropdownButton(
                  //                   padding: EdgeInsets.all(scrHeight * 0.01),
                  //                   isExpanded: true,
                  //                   underline: SizedBox(),
                  //                   hint: Text(
                  //                     "Select Category",
                  //                     style: TextStyle(
                  //                         color: colorConst.secondaryColor),
                  //                   ),
                  //                   style: TextStyle(
                  //                       color: colorConst.secondaryColor),
                  //                   value: widget.category,
                  //                   items: List.generate(data.length,
                  //                           (index) => data[index]["category"])
                  //                       .map((e) {
                  //                     return DropdownMenuItem(
                  //                         value: e, child: Text(e));
                  //                   }).toList(),
                  //                   onChanged: (value) {
                  //                     chooseCategory = value.toString();
                  //                     setState(() {});
                  //                   },
                  //                 ),
                  //               ),
                  //             );
                  //     }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Change Name :",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorConst.canvasColor
                      )),
                      SizedBox(
                        width: scrWidth*0.6,
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          decoration: InputDecoration(
                              labelText: "Enter Name",
                              labelStyle: TextStyle(
                                color: colorConst.secondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorConst.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: scrWidth*0.3,
                        child: Text("Change Ingredience :",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorConst.canvasColor
                        )),
                      ),
                      SizedBox(
                        width: scrWidth*0.6,
                        child: TextFormField(
                          controller: ingredientsController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          decoration: InputDecoration(
                              labelText: "Enter the ingredient",
                              labelStyle: TextStyle(
                                color: colorConst.secondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorConst.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Change Rate :",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorConst.canvasColor
                      )),
                      SizedBox(
                        width: scrWidth*0.6,
                        child: TextFormField(
                          controller: rateController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          decoration: InputDecoration(
                              labelText: "Enter the Rate",
                              labelStyle: TextStyle(
                                color: colorConst.secondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorConst.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Change Quantity :",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorConst.canvasColor
                      )),
                      SizedBox(
                        width: scrWidth*0.6,
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          decoration: InputDecoration(
                              labelText: "Enter the Quantity",
                              labelStyle: TextStyle(
                                color: colorConst.secondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorConst.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: scrWidth*0.3,
                        child: Text("Change Description :",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorConst.canvasColor
                        )),
                      ),
                      SizedBox(
                        width: scrWidth*0.6,
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 2,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          cursorColor: colorConst.canvasColor,
                          decoration: InputDecoration(
                              labelText: "Enter the Descriptions",
                              labelStyle: TextStyle(
                                color: colorConst.secondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorConst.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(scrWidth * 0.03),
                                  borderSide:
                                      BorderSide(color: colorConst.canvasColor))),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      updateMeat = MeatModel(
                          image: meatImage == null?widget.Image:meatImage.toString(),
                          name: nameController.text,
                          ingredients: ingredientsController.text,
                          rate:double.parse(rateController.text),
                          description: descriptionController.text,
                          id: widget.id,
                          quantity: double.parse(quantityController.text),
                          category: categoryController.text,
                          type: widget.type
                      );

                      FirebaseFirestore.instance
                          .collection("meatTypes")
                          .doc(widget.type)
                          .collection(widget.type)
                          .doc(widget.category)
                          .collection(widget.type).doc(widget.id).update(updateMeat!.toMap());
                      editMeats();
                      Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MeatList(type: widget.type,),), (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Updated!")));
                    },
                    child: Container(
                      height: scrHeight * 0.07,
                      width: scrHeight * 0.2,
                      decoration: BoxDecoration(
                        //color: colorConst.mainColor,
                          gradient: LinearGradient(colors: [
                            colorConst.thirdColor,
                            colorConst.canvasColor
                          ]),
                          borderRadius: BorderRadius.circular(scrHeight * 0.02)),
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(color: colorConst.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                    ],
                  ),
          )),
    );
  }
}
