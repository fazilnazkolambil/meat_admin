import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/main.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {

  TextEditingController mainName_controller = TextEditingController();

  mainName(){
    FirebaseFirestore.instance.collection("banner").doc("MeatShop").set(
        {
          "appName":mainName_controller.text,
          "appImage":mainImage
        }).then((value) => mainName_controller.clear());
  }

  int num=1;

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
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: loading? Lottie.asset(gifs.loadingGif):
                GestureDetector(
                  onTap: () {
                    selectfile("name");
                  },
                  child: mainImage != null ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(mainImage!),
                  ):
                  CircleAvatar(
                    child: Icon(Icons.add_a_photo),
                    radius: 50,
                  )
                ),
              ),
             Row(

               children: [
                 SizedBox(
                   height: 30,
                   width: 200,
                   child: TextFormField(
                     controller: mainName_controller,
                     onFieldSubmitted: (value) {
                       mainName();
                     },
                     decoration: InputDecoration(
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(50)
                         ),
                         suffixIcon: GestureDetector(
                           onTap: () {
                             if(
                             mainName_controller.text !=""
                             ){
                               mainName();
                             }else{
                               mainImage == null ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select an Image!"))):
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Data!")));
                             }
                           },
                             child: Icon(Icons.add)),
                         label: Text("Main Name"),
                         hintText: "Enter your main name"
                     ),
                   ),
                 ),
                 SizedBox(width: 10,),
                 SizedBox(
                   width: 150,
                   child: StreamBuilder<QuerySnapshot>(
                       stream: FirebaseFirestore.instance.collection("banner").snapshots(),
                       builder: (context, snapshot) {
                         if(!snapshot.hasData){
                           return Text("No data found!");
                         }
                         var data = snapshot.data!.docs;
                         return data.length==0
                             ? Text("No banner found!"):
                         ListView.builder(
                           shrinkWrap: true,
                           itemCount: 1,
                           itemBuilder: (BuildContext context, int index) {
                             return  SizedBox(
                               child: Text(data[index]['appName'],style: TextStyle(
                                   color: colorConst.canvasColor,
                                   fontWeight: FontWeight.w600,
                                   fontSize: 15
                               ),),
                             );
                           },
                         );
                       }
                   ),
                 ),
               ],
             ),

              Row(
                children: [
                  Container(
                    height: scrWidth*0.04,
                    width: scrHeight*0.7,
                    // color: colorConst.mainColor,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          label: Text("Headline"),
                          hintText: "Enter your Headline"
                      ),
                    ),
                  ),
                  SizedBox(width: 0.5,),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: scrWidth*0.04,
                    width: scrHeight*0.7,
                    // color: colorConst.mainColor,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          label: Text("SubHeadline"),
                          hintText: "Enter your Subheadline"
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  height: scrHeight * 0.05,
                  width: scrHeight * 0.1,
                  decoration: BoxDecoration(
                    color: colorConst.canvasColor,
                    borderRadius:
                    BorderRadius.circular(scrHeight * 0.07),
                  ),
                  child: Center(
                      child: Text("Submit",
                          style: TextStyle(
                              color: colorConst.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: scrHeight * 0.02)))),

              SizedBox(
                height: scrHeight*0.4,
                width: scrHeight*0.8,
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return  ListTile(
                      leading: Text("",style: TextStyle(
                          color: colorConst.canvasColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15
                      ),),
                      title: Text("",style: TextStyle(
                          color: colorConst.canvasColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15
                      ),),
                      trailing: Icon(CupertinoIcons.delete,color: colorConst.red,),
                    );
                  },
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: scrHeight*1,
                width: scrWidth*0.47,
               // color: colorConst.mainColor,
               child: GridView.builder(
                 itemCount: 12,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3,
                   mainAxisSpacing: scrWidth * 0.02 ,
                   childAspectRatio:1.5 ,
                   crossAxisSpacing: scrWidth* 0.02,
                 ),
                 itemBuilder: (BuildContext context, int index) {
                   return  Container(
                     height: 20,
                     width: scrWidth*0.1,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(scrWidth*0.01),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.15),
                           offset: Offset(0, 4),
                           blurRadius: 4,
                           spreadRadius: 2,
                         )
                       ]
                   ),
                   );
                 },
               ),
              )
            ],
          )
        ],
      ),
    );
  }
}
