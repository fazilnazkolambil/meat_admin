class MeatTypeModel{
  String type;
  String mainImage;
  MeatTypeModel({
    required this.type,
    required this.mainImage
});
  Map<String,dynamic>toMap(){
    return{
      "type":this.type,
      "mainImage":this.mainImage,
    };
  }
  factory MeatTypeModel.fromMap(Map<String,dynamic>map){
    return MeatTypeModel(
        type: map["type"]??"",
        mainImage: map["mainImage"]??"",
    );
  }
  MeatTypeModel copyWith({
    String? type,
    String? mainImage
})
  {
    return MeatTypeModel(
        type: type??this.type,
        mainImage: mainImage??this.mainImage);
  }
}