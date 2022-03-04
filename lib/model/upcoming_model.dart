import 'dart:convert';

UpcomingModel UpcomingModelFromJson(String str) => UpcomingModel.fromJson(json.decode(str));

String UpcomingModelToJson(UpcomingModel data) => json.encode(data.toJson());

class UpcomingModel {
  UpcomingModel({
    this.image,
    this.name,
    this.price,
    this.date,
    this.fuelType,
  });

  String? image;
  String? name;
  String? price;
  String? date;
  String? fuelType;

  factory UpcomingModel.fromJson(Map<String, dynamic> json) => UpcomingModel(
    image: json["image"],
    name: json["name"],
    price: json["price"],
    date: json["date"],
    fuelType: json["fuel_type"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "price": price,
    "date" : date,
    "fuelType": fuelType,
  };
}