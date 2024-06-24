import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/features/Meats/controller/controller_page.dart';
import 'package:meat_admin/features/Meats/screen/meatList.dart';
import 'package:meat_admin/models/MeatModel.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/main.dart';

class AddMeats extends ConsumerStatefulWidget {
  final String type;
  const AddMeats({super.key, required this.type});

  @override
  ConsumerState<AddMeats> createState() => _AddMeatsState();
}

class _AddMeatsState extends ConsumerState<AddMeats> {

  String? chooseCategory;

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


  List? meatMap = [];
  getMeatData()async{
    var meats = await FirebaseFirestore.instance.collection("meatTypes").where("type",isEqualTo: widget.type).get();
    meatMap = meats.docs;
  }


  // addCategory()async{
  //   FirebaseFirestore.instance.collection("meatTypes").doc(widget.type).collection(widget.type).doc(categoryController.text).set({
  //     "category" : categoryController.text
  //   }).then((value){
  //     categoryController.clear();
  //   });
  // }

  addCategory(){
    ref.watch(meatCategoryController).meatCategory(
        type: widget.type,
        categoryName: categoryController.text);

    categoryController.clear();
  }

  addMeats(){
    MeatModel meatModel=MeatModel(
        image: meatImage.toString(),
        name: nameController.text,
        ingredients: ingredientsController.text,
        rate: double.parse(rateController.text),
        description: descriptionController.text,
        id: "",
        quantity: double.parse(quantityController.text),
        category: chooseCategory.toString(),
        type: widget.type
    );
    ref.watch(addMeatController).addMeats(type: widget.type, chooseCategory:chooseCategory! , meatModel: meatModel);
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MeatList(type: widget.type),), (route) => false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Added!")));

  }

  @override
  void initState() {
    getMeatData();
    super.initState();
  }
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.arrow_left,color: colorConst.primaryColor,),
        ),
        title: Text("${widget.type} Adding Page",
            style: TextStyle(color: colorConst.primaryColor)),
        backgroundColor: colorConst.canvasColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Row(
        children: [
          SizedBox(
            height: scrHeight * 0.9,
            width: scrWidth * 0.5,
            child: Column(
              children: [
                ListTile(
                  title: TextFormField(
                    controller: categoryController,
                    onFieldSubmitted: (value) {
                      addCategory();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        label: Text("Add new Category",style: TextStyle(
                          fontSize: isSmallScreen?10:15
                        ),),
                        hintText: "Enter the Category"),
                  ),
                  trailing: CircleAvatar(
                    child: InkWell(
                        onTap: () {
                          if (categoryController.text != "") {
                            addCategory();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please Enter Data!")));
                          }
                        },
                        child: Icon(Icons.add)),
                  ),
                ),
                // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                //     stream: FirebaseFirestore.instance.collection("meatTypes").doc(widget.type).collection(widget.type).snapshots(),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return Center(child: Lottie.asset(gifs.loadingGif));
                //       }
                //       var data = snapshot.data!.docs;
                //       return data.length == 0
                //           ? Center(child: Text("No Data!"))
                //           :
                //     })
                ref.watch(streamCategoryControllerProvider(widget.type)).when(
                    data: (data) {
                      return
                      Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Text("${index + 1}.",style: TextStyle(
                                  color: colorConst.canvasColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isSmallScreen?12:15
                                ),),
                                title: Text(data[index].category,style: TextStyle(
                                    color: colorConst.canvasColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: isSmallScreen?12:15
                                ),),
                                trailing: InkWell(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Are you sure you want to delete this Category?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: scrHeight*0.02,
                                                  fontWeight: FontWeight.w600
                                              ),),
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius: BorderRadius.circular(scrWidth*0.03),
                                                    ),
                                                    child: Center(child: Text("No",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                      ),)),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                   await FirebaseFirestore.instance
                                                        .collection("meatTypes").doc(widget.type)
                                                        .collection(widget.type).doc(data[index].category).delete();
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: colorConst.mainColor,
                                                      borderRadius: BorderRadius.circular(scrWidth*0.03),
                                                    ),
                                                    child: Center(child: Text("Yes",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                      ),)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },



                                    child: Icon(CupertinoIcons.delete,color: colorConst.red,)),
                              );
                            }),
                      );
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => Lottie.asset(gifs.loadingGif)),
              ],
            ),
          ),
          SizedBox(
            height: scrHeight * 0.9,
            width: scrWidth * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                loading
                    ? SizedBox(
                    height: 150,
                    width: 150,
                    child: Lottie.asset(gifs.loadingGif))
                    : InkWell(
                        onTap: () {
                          selectfile("name");
                        },
                        child: meatImage != null
                            ? Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(meatImage!),fit: BoxFit.fill)
                                ),
                              )
                            : Container(
                          height: 150,
                          width: 150,
                          color: colorConst.canvasColor.withOpacity(0.2),
                          child: Icon(Icons.add_a_photo_outlined),
                        )
                ),
                // StreamBuilder(
                //     stream: FirebaseFirestore.instance.collection("meatTypes").doc(widget.type).collection(widget.type).snapshots(),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData)
                //         return SizedBox(
                //             height: scrHeight * 0.1,
                //             width: scrWidth * 0.1,
                //             child: Lottie.asset(gifs.loadingGif));
                //       var data = snapshot.data!.docs;
                //       return data.isEmpty
                //           ? Text("No Categories Found!")
                //           :
                //     }),
                ref.watch(streamCategoryControllerProvider(widget.type)).when(
                    data: (data) {
                      return
                      data.isEmpty?
                          Text("No Categories found!"):
                      Container(
                        height: scrHeight * 0.06,
                        width: scrWidth * 0.3,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(scrHeight * 0.03),
                            border:
                            Border.all(color: colorConst.canvasColor)),
                        child: Center(
                          child: DropdownButton(
                            padding: EdgeInsets.all(scrHeight * 0.01),
                            isExpanded: true,
                            underline: SizedBox(),
                            hint: Text(
                              "Select Category",
                              style: TextStyle(
                                  color: colorConst.secondaryColor,
                                fontSize: isSmallScreen?12:15
                              ),
                            ),
                            style: TextStyle(
                                color: colorConst.secondaryColor),
                            value: chooseCategory,
                            items: List.generate(data.length,
                                    (index) => data[index].category).map((e) {
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
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => SizedBox(height:30,child: Lottie.asset(gifs.loadingGif)),),
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.canvasColor,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Meat Name",
                        labelStyle: TextStyle(
                          color: colorConst.secondaryColor,
                          fontSize: isSmallScreen?12:15
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorConst.canvasColor),
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
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: ingredientsController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.canvasColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                        labelText: "Ingredients",
                        labelStyle: TextStyle(
                          color: colorConst.secondaryColor,
                            fontSize: isSmallScreen?12:15
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
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.canvasColor,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Rate",
                        labelStyle: TextStyle(
                          color: colorConst.secondaryColor,
                            fontSize: isSmallScreen?12:15
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorConst.canvasColor),
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
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.canvasColor,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Total Quantity",
                        labelStyle: TextStyle(
                          color: colorConst.secondaryColor,
                            fontSize: isSmallScreen?12:15
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorConst.canvasColor),
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
                SizedBox(
                  height: scrHeight * 0.06,
                  width: scrWidth * 0.3,
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    cursorColor: colorConst.canvasColor,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: "Descriptions",
                        labelStyle: TextStyle(
                          color: colorConst.secondaryColor,
                            fontSize: isSmallScreen?12:15
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
                InkWell(
                  onTap: () async {
                    if(
                    meatImage != null &&
                    chooseCategory != null &&
                    nameController.text.isNotEmpty &&
                    ingredientsController.text.isNotEmpty &&
                    rateController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty
                    ){
                      addMeats();
                      // FirebaseFirestore.instance.collection("meatTypes").doc(widget.type).collection(widget.type)
                      //     .doc(chooseCategory).collection(widget.type).add(
                      //     MeatModel(
                      //       image: meatImage.toString(),
                      //       name: nameController.text,
                      //       ingredients: ingredientsController.text,
                      //       rate: double.parse(rateController.text),
                      //       quantity: 1,
                      //       description: descriptionController.text,
                      //       id: '',
                      //     ).toMap()
                      // ).then((value){
                      //   value.update({
                      //     "id" : value.id
                      //   }).then((value){
                      //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MeatTypes(),), (route) => false);
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Added!")));
                      //   });
                      // });
                    }else{
                      meatImage == null?
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select an Image!"))):
                      chooseCategory == null?
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select a Category!"))):
                      nameController.text.isEmpty?
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter a Name!"))):
                      ingredientsController.text.isEmpty?
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Ingredients!"))):
                      rateController.text.isEmpty?
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the Rate!"))):
                      quantityController.text.isEmpty?
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the Quantity!"))):
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter the Description!")));
                    }
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
                        "Submit",
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
