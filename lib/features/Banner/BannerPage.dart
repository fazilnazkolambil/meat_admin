import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/features/IntroPages/newHomePage.dart';
import 'package:meat_admin/main.dart';
import 'package:meat_admin/models/BannerModel.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  TextEditingController mainName_controller = TextEditingController();

  mainName() {
    FirebaseFirestore.instance
        .collection("banner")
        .doc("MeatShop")
        .set({"appName": mainName_controller.text, "appImage": mainImage}).then(
            (value) => mainName_controller.clear());
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  headLine() async {
    await FirebaseFirestore.instance.collection("banner").doc("adds").update({
      "introTexts": FieldValue.arrayUnion([
        {
          "title": titleController.text,
          "subTitle": subtitleController.text
        }
      ])
    }).then(
      (value) {
        titleController.clear();
        subtitleController.clear();
      },
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("submitted Successfully")));
  }

  int num = 1;

  bool submit = false;

  PlatformFile? pickFile;
  Future selectfile(String name) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    pickFile = result.files.first;
    final fileBytes = result.files.first.bytes;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uploading...")));
    uploadFileToFirebase(name, fileBytes);
    setState(() {});
  }

  UploadTask? uploadTask;
  String? mainImage;
  bool loading = false;
  List  images  = [];
  int  itemCount = 0;
  bool noData = false;
  getImages() async {
    loading = true;
    var data = await FirebaseFirestore.instance.collection('banner').doc('adds').get();
    if(data.exists){
      itemCount = data['images'].length;
      images = data['images'];
      loading = false;
    }else{
      noData = true;
      showAdaptiveDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Add Banners?"),
              content: Text("Add a Banner Collection before continuing"),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NewHome(),), (route) => false);
                  },
                  child: Text("Not now",style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorConst.actionColor
                                )),
                ),
                InkWell(
                  onTap: () async {
                    var data = await FirebaseFirestore.instance.collection('banner').doc('adds').set(
                      BannerModel(
                          logo: '',
                          name: '',
                          images: [],
                          introTexts: []
                      ).toMap()
                    );
                    noData = false;
                    setState(() {

                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Collection added successfully!")));
                  },
                  child: Text("Add",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorConst.mainColor
                  )),
                ),

              ]
            );
          },
      );
      itemCount = 3;
      loading = false;
    }
    setState(() {

    });
  }
  Future uploadFileToFirebase(String name, file) async {
    loading = true;
    setState(() {});
    uploadTask = FirebaseStorage.instance
        .ref('Meats')
        .child(DateTime.now().toString())
        .putData(file, SettableMetadata(contentType: 'image/jpeg'));
    final snapshot = await uploadTask?.whenComplete(() {});
    mainImage = await snapshot?.ref.getDownloadURL();
    if(mainImage != null){
      images.add(mainImage);
    }
    setState(() {
      submit = true;
      loading = false;
    });
  }
  @override
  void initState() {
    getImages();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600;
    return noData?
        Scaffold(
          backgroundColor: colorConst.primaryColor,
          body: Center(
            child:Lottie.asset(gifs.loadingGif)
          ),
        ):
    Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: isSmallScreen?scrWidth*0.9:scrWidth*0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// --- Logo & Name Change ---
                    // SizedBox(
                    //   height: 100,
                    //   width: 100,
                    //   child: loading
                    //       ? Lottie.asset(gifs.loadingGif)
                    //       : GestureDetector(
                    //           onTap: () {
                    //             selectfile("name");
                    //           },
                    //           child: mainImage != null
                    //               ? CircleAvatar(
                    //                   radius: 50,
                    //                   backgroundImage: NetworkImage(mainImage!),
                    //                 )
                    //               : const CircleAvatar(
                    //                   child: Icon(Icons.add_a_photo),
                    //                   radius: 50,
                    //                 )),
                    // ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       height: 30,
                    //       width: 200,
                    //       child: TextFormField(
                    //         controller: mainName_controller,
                    //         onFieldSubmitted: (value) {
                    //           mainName();
                    //         },
                    //         decoration: InputDecoration(
                    //             border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(50)),
                    //             suffixIcon: GestureDetector(
                    //                 onTap: () {
                    //                   if (mainName_controller.text != "") {
                    //                     mainName();
                    //                   } else {
                    //                     mainImage == null
                    //                         ? ScaffoldMessenger.of(context)
                    //                             .showSnackBar(const SnackBar(
                    //                                 content: Text(
                    //                                     "Please Select an Image!")))
                    //                         : ScaffoldMessenger.of(context)
                    //                             .showSnackBar(const SnackBar(
                    //                                 content:
                    //                                     Text("Please enter Data!")));
                    //                   }
                    //                 },
                    //                 child: Icon(Icons.add)),
                    //             label: Text("Main Name"),
                    //             hintText: "Enter your main name"),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     SizedBox(
                    //       width: 150,
                    //       child:
                    //           StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    //               stream: FirebaseFirestore.instance
                    //                   .collection("banner")
                    //                   .doc("MeatShop")
                    //                   .snapshots(),
                    //               builder: (context, snapshot) {
                    //                 if (!snapshot.hasData) {
                    //                   return const Text("No data found!");
                    //                 }
                    //                 var data = snapshot.data!.data();
                    //                 return data!.isEmpty
                    //                     ? const Text("No banner found!")
                    //                     : SizedBox(
                    //                         child: Text(
                    //                           data['appName'],
                    //                           style: const TextStyle(
                    //                               color: colorConst.canvasColor,
                    //                               fontWeight: FontWeight.w600,
                    //                               fontSize: 15),
                    //                         ),
                    //                       );
                    //               }),
                    //     ),
                    //   ],
                    // ),
                    Text("Add Splash headings",style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: isSmallScreen? scrWidth*0.9:scrWidth*0.4,
                      child: TextFormField(
                        controller: titleController,
                        maxLength: 100,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text("Enter title here"),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: isSmallScreen? scrWidth*0.9:scrWidth*0.4,
                      child: TextFormField(
                        controller: subtitleController,
                        maxLength: 200,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            label: const Text("Enter subtitle here"),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: () {
                        if (titleController.text != "" &&
                            subtitleController.text != "") {
                          headLine();
                        } else {
                          titleController.text == ""
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter a title!")))
                              : subtitleController.text == ""
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Please enter a subtitle!")))
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Please enter valid details")));
                        }
                      },
                      child: Container(
                          height: scrHeight * 0.05,
                          width: scrHeight * 0.1,
                          decoration: BoxDecoration(
                            color: colorConst.canvasColor,
                            borderRadius: BorderRadius.circular(scrHeight * 0.07),
                          ),
                          child: Center(
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: colorConst.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: scrHeight * 0.02)))),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: scrHeight * 0.3,
                      width: scrHeight * 0.8,
                      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("banner")
                              .doc("adds")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Lottie.asset(gifs.loadingGif,height: isSmallScreen?100:200),
                              );
                            }
                            var data = snapshot.data!.data();
                            List introText = data!["introTexts"];
                            return introText.isEmpty
                                ? Center(
                                    child: Text("No data found!"),
                                  )
                                : ListView.builder(
                                    itemCount: introText.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                          introText[index]["title"],
                                          style: TextStyle(
                                              color: colorConst.canvasColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        subtitle: Text(
                                          introText[index]["subTitle"],
                                          style: TextStyle(
                                              color: colorConst.canvasColor,
                                              fontSize: 15),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Are you sure you want to delete this Headings?",
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
                                                         await FirebaseFirestore.instance.collection("banner").doc('adds').update({
                                                            'introTexts' : FieldValue.arrayRemove([introText[index]])
                                                          });
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
                                          child: Icon(
                                            CupertinoIcons.delete,
                                            color: colorConst.red,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          }),
                    ),
                    if(isSmallScreen)
                      Divider(),
                    if(isSmallScreen)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                itemCount++;
                                setState(() {

                                });
                              },
                              icon: Icon(Icons.add)
                          ),
                          Text('Add Banner Images',style: TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                          submit == true?
                          InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance.collection('banner').doc('adds').update({
                                "images" : images
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Images added successfully!")));
                            },
                            child: Text("Update",style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorConst.mainColor,
                            ),),
                          ):SizedBox(),
                        ],
                      ),
                    SizedBox(height: 20,),
                    if(isSmallScreen)
                      SizedBox(
                        height: scrHeight * 0.5,
                        child: GridView.builder(
                          itemCount:itemCount,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return loading?
                            Lottie.asset(gifs.loadingGif):InkWell(
                                onTap: () async{
                                  selectfile("name");
                                },
                                child: images.isNotEmpty && index < images.length?
                                Container(
                                  height: scrHeight*0.4,
                                  width: scrWidth*1,
                                  margin: EdgeInsets.all(scrWidth*0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      image:images.isEmpty?
                                      DecorationImage(
                                          image: NetworkImage(mainImage!),fit: BoxFit.fill)
                                          :DecorationImage(
                                          image: NetworkImage(images[index]),fit: BoxFit.fill),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset:Offset(0, 4)
                                        )
                                      ]
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(child: Icon(Icons.add_a_photo_outlined)),
                                      Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Are you sure you want to delete this Image?",
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
                                                              images.removeAt(index);
                                                              submit = true;
                                                              setState(() {

                                                              });
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
                                              child: Icon(Icons.delete_outline,color: Colors.red,))
                                      )
                                    ],
                                  ),
                                )
                                    :Container(
                                  height: scrHeight*0.4,
                                  width: scrWidth*1,
                                  margin: EdgeInsets.all(scrWidth*0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset:Offset(0, 4)
                                        )
                                      ]
                                  ),
                                  child: Icon(Icons.add_a_photo_outlined),
                                )

                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
            if(!isSmallScreen)
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Banner Images',style: TextStyle(
                      fontWeight: FontWeight.bold,
                  )),
                  SizedBox(
                    height: itemCount>4?scrHeight*0.8:scrHeight * 0.6,
                    width: scrWidth*0.4,
                    child:
                    GridView.builder(
                      itemCount:itemCount,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.4
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return
                          loading? Lottie.asset(gifs.loadingGif):
                        InkWell(
                            onTap: () async{
                              selectfile("name");
                            },
                            child: images.isNotEmpty && index < images.length?
                            Container(
                              height: scrHeight*0.4,
                              width: scrWidth*1,
                              margin: EdgeInsets.all(scrWidth*0.03),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image:images.isEmpty?
                                  DecorationImage(
                                      image: NetworkImage(mainImage!),fit: BoxFit.fill)
                                      :DecorationImage(
                                      image: NetworkImage(images[index]),fit: BoxFit.fill),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset:Offset(0, 4)
                                    )
                                  ]
                              ),
                              child:
                              Stack(
                                children: [
                                  Center(child: Icon(Icons.add_a_photo_outlined)),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Are you sure you want to delete this Image?",
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
                                                          images.removeAt(index);
                                                          submit = true;
                                                          // await FirebaseFirestore.instance.collection('banner').doc('images').update({
                                                          //   'images' : FieldValue.arrayRemove([images[index]])
                                                          // });
                                                          setState(() {
              
                                                          });
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
                                          child: Icon(Icons.delete_outline,color: Colors.red,))
                                  )
                                ],
                              ),
                            )
                                :Container(
                              height: scrHeight*0.4,
                              width: scrWidth*1,
                              margin: EdgeInsets.all(scrWidth*0.03),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset:Offset(0, 4)
                                    )
                                  ]
                              ),
                              child: Icon(Icons.add_a_photo_outlined),
                            )
              
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          itemCount++;
                          setState(() {
              
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorConst.green
                          ),
                          child: Center(child: Text("Add Box",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorConst.primaryColor,
                          ),)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      submit == true?
                      InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance.collection('banner').doc('adds').update({
                            "images" : images
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated successfully!")));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorConst.mainColor
                          ),
                          child: Center(child: Text("Update",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorConst.primaryColor,
                          )),),
                        ),
                      ):SizedBox(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
