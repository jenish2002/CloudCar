import 'dart:convert';

CarModel CarModelFromJson(String str) => CarModel.fromJson(json.decode(str));

String CarModelToJson(CarModel data) => json.encode(data.toJson());

class CarModel {
  CarModel({
    this.carId,
    this.image,
    this.brand,
    this.name,
    this.price,
    this.variant,
    this.bodyType,
    this.colours,
    this.seats,
    this.engine,
    this.transmission,
    this.fuelType,
    this.fuelTank,
    this.mileage,
    this.power,
    this.torque,
    this.cylinders,
    this.gears,
    this.airbags,
    this.audioSystem,
    this.powerWindows,
    this.drivetrain,
    this.emissionNorm,
    this.frontBrakes,
    this.rearBrakes,
    this.groundClearance,
    this.height,
    this.length,
    this.width,
    this.weight,
    this.wheels,
  });

  String? carId;
  String? image;
  String? brand;
  String? name;
  String? price;
  String? variant;
  String? bodyType;
  String? colours;
  String? seats;
  String? engine;
  String? transmission;
  String? fuelType;
  String? fuelTank;
  String? mileage;
  String? power;
  String? torque;
  String? cylinders;
  String? gears;
  String? airbags;
  String? audioSystem;
  String? powerWindows;
  String? drivetrain;
  String? emissionNorm;
  String? frontBrakes;
  String? rearBrakes;
  String? groundClearance;
  String? height;
  String? length;
  String? width;
  String? weight;
  String? wheels;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    carId: json["carId"],
    image: json["image"],
    brand: json["brand"],
    name: json["name"],
    price: json["price"],
    variant: json["variant"],
    bodyType: json["body_type"],
    colours: json["colours"],
    seats: json["seats"],
    engine: json["engine"],
    transmission: json["transmission"],
    fuelType: json["fuel_type"],
    fuelTank: json["fuel_tank"],
    mileage: json["mileage"],
    power: json["power"],
    torque: json["torque"],
    cylinders: json["cylinders"],
    gears: json["gears"],
    airbags: json["airbags"],
    audioSystem: json["audio_system"],
    powerWindows: json["power_windows"],
    drivetrain: json["drivertrain"],
    emissionNorm: json["emission_norm"],
    frontBrakes: json["front_brakes"],
    rearBrakes: json["rear_brakes"],
    groundClearance: json["ground_clearance"],
    height: json["height"],
    length: json["length"],
    width: json["width"],
    weight: json["weight"],
    wheels: json["wheels"],
  );

  Map<String, dynamic> toJson() => {
    "carId": carId,
    "image": image,
    "brand": brand,
    "name": name,
    "price": price,
    "variant": variant,
    "body_type": bodyType,
    "colours": colours,
    "seats": seats,
    "engine": engine,
    "transmission": transmission,
    "fuel_type": fuelType,
    "fuel_tank": fuelTank,
    "mileage": mileage,
    "power": power,
    "torque": torque,
    "cylinders": cylinders,
    "gears": gears,
    "airbags": airbags,
    "audio_system": audioSystem,
    "power_windows": powerWindows,
    "drivetrain": drivetrain,
    "emission_norm": emissionNorm,
    "front_brakes": frontBrakes,
    "rear_brakes": rearBrakes,
    "ground_clearance": groundClearance,
    "height": height,
    "length": length,
    "width": width,
    "weight": weight,
    "wheels": wheels,
  };
}
