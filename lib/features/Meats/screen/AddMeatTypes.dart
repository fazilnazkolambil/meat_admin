import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/main.dart';
import 'package:meat_admin/models/MeatTypeModel.dart';

import '../controller/controller_meatType_page.dart';

class AddMeatTypes extends ConsumerStatefulWidget {
  const AddMeatTypes({super.key});

  @override
  ConsumerState<AddMeatTypes> createState() => _AddMeatTypesState();
}

class _AddMeatTypesState extends ConsumerState<AddMeatTypes> {

  TextEditingController meat_controller = TextEditingController();
  int num = 1;

  dataSubmit(){
    if(
    meat_controller.text !="" &&
        mainImage != null
    ){
      MeatTypeModel categoryModel = MeatTypeModel(type: meat_controller.text, mainImage: mainImage.toString());
      ref.watch(meatTypesController).meatAdd(categoryModel);
      meat_controller.clear();
      mainImage=null;
    }else{
      mainImage == null ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select an Image!"))):
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Data!")));
    }
    setState(() {

    });

  }




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


  var phonefile;
  String phoneImage = '';
  pickFileFromPhone(ImageSource) async {
    final imgFile= await ImagePicker.platform.getImageFromSource(source: ImageSource);
    phonefile=File(imgFile!.path);
    if(mounted){
      setState(() {
        phonefile=File(imgFile.path);
      });
    }
    uploadImage(phonefile);
  }
  uploadImage(File phonefile) async {
    loading = true;
    setState(() {

    });
    var uploadTask = await FirebaseStorage.instance
        .ref("userImage")
        .child(DateTime.now().toString())
        .putFile(phonefile,SettableMetadata(
        contentType: "image/jpeg"));
    var getImage = await uploadTask.ref.getDownloadURL();
    phoneImage = getImage;
    loading = false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorConst.primaryColor,
        title: Text("Add Meat Types"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          isSmallScreen?
        SizedBox(
          height: 150,
          width: 150,
          child:loading? Lottie.asset(gifs.loadingGif):
          GestureDetector(
              onTap: () {
                pickFileFromPhone(ImageSource.gallery);
              },
              child: phoneImage.isNotEmpty ?
              CircleAvatar(
                backgroundImage: NetworkImage(phoneImage),
                radius: 70,
              ):
              CircleAvatar(
                child: Icon(Icons.add_a_photo),
                radius: 70,
              )
          ),
        )
          :SizedBox(
            height: 150,
            width: 150,
            child:loading? Lottie.asset(gifs.loadingGif):
            GestureDetector(
                onTap: () {
                  selectfile("name");
                },
                child: mainImage != null ?
                CircleAvatar(
                  backgroundImage: NetworkImage(mainImage!),
                  radius: 70,
                ):
                CircleAvatar(
                  child: Icon(Icons.add_a_photo),
                  radius: 70,
                )
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: meat_controller,
              onFieldSubmitted: (value) {
                dataSubmit();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  label: Text("Meats"),
                  hintText: "Enter the Name of Meat"
              ),
            ),
            trailing: CircleAvatar(
              child: InkWell(
                  onTap: () {
                    dataSubmit();
                  },
                  child: Icon(Icons.add)),
            ),
          ),

          ref.watch(streamMeatTypeProvider).when(
              data: (data) {

                return
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:Text("${index+1}.",style: TextStyle(
                            color: colorConst.canvasColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                          ),),
                          title: Text(data[index].type,style: TextStyle(
                              color: colorConst.canvasColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                          ),),
                          trailing: InkWell(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Are you sure you want to delete this Item?",
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
                                            onTap: () {
                                              FirebaseFirestore.instance.collection("meatTypes").doc(data[index].type).delete();
                                              Navigator.pop(context);
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
              loading: () => Lottie.asset(gifs.loadingGif),)
        ],
      ),
    );
  }
}
