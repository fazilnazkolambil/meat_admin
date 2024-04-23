class CategoryModel{
  String category;
  CategoryModel({required this.category});

  Map<String,dynamic> toMap(){
    return {
     "category":this.category ,
    };
  }
  factory CategoryModel.fromMap(Map<String,dynamic> map){
    return CategoryModel(
        category: map["category"] ?? "",
    );

  }
  CategoryModel copyWith({
    String? category,
}){
    return CategoryModel(
        category: category ?? this.category,
    );
  }
}