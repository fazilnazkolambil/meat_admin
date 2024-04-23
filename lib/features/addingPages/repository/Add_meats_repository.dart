import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/core/provider/provider_page.dart';
import 'package:meat_admin/models/CategoryModel.dart';

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
  
  Stream<List<CategoryModel>> meatCategoryStream({required String type}){
    return _meatcategory.doc(type).collection(type).snapshots().map((data) => data.docs
    .map((e) => CategoryModel.fromMap(e.data() as Map<String,dynamic>)).toList()
    );
  }
}