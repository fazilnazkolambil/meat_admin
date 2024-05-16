import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/listPages/MeatTypeList.dart';

import '../../main.dart';
import '../../models/MeatModel.dart';
import '../add_meat_types/screen/meatTypes.dart';

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
    required this.type, required this.category,
  });

  @override
  State<MeatsEdit> createState() => _MeatsEditState();
}

class _MeatsEditState extends State<MeatsEdit> {
  String? chooseCategory;


  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

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

  List? meatMap = [];
  getMeatData() async {
    var meats = await FirebaseFirestore.instance
        .collection("meatTypes")
        .where("type", isEqualTo: widget.type)
        .get();
    meatMap = meats.docs;
  }

  addCategory() async {
    FirebaseFirestore.instance
        .collection("meatTypes")
        .doc(widget.type)
        .collection(widget.type)
        .doc(categoryController.text)
        .set({"category": categoryController.text}).then((value) {
      categoryController.clear();
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
            print(favourites);
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
    getMeatData();
    chooseCategory = widget.category;
    nameController.text = widget.name;
    ingredientsController.text = widget.ingredients;
    rateController.text = widget.rate;
    descriptionController.text = widget.description;
    meatImage = widget.Image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            print(meatMap!);
          },
          child: Text("${widget.type} Adding Page",
              style: TextStyle(color: colorConst.primaryColor)),
        ),
        backgroundColor: colorConst.mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Row(
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
          //               return data.length == 0
          //                   ? Center(child: Text("No Data!"))
          //                   : ListView.builder(
          //                   itemCount: data.length,
          //                   itemBuilder: (context, index) {
          //                     return ListTile(
          //                       leading: Text("${index + 1}."),
          //                       title: Text(data[index]["category"]),
          //                       trailing: InkWell(
          //                           onTap: () {
          //                             FirebaseFirestore.instance
          //                                 .collection("meatTypes")
          //                                 .doc(widget.type)
          //                                 .collection(widget.type)
          //                                 .doc(data[index]["category"])
          //                                 .delete();
          //                           },
          //                           child: Icon(CupertinoIcons.delete)),
          //                     );
          //                   });
          //             }),
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(
            height: scrHeight * 0.9,
            width: scrWidth * 0.5,
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
                                child: Icon(Icons.add_a_photo_outlined),
                              )),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("meatTypes")
                        .doc(widget.type)
                        .collection(widget.type)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return SizedBox(
                            height: scrHeight * 0.1,
                            width: scrWidth * 0.1,
                            child: Lottie.asset(gifs.loadingGif));
                      var data = snapshot.data!.docs;
                      return data.isEmpty
                          ? Text("No Categories Found!")
                          : Container(
                              height: scrHeight * 0.06,
                              width: scrWidth * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(scrHeight * 0.03),
                                  border:
                                      Border.all(color: colorConst.mainColor)),
                              child: Center(
                                child: DropdownButton(
                                  padding: EdgeInsets.all(scrHeight * 0.01),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  hint: Text(
                                    "Select Category",
                                    style: TextStyle(
                                        color: colorConst.secondaryColor),
                                  ),
                                  style: TextStyle(
                                      color: colorConst.secondaryColor),
                                  value: widget.category,
                                  items: List.generate(data.length,
                                          (index) => data[index]["category"])
                                      .map((e) {
                                    return DropdownMenuItem(
                                        value: e, child: Text(e));
                                  }).toList(),
                                  onChanged: (value) {
                                    chooseCategory = value.toString();
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                    }),
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.mainColor,
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
                                BorderSide(color: colorConst.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(scrWidth * 0.03),
                            borderSide:
                                BorderSide(color: colorConst.mainColor))),
                  ),
                ),
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: ingredientsController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.mainColor,
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
                                BorderSide(color: colorConst.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(scrWidth * 0.03),
                            borderSide:
                                BorderSide(color: colorConst.mainColor))),
                  ),
                ),
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.mainColor,
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
                                BorderSide(color: colorConst.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(scrWidth * 0.03),
                            borderSide:
                                BorderSide(color: colorConst.mainColor))),
                  ),
                ),
                SizedBox(
                  // height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.mainColor,
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
                                BorderSide(color: colorConst.mainColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(scrWidth * 0.03),
                            borderSide:
                                BorderSide(color: colorConst.mainColor))),
                  ),
                ),
                InkWell(
                  onTap: () {
                    updateMeat = MeatModel(
                        image: meatImage.toString(),
                        name: nameController.text,
                        ingredients: ingredientsController.text,
                        rate:double.parse(rateController.text),
                        description: descriptionController.text,
                        id: widget.id,
                        quantity: 1,
                        category: categoryController.text,
                        type: widget.type
                    );

                    FirebaseFirestore.instance
                        .collection("meatTypes")
                        .doc(widget.type)
                        .collection(widget.type)
                        .doc(chooseCategory)
                        .collection(widget.type).doc(widget.id).update(updateMeat!.toMap());
                    editMeats();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MeatTypeList(type: widget.type,),), (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Updated!")));
                  },
                  child: Container(
                    height: scrHeight * 0.07,
                    width: scrHeight * 0.2,
                    decoration: BoxDecoration(
                        color: colorConst.mainColor,
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
      )),
    );
  }
}
