import 'package:car_app/model/search_car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewCar extends StatefulWidget {
  final String value;

  const ViewCar(this.value, {Key? key}) : super(key: key);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {

  late AnimationController controller;
  String image="";
  String carName="";
  String price="";
  var isLoading = true;

  void initialState() {
    setState(() {
      isLoading = true;
    });
    SearchCar().searchByName(widget.value).then((QuerySnapshot docs) {
      image = docs.docs[0].get("image").toString();
      carName = docs.docs[0].get("brand").toString() + " " +
                docs.docs[0].get("name").toString();
      price = docs.docs[0].get("price").toString();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initialState();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black38
          ),
          onPressed: () {
            //go back button
            Navigator.of(context).pop();
          }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            !isLoading ? const CircularProgressIndicator() :
            Image.network(
              image,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const CircularProgressIndicator();
              },
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              carName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              //price with inr symbol
              '\u{20B9} $price',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
