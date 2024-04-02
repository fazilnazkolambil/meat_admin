class MeatModel{
  String? image, category, name, ingredients, rate, quantity, description;
  MeatModel({ this.image, this.category, this.name, this.ingredients, this.rate, this.quantity, this.description});

  Map <String, dynamic> toMap(){
    return {
      "Image" : this.image,
      "category" : this.category,
      "name" : this.name,
      "ingredients" : this.ingredients,
      "rate" : this.rate,
      "quantity" : this.quantity,
      "description" : this.description,
    };
}
factory MeatModel.fromMap(Map <String, dynamic> map){
    return MeatModel(
      image: map["image"] ?? "",
      category: map["category"] ?? "",
      name: map["name"] ?? "",
      ingredients: map["ingredients"] ?? "",
      rate: map["rate"] ?? "",
      quantity: map["quantity"] ?? "",
      description: map["description"] ?? "",
    );
}
MeatModel copyWith({
    String? image, category, name, ingredients, rate, quantity, description
}){
    return MeatModel(
      image: image ?? this.image,
      category: category ?? this.category,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      rate: rate ?? this.rate,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
}
}