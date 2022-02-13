import 'dart:convert';

CarModel carModelFromJson(String str) => CarModel.fromJson(json.decode(str));

String carModelToJson(CarModel data) => json.encode(data.toJson());

class CarModel {
  CarModel({
    this.image,
    this.brand,
    this.name,
  });

  String? image;
  String? brand;
  String? name;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    image: json["image"],
    brand: json["brand"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "brand": brand,
    "name": name,
  };
}
