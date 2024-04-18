import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';

import '../main.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController category_controller = TextEditingController();
  int num = 1;
  dataSubmit(){
    FirebaseFirestore.instance.collection("category").doc(category_controller.text).set({
      "category" : category_controller.text
    }).then((value) =>
        category_controller.clear()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorConst.primaryColor,
        title: Text("Categories"),
      ),
      body: Column(
        children: [
          ListTile(
            title: TextFormField(
              controller: category_controller,
              onFieldSubmitted: (value) {
                dataSubmit();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  label: Text("Categories"),
                  hintText: "Enter the Category"
              ),
            ),
            trailing: CircleAvatar(
              child: InkWell(
                  onTap: () {
                    if(
                    category_controller.text !=""
                    ){
                      dataSubmit();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Data!")));
                    }

                  },
                  child: Icon(Icons.add)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("meatTypes").snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(child: Lottie.asset(gifs.loadingGif));
                  }
                  var data = snapshot.data!.docs;
                  return data.length == 0?
                  Center(child: Text("No Data!"))
                      :ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:Text("${index+1}."),
                          title: Text(data[index]["category"]),
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
                                              FirebaseFirestore.instance.collection("meatTypes").doc(data[index]["category"]).delete();
                                            },
                                            child: Container(
                                              height: scrHeight*0.02,
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
                      });
                }
            ),
          )
        ],
      ),
    );
  }
}
