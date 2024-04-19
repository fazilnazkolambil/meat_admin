import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/core/provider/provider_page.dart';
import 'package:meat_admin/models/CategoryModel.dart';
import 'package:meat_admin/models/MeatModel.dart';

final meatTypesRepository =
    Provider((ref) => TypesRepository(firestore: ref.watch(firestoreprovider)));

class TypesRepository {
  final FirebaseFirestore _firestore;

  TypesRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _meattypes => _firestore.collection("meatTypes");

  meatTypes(CategoryModel categoryModel) {
    //
    // CategoryModel categoryModel=CategoryModel(
    //     type: meatController,
    //     mainImage: mainImage);

    _meattypes.doc(categoryModel.type).set(categoryModel.toMap());
  }

  Stream<List<CategoryModel>> meatTypesStream() {
    return _meattypes.snapshots().map((data) => data.docs
        .map((e) => CategoryModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

// meatTypes(MeatModel meatModel){
//   _meattypes.doc("Beef").collection("Beef").doc("BeefCut").add(meatModel.toMap())
// }
}
