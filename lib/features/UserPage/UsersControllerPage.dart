import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/features/UserPage/UsersRepository.dart';
import 'package:meat_admin/models/userModel.dart';
final controllerProvider=Provider((ref) => UsersController(repository: ref.watch(repositoryProvider)));

final streamUsersDataStreamProvider=StreamProvider.family((ref,String search) => ref.watch(controllerProvider,).streamData(search));



class UsersController{
  final UsersRepository _repository;
  UsersController({
    required UsersRepository repository
}):_repository=repository;

  Stream<List<UserModel>> streamData(String search){
    return _repository.usersStream(search);
  }

}