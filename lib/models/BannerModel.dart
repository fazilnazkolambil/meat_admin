class BannerModel  {
  String? logo, name;
  List? images, introTexts;
  BannerModel({
    required this.logo,
    required this.name,
    required this.images,
    required this.introTexts,
});
  Map <String,dynamic> toMap(){
    return {
      'logo' : this.logo ?? "",
      'name' : this.name ?? "",
      'images' : this.images ?? [],
      'introTexts' : this.introTexts ?? [],
    };
  }
  factory BannerModel.fromMap(Map <String, dynamic> map){
    return BannerModel(
        logo: map['logo'] ?? '',
        name: map['name'] ?? '',
        images: map['images'] ?? '',
        introTexts: map['introTexts'] ?? '',
    );
  }
  BannerModel copyWith({
    String? logo,name,
    List? images, introTexts,
}){
    return BannerModel(
        logo: logo ?? this.logo,
        name: name ?? this.name,
        images: images ?? this.images,
        introTexts: introTexts ?? this.introTexts
    );
  }
}
