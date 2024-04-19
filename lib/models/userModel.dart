class UserModel{
  String? name, email, number, password, image, id;
  List? address, favourites;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    required this.address,
    required this.favourites,
    required this.image,
    required this.id,
  });

Map <String, dynamic> toMap(){
  return{
    "name" : this.name,
    "email" : this.email,
    "number" : this.number,
    "password" : this.password,
    "address" : this.address,
    "favourites" : this.favourites,
    "image" : this.image,
    "id" : this.id,
  };
}
 factory UserModel.fromMap (Map <String, dynamic> map){
  return UserModel (
    name : map["name"] ?? "",
    email : map["email"] ?? "",
    number : map["number"] ?? "",
    password : map["password"] ?? "",
    address: map["address"] ?? [],
    favourites: map["favourites"] ?? [],
    image: map["image"]??[],
    id: map["id"]??[],
  );
 }
UserModel copyWith({
  String? name, email, number, password, confirmPassword, id, image,
  List? address, favourites
}){
  return UserModel(
    name: name ?? this.name,
    email: email ?? this.email,
    number: number ?? this.number,
    password: password ?? this.password,
    address: address ?? this.address,
    favourites: favourites ?? this.favourites,
    image: image ?? this.image,
    id: id ?? this.id,
  );
}

}