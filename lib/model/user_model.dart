// class UserModel {
//   String? uid;
//   String? email;
//   String? firstName;
//   String? secondName;
//
//   UserModel({this.uid, this.email, this.firstName, this.secondName});
//
//   //receive data from server
//   factory UserModel.fromMap(map) {
//     return UserModel(
//       uid: map['uid'],
//       email: map['email'],
//       firstName: map['firstName'],
//       secondName: map['secondName'],
//     );
//   }
//
//   //sending data to our server
//    Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'email': email,
//       'firstName': firstName,
//       'secondName': secondName,
//     };
//    }
// }


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








