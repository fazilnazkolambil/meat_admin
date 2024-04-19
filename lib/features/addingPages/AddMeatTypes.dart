import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/main.dart';
import 'package:meat_admin/models/CategoryModel.dart';

import '../add_meat_types/controller/controller_page.dart';

class AddMeatTypes extends ConsumerStatefulWidget {
  const AddMeatTypes({super.key});

  @override
  ConsumerState<AddMeatTypes> createState() => _AddMeatTypesState();
}

class _AddMeatTypesState extends ConsumerState<AddMeatTypes> {










  TextEditingController meat_controller = TextEditingController();
  int num = 1;




  dataSubmit(){
    CategoryModel categoryModel = CategoryModel(type: meat_controller.text, mainImage: mainImage.toString());

    ref.watch(meatTypesController).meatAdd(categoryModel);

    meat_controller.clear();
    mainImage=null;
    setState(() {

    });
    // FirebaseFirestore.instance.collection("meatTypes").doc(meat_controller.text).set({
    //   "type" : meat_controller.text,
    //   "mainImage": mainImage
    // }).then((value) =>
    //     meat_controller.clear()
    // );

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorConst.primaryColor,
        title: Text("Meats"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                selectfile("name");
              },
              child: mainImage != null ?
              CircleAvatar(
                backgroundImage: NetworkImage(mainImage!),
              ):
                  CircleAvatar(
                    child: Icon(Icons.add_a_photo),
                  )
            ),
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
                    if(
                    meat_controller.text !="" &&
                    mainImage != null
                    ){
                      dataSubmit();
                    }else{
                      mainImage == null ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select an Image!"))):
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Data!")));
                    }

                  },
                  child: Icon(Icons.add)),
            ),
          ),

          ref.watch(streamCategoryProvider).when(
              data: (data) {
                return
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:Text("${index+1}."),
                          title: Text(data[index].type),
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
                                              height: scrHeight*0.04,
                                              width: scrWidth*0.1,
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
                                              height: scrHeight*0.04,
                                              width: scrWidth*0.1,
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
                  
                              child: Icon(CupertinoIcons.delete)),
                        );
                      }),
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => CircularProgressIndicator(),)
        ],
      ),
    );
  }
}
