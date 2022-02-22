import 'dart:ui' as ui;
import 'package:car_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CompareCarScreen extends StatefulWidget {
  const CompareCarScreen({Key? key}) : super(key: key);

  @override
  _CompareCarScreenState createState() => _CompareCarScreenState();
}

class _CompareCarScreenState extends State<CompareCarScreen>{

  ScrollController scrollController = ScrollController();
  late double _width;
  late double _height;
  bool isVisible = true;
  String? carname1;
  String? carname2;
  int clicked = 0;
  
  _navigateNextPageAndRetriveValue(BuildContext context) async {
    List nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SearchScreen("compare")),
    );
    setState(() {
      if(clicked == 1 && nextPageValues[0] != null) {
        if(carname2 == nextPageValues[0]) {
          carname1 = null;
          Fluttertoast.showToast(msg: "Can't compare same model");
        }
        else {
          carname1 = nextPageValues[0];
        }
      }
      else if(clicked == 2 && nextPageValues[0] != null) {
        if(carname1 == nextPageValues[0]) {
          carname2 = null;
          Fluttertoast.showToast(msg: "Can't compare same model");
        }
        else {
          carname2 = nextPageValues[0];
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black54,
                      ),
                      onPressed: () => {
                        if(isVisible) {
                          Navigator.of(context).pop()
                        }
                        else
                        {
                          setState(() {
                            isVisible = true;
                          })
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Compare Car",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black26, height: 5, thickness: 2),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
                child: (isVisible) ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        clicked = 1;
                        _navigateNextPageAndRetriveValue(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: selectCarDesign(_height, _width, carname1),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "VS",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        clicked = 2;
                        _navigateNextPageAndRetriveValue(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: selectCarDesign(_height, _width, carname2),
                    ),
                    const SizedBox(height: 60),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.redAccent,
                      child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: _width - 50,
                        onPressed: () {
                          if(carname1 != null && carname2 != null) {
                            setState(() {
                              isVisible = false;
                            });
                          }
                          else {
                            Fluttertoast.showToast(msg: "Select cars to compare");
                          }
                        },
                        child: const Text("Compare Cars", textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ) :
                displayCar(_height, _width, carname1, carname2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget displayCar(_height, _width, carname1, carname2) {
  return SingleChildScrollView(
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      ],
    ),
  );
}

Widget selectCarDesign(_height, _width, car_name) {
  return Container(
    width: _width - 40,
    height: _height / 5,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.redAccent,
        width: 3
      ),
      borderRadius: const BorderRadius.all(Radius.circular(20))
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.directions_car_filled_rounded,
          color: Colors.black54,
          size: 75,
        ),
        const SizedBox(height: 15),
        Text(
          (car_name != null) ? car_name : "Select Car",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}