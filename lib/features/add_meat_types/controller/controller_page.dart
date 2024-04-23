import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/models/MeatTypeModel.dart';

import '../repository/Meat_types_repository.dart';


final meatTypesController=Provider((ref) => MeatTypesController(repository: ref.watch(meatTypesRepository)));

final streamCategoryProvider=StreamProvider((ref) => ref.watch(meatTypesController).streamCategory());

class MeatTypesController{
  final TypesRepository _repository;
  MeatTypesController({required TypesRepository repository}):_repository=repository;


  meatAdd(MeatTypeModel categoryModel){
    _repository.meatTypes(categoryModel);
  }

  Stream<List<MeatTypeModel>>streamCategory(){
    return _repository.meatTypesStream();
  }

}