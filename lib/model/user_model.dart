import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.email,
    this.firstName,
    this.secondName,
    this.uid,
  });

  String? email;
  String? firstName;
  String? secondName;
  String? uid;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    firstName: json["firstName"],
    secondName: json["secondName"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "firstName": firstName,
    "secondName": secondName,
    "uid": uid,
  };
}
