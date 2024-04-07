import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:meat_admin/core/colorPage.dart';
import 'package:meat_admin/core/imageConst.dart';
import 'package:meat_admin/main.dart';

class MeatPage extends StatefulWidget {
  const MeatPage({super.key});

  @override
  State<MeatPage> createState() => _MeatPageState();
}

class _MeatPageState extends State<MeatPage> {
  TextEditingController meat_controller = TextEditingController();
  int num = 1;
  dataSubmit(){
    FirebaseFirestore.instance.collection("meatTypes").doc(meat_controller.text).set({
      "type" : meat_controller.text
    }).then((value) =>
        meat_controller.clear()
    );
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
            leading: CircleAvatar(
              
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
                    meat_controller.text !=""
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
                          title: Text(data[index]["type"]),
                          trailing: InkWell(
                              onTap: () {
                                FirebaseFirestore.instance.collection("meatTypes").doc(data[index]["type"]).delete();
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
