class MeatModel{
  String? image, category, name, ingredients, rate, quantity, description, id;
  MeatModel({ this.image, this.category, this.name, this.ingredients, this.rate, this.quantity, this.description, this.id});

  Map <String, dynamic> toMap(){
    return {
      "Image" : this.image,
      "category" : this.category,
      "name" : this.name,
      "ingredients" : this.ingredients,
      "rate" : this.rate,
      "quantity" : this.quantity,
      "description" : this.description,
      "id" : this.id,
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
      id: map["id"] ?? "",
    );
}
MeatModel copyWith({
    String? image, category, name, ingredients, rate, quantity, description, id
}){
    return MeatModel(
      image: image ?? this.image,
      category: category ?? this.category,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      rate: rate ?? this.rate,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      id: id ?? this.id,
    );
}
}