import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/features/addingPages/repository/Add_meats_repository.dart';
import 'package:meat_admin/models/CategoryModel.dart';


final meatCategoryController= Provider((ref) => AddmeatCategoryController(repository: ref.watch(meatCategoryRepository)));

final streamCategoryControllerProvider=StreamProvider.family((ref,String type) => ref.watch(meatCategoryController).streamCategory(type: type));

class AddmeatCategoryController{
  final AddmeatCategoryRepository _repository;
  AddmeatCategoryController({required AddmeatCategoryRepository repository}):
      _repository=repository;

  meatCategory({required String type,required String categoryName}){
    _repository.meatCategory(
        type: type,
        categoryName: categoryName);
  }

  Stream<List<CategoryModel>>streamCategory({required String type}){
    return _repository.meatCategoryStream(type: type);
  }
}