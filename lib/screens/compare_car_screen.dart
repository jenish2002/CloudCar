import 'dart:ui' as ui;
import 'package:car_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CompareCarScreen extends StatefulWidget {
  const CompareCarScreen({Key? key}) : super(key: key);

  @override
  _CompareCarScreenState createState() => _CompareCarScreenState();
}

class _CompareCarScreenState extends State<CompareCarScreen>{

  ScrollController scrollController = ScrollController();
  late double _width;
  late double _height;
  String? carid1;
  String? carid2;
  
  _navigateNextPageAndRetriveValue(BuildContext context) async {
    List nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchScreen("compare")),
    );
    setState(() {
      if(carid1 == null) {
        carid1 = nextPageValues[0];
        carid2 = nextPageValues[1];
      }
      else {
        carid2 = nextPageValues[0];
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
                      onPressed: () => { Navigator.of(context).pop() },
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
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      print(carid1);
                      print(carid2);
                      _navigateNextPageAndRetriveValue(context);
                      FocusScope.of(context).unfocus();
                    },
                    child: selectCarDesign(_height, _width),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "vs",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print(carid1);
                      print(carid2);
                      _navigateNextPageAndRetriveValue(context);
                      FocusScope.of(context).unfocus();
                    },
                    child: selectCarDesign(_height, _width),
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
              ),
            ),
          ],
        ),),
      ),
    );
  }
}

Widget selectCarDesign(_height, _width) {
  return Container(
    width: _width / 2.5,
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
      children: const <Widget>[
        Icon(
          Icons.directions_car_filled_rounded,
          color: Colors.black54,
          size: 80,
        ),
        SizedBox(height: 10),
        Text(
          "Select Car",
          style: TextStyle(
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}