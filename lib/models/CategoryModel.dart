class CategoryModel{
  String type;
  String mainImage;
  CategoryModel({
    required this.type,
    required this.mainImage
});
  Map<String,dynamic>toMap(){
    return{
      "type":this.type,
      "mainImage":this.mainImage,
    };
  }
  factory CategoryModel.fromMap(Map<String,dynamic>map){
    return CategoryModel(
        type: map["type"]??"",
        mainImage: map["mainImage"]??"",
    );
  }
  CategoryModel copyWith({
    String? type,
    String? mainImage
})
  {
    return CategoryModel(
        type: type??this.type,
        mainImage: mainImage??this.mainImage);
  }
}