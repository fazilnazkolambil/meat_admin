import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meat_admin/features/addingPages/repository/Add_meats_repository.dart';

final meatCategoryController= Provider((ref) => AddmeatCategoryController(repository: ref.watch(meatCategoryRepository)));

class AddmeatCategoryController{
  final AddmeatCategoryRepository _repository;
  AddmeatCategoryController({required AddmeatCategoryRepository repository}):
      _repository=repository;

  meatCategory({required String type,required String categoryName}){
    _repository.meatCategory(
        type: type,
        categoryName: categoryName);
  }
}