class MeatModel{
  String image, name, ingredients, description, id;
  int quantity;
  double rate;
  MeatModel({ required this.image, required this.name, required this.ingredients, required this.rate, required this.description, required this.id, required this.quantity});

  Map <String, dynamic> toMap(){
    return {
      "Image" : this.image,
      "name" : this.name,
      "ingredients" : this.ingredients,
      "rate" : this.rate,
      "description" : this.description,
      "id" : this.id,
      "quantity" : this.quantity,
    };
}
factory MeatModel.fromMap(Map <String, dynamic> map){
    return MeatModel(
      image: map["image"] ?? "",
      name: map["name"] ?? "",
      ingredients: map["ingredients"] ?? "",
      rate: map["rate"] ?? "",
      description: map["description"] ?? "",
      id: map["id"] ?? "",
      quantity: map["quantity"] ?? "",
    );
}
MeatModel copyWith({
    String? image, category, type, name, ingredients, description, id,
    int? quantity, rate
}){
    return MeatModel(
      image: image ?? this.image,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      rate: rate ?? this.rate,
      description: description ?? this.description,
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
    );
}
}