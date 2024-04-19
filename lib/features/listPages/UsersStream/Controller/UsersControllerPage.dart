import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/features/listPages/UsersStream/Repository/UsersRepository.dart';
import 'package:meat_admin/models/userModel.dart';
final controllerProvider=Provider((ref) => UsersController(repository: ref.watch(repositoryProvider)));

final streamUsersDataStreamProvider=StreamProvider((ref) => ref.watch(controllerProvider).streamData());



class UsersController{
  final UsersRepository _repository;
  UsersController({
    required UsersRepository repository
}):_repository=repository;

  Stream<List<UserModel>> streamData(){
    return _repository.usersStream();
  }

}