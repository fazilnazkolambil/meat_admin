import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';

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
                stream: FirebaseFirestore.instance.collection("category").snapshots(),
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
                                FirebaseFirestore.instance.collection("category").doc(data[index]["category"]).delete();
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
