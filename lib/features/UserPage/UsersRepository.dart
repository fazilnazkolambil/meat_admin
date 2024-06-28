import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/core/provider/provider_page.dart';

import '../../models/userModel.dart';

final repositoryProvider = Provider((ref) => UsersRepository(firestore: ref.watch(firestoreprovider)));

class UsersRepository {
  final FirebaseFirestore _firestore;
  UsersRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users => _firestore.collection('users');


  Stream<List<UserModel>> usersStream(String search) {
    
    if(search == ''){
      return _users.snapshots()
          .map((data) => data.docs.map((e) => UserModel.fromMap(e.data() as Map <String,dynamic>)).toList());
      // return _users.snapshots().map((data) => data.docs
      //     .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
      //     .toList());
    }else{
      return _users.where("search", arrayContains: search.toUpperCase())
          .snapshots().map((data) => data.docs.map((value) => UserModel.fromMap(value.data() as Map<String,dynamic>)).toList());
      // return _users.where('search',arrayContains: search.toUpperCase()).snapshots().map((data) => data.docs
      //     .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
      //     .toList());
    }
    
   
  }
}
