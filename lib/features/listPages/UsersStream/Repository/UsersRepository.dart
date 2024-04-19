import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/core/provider/provider_page.dart';

import '../../../../models/userModel.dart';

final repositoryProvider =
    Provider((ref) => UsersRepository(firestore: ref.watch(firestoreprovider)));

class UsersRepository {
  final FirebaseFirestore _firestore;
  UsersRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users => _firestore.collection('users');

  Stream<List<UserModel>> usersStream() {
    return _users.snapshots().map((data) => data.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }
}
