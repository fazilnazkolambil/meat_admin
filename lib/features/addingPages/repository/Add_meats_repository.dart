import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/core/provider/provider_page.dart';

final meatCategoryRepository=
    Provider((ref) => AddmeatCategoryRepository(firestore: ref.watch(firestoreprovider)));


class AddmeatCategoryRepository{
  final FirebaseFirestore _firestore;

  AddmeatCategoryRepository({required FirebaseFirestore firestore}):
      _firestore=firestore;

  CollectionReference get _meatcategory=>_firestore.collection("meatTypes");

  meatCategory({required String type,required String categoryName}){
    _meatcategory.doc(type).collection(type).doc(categoryName).set({
      "category" : categoryName
    });
  }
  
  // meatCategoryStream(){
  //   return _meatcategory.snapshots().map((data) => data.docs
  //   .map((e) => null)
  //   );
  // }
}